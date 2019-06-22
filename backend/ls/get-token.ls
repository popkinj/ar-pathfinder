/* get-token.ls
  Fetch a fresh CAS token
  Dependencies: 
    The following environmnent variables:
    - AR_PATHFINDER_CAS_ID
    - AR_PATHFINDER_CAS_SECRET
    - AR_PATHFINDER_CAS_URL

  Can be executed like this:
  ```bash
  npm run get-token
  ```
 */

require! {
  request
}

# Get the credentials
id = process.env.AR_PATHFINDER_CAS_ID
secret = process.env.AR_PATHFINDER_CAS_SECRET
cas = process.env.AR_PATHFINDER_CAS_URL # The CAS API url
url = cas.replace /\/\//, "//#id:#secret@" # Insert credentials into url

# Make sure we have the credentials
unless id and secret
  throw console.error 'Environmnent variables not set'

payload = form: grant_type: 'client_credentials'

request
  .post url, payload , (err, res, body) ->
    throw console.error err if err
    console.log JSON.parse(body).access_token
