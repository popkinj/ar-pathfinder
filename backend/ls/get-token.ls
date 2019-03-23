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

url = "https://heineken.cas.gov.bc.ca:7019/ords/cas/oauth/token"

# Make sure we have the credentials
unless id and secret
  throw console.error 'Environmnent variables not set'

request
  .auth 'user': id, 'pass': secret
  .post url, (err, res, body) ->
    console.error err if err
    console.log res