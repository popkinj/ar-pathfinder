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
  request
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
  The oAuth token should be global because
  it has to be renewed at regular intervals
 */
token = ''


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
  console.log "cas: #cas"
  console.log "dev: #dev"


  # Make sure we have the credentials
  unless id and secret and cas
    throw console.error 'Environmnent variables not set'

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
  throw new Error e if  e
  token := t # This will get refreshed on interval

  /*
    The offset value is the index used for requesting 
    Proponents from CAS. Only 25 records can be downloaded
    at a time... So the first request would be zero. The next
    request would be 25... and so on.
  */
  res = await pgPool.query 'select count(*) from proponents_loading'
  offset = res.rows.0.count

  dev = process.env.AR_PATHFINDER_DEV_URL # The DEV API url
  url = "#dev/api/parties/?token=#{token.access_token}&offset=#offset"

  request url, (err,res,body) ->
    if err then console.error err
    console.log body



# Get token then kickoff harvest
getToken <| harvest




# TODO: Renew token every 30 minutes
