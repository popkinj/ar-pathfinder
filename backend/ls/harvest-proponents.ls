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
  request
}

getToken = (callback) ->

  # Get the credentials
  id = process.env.AR_PATHFINDER_CAS_ID
  secret = process.env.AR_PATHFINDER_CAS_SECRET
  cas = process.env.AR_PATHFINDER_CAS_URL # The CAS API url
  dev = process.env.AR_PATHFINDER_DEV_URL # The DEV API url

  # Are we in prod or dev
  prod = if process.env.NODE_ENV is \production then yes else no

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

# This is how to consume the getToken
getToken (e,token) -> console.log token