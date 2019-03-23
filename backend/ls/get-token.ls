/* get-token.ls
  Load a fresh CAS oAuth token into environment variable AR_PATHFINDER_CAS_TOKEN.
  Dependencies: 
    The following environmnent variables:
    - AR_PATHFINDER_CAS_ID
    - AR_PATHFINDER_CAS_SECRET
 */

# Get the credentials
id = process.env.AR_PATHFINDER_CAS_ID
secret = process.env.AR_PATHFINDER_CAS_SECRET
url = process.env.AR_PATHFINDER_CAS_URL

# Make sure we have the credentials
unless id and secret
  throw console.error 'Environmnent variables not set'

payload = 'grant_type': 'client_credentials'

request
  .auth 'user': id, 'pass': secret
  .post url, payload , (err, res, body) ->
    console.error err if err
    console.log res