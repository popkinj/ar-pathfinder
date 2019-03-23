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

unless id and secret # Make sure we have the credentials
  throw console.error 'Environmnent variable not set'
