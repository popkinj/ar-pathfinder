/* get-token.ls
  Load a fresh CAS oAuth token into environment variable AR_PATHFINDER_CAS_TOKEN.
  Dependencies: 
    The following environmnent variables:
    - AR_PATHFINDER_CAS_ID
    - AR_PATHFINDER_CAS_SECRET
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

payload = 'grant_type': 'client_credentials'

request
  .post url, payload , (err, res, body) ->
    console.error err if err
    console.log res