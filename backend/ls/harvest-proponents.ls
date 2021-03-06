/* harvest-proponents.ls
  Populate our cache with all the proponents in CAS.
  Dependencies: 
    The following environmnent variables:
    - AR_PATHFINDER_CAS_ID
    - AR_PATHFINDER_CAS_SECRET
    - AR_PATHFINDER_CAS_URL
    - AR_PATHFINDER_DEV_URL

  Can be executed like this:
  ```bash
  npm run harvest-proponents
  ```
 */

require! {
  pg
  async
  colors
  moment
  request
  \node-schedule # Maps to nodeSchedule
}

/* Connect to the database
  The database server varies in prod
*/
pgPool = new pg.Pool do
  user: process.env.AR_PATHFINDER_USERNAME
  database: process.env.AR_PATHFINDER_DATABASE
  password: process.env.AR_PATHFINDER_PASSWORD
  host: if prod then 'postgresql' else 'localhost'
  port: 5432
  max: 10
  idleTimeoutMillis: 30000


/*
  The oAuth token should be global because it has to
  be renewed at regular intervals within different scopes.
 */
token = ''

ts = -> moment!format('h:mm:ss a').grey

/* ## refreshToken
  This function handles the mutation of the global variable *token*
  @param e {string} Error message if any. Null if no error
  @param t {string} oAuth token
 */
refreshToken = (e,t) !->
  console.log ts! + ' - Refreshing token'
  throw new Error e if  e
  token := t

/*
  Schedule the renewal of the token for every 30 minutes
  The CAS token automatically expires after 1 hour
*/
schedule = nodeSchedule.scheduleJob '*/30 * * * *', !-> getToken refreshToken

# Are we in prod or dev
prod = if process.env.NODE_ENV is \production then yes else no

/* ## getToken
  Request a CAS oAuth token.
  If in dev/local the request gets proxied through 
  dev/openshift.
  @param callback {function} Function to be called after a token has been granted or denied. The function will be passed 1. An error message if present.. null if not. 2. A token string.
 */
getToken = (callback) !->

  # Get the credentials
  id = process.env.AR_PATHFINDER_CAS_ID
  secret = process.env.AR_PATHFINDER_CAS_SECRET
  cas = process.env.AR_PATHFINDER_CAS_URL # The CAS API url
  dev = process.env.AR_PATHFINDER_DEV_URL # The DEV API url

  # Make sure we have the credentials
  unless id and secret and cas
    throw console.error ts! + 'Environmnent variables not set'

  url = if prod
    cas
      .replace /\/\//, "//#id:#secret@" # Insert credentials into url
      .replace /$/, '/oauth/token' # Add token path
  else
    "#dev/api/get-token"

  fetcher = if prod then request.post else request.get

  payload = form: grant_type: 'client_credentials'

  fetcher url, payload , (err, code, body) !->
    if err
      callback err
    else
      try
        json = JSON.parse body
        callback null, do
          access_token: json.access_token
          expires_in: json.expires_in
      catch
        callback e.message


/* ## harvest
  Request proponents from CAS.
  The CAS API only dispenses 25 records at time.
  Keep requesting propnents until all have been transfered.
  This is an Async function
  @param e {string} Error message if any. Null if no error
  @param t {string} oAuth token
 */
harvest = (e,t) !->>
  refreshToken ... # Refresh the token

  /*
    The offset value is the index used for requesting 
    Proponents from CAS. Only 25 records can be downloaded
    at a time... So the first request would be zero. The next
    request would be 25... and so on.

    Querying the database allows us to start and stop the
    process midway.
  */
  try
    res = await pgPool.query 'select count(*) from proponents_loading'
    offset = parseInt res.rows.0.count
  catch
    throw console.error ts! + 'Failed to count downloaded Proponents', e

  dev = process.env.AR_PATHFINDER_DEV_URL # The DEV API url
  hasMore = yes # This determines the end of the harvest

  /* ### test
    The testing function for AsyncJS.
    @param _ {object} Result from the postgresSQL insert statement.. ignored.
    @param callback {function} AsyncJS callback function. It accepts two parameters. The first is an error message. If null the async function keeps running. The second value is a boolean for pass/fail.
   */
  test = (_,callback) !-> callback null, hasMore

  /* ### iterator
    The AsyncJS interator function that runs repeatedly until the test function returns *false*.
    @param callback {function} AsyncJS callback function. It accepts two parameters. The first is an error message. If null the async function keeps running. The second value is a boolean for pass/fail.
   */
  iterator = (callback) ->
    url = "#dev/api/parties/?token=#{token.access_token}&offset=#offset"
    console.log ts! + " - iterator: #offset"
    request url, (err,res,body) ->>
      if err then callback err # If request failed

      try
        json = JSON.parse body
      catch # Throw error if not valid json
        callback e

      # Set up the insert sql command
      sql = '''
        insert into proponents_loading
        (name, proponent_number, business_number)
        values 
      '''

      # Cycle through rows and form sql insert statement
      for row in json.items
        {customer_name,party_number,business_number} = row
        customer_name = customer_name.replace /'/g, "''"

        sql += """
          (
            '#{customer_name}',
            '#{party_number}',
            '#{business_number}'
          ),
        """
      sql = sql.replace /,$/,'' # Remove last comma

      hasMore := json.hasMore # global

      # Only increase offset if there were records
      offset := if json.items?length then offset + that else offset

      # Execute API query for next 25 records
      pgPool.query sql, callback


  /* ### done
    Run when AsyncJS has completed.
    The temporary table is copied into a brand new `proponents`
    table. Use a SQL transaction statement so there can't be any
    third party traffic until finished.
    @param err {string} Error message if one has occurred.
   */
  done = (err) !->>
    /*
      If there's an error anywhere in the AsyncJS workflow
      It will end up here.
      With the `async.doWhilst` function an error is triggered
      when the test fails (which is intentional). If `hasMore`
      is still true then it's a real error
     */
    if err and hasMore
      throw console.log ts! + ' - Failure: '.red, err
      pgPool.end! # Close DB connection
    else # No errors
      sql = '''
        begin;
          drop table proponents;
          create table proponents as
            select * from proponents_loading;
          create index proponents_idx on proponents(name);
        end;
      '''

      try
        await pgPool.query sql
      catch
        throw console.error ts! + 'Failed to load new table', e

      pgPool.end! # Close DB connection
      schedule.cancel! # Stop the token refresh
      console.log ts! + ' - complete'


  /*
    Request all Proponents/Parties. Insert into the temporary table
    as we go. When done, Turn off the *getToken* loop and copy the 
    temporary table into the main table.
   */
  async.doWhilst iterator, test, done

# Get token then kickoff harvest
getToken <| harvest
