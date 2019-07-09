/* Bare bones static file server */
require! {
  fs
  pg
  pug
  cors
  http
  morgan
  helmet
  express
  request
  \body-parser # Maps to bodyParser
  compression
}

/* eslint-disable */

# Are we in prod or dev
prod = if process.env.NODE_ENV is \production then yes else no

console.log 'username', process.env.AR_PATHFINDER_USERNAME
console.log 'database', process.env.AR_PATHFINDER_DATABASE
console.log 'password', process.env.AR_PATHFINDER_PASSWORD

/* Connect to the database
  The database server varies in prod
*/
pgPool = new pg.Pool do
  user: process.env.AR_PATHFINDER_USERNAME
  database: process.env.AR_PATHFINDER_DATABASE
  password: process.env.AR_PATHFINDER_PASSWORD
  host: if prod then 'postgresql' else 'localhost'
  port: 5432 # XXX: Temporary, should be 5432
  max: 10
  idleTimeoutMillis: 30000

testingDB = ->
  # pgPool.query 'select * from user_sessions', (err,res) ->
  pgPool.query 'select current_user', (err,res) ->
    if err then throw console.error that
    console.log "Database User #{res.rows.0.current_user}"

setTimeout testingDB, 1000

/* ## lost
  Router for anything we don't have an end point for.
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
lost = (req,res) ->
  res.status 404 .send '<p>Sorry... You must be lost &#x2639;.</p>'

/* ## testHtml
  Serving html file ala pug now
  Pass in the express parameters and the url query stuff
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
testHtml = (req,res) -> res.render 'test', req.params <<< req.query

/* ## testData
  Serving test data
  Pass in the express parameters and the url query stuff
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
testData = (req,res) -> res.json testing:true

/* ## notToday
  The deny access message
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
notToday = (req,res) !-> res.send 'Sorry Not Today'

/* ## govOnly
  BC Government uses the 142 IP domain exclusively.
  Aside from localhost redirect all non-gov traffic
  to an error page.
  XXX: Currently not used because Openshift routes
    through dynamic IPs
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
  @param next {function} Express callback
 */
govOnly = (req,res,next) ->
  address = req.connection.remoteAddress?replace /^.*:/, ''
  ips =
    /^1$/ # Localhost
    /^142\..*/ # All gov't users
    /^184\.69\.119\.114$/ # Little Earth

  allowed = no # default not allowed
  for ip in ips # Check if there's an allowed ip pattern
    if address.match ip then allowed = yes

  # Formaulate the denied url
  # h = if req.secure then 'https' else 'http'
  # url = "#h://#{req.headers.host}/not-today"
  url = '/not-today'

  # pass or fail
  if allowed then next! else res.redirect url

/* ## login
  Server the login page. Use Pug.
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
login = (req,res) -> res.render 'login', req.params <<< req.query


/* ## testing
  Test reverse proxy to CAS interface
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
testing = (req,res) !->
  # Must have a url... Bare minimum
  unless req.body?url then return res.send 'need a url'

  request req.body.url, (err,_,body) ->
    if err then return res.send that # Exit and replay on error
    res.send body # Return response from distination

/* ## getToken
  Get a CAS access token. 
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
  @return {object} The token object
 */
getToken = (req,res) !->
  id = process.env.AR_PATHFINDER_CAS_ID
  secret = process.env.AR_PATHFINDER_CAS_SECRET
  cas = process.env.AR_PATHFINDER_CAS_URL # The CAS API url
  dev = process.env.AR_PATHFINDER_DEV_URL # The DEV API url

  unless id and secret and cas
    return res.send 'Environmnent variables not set'

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
      console.error "Could not fetch token: ",err
      res.json access_token: false
    else
      json = JSON.parse body
      res.json do
        access_token: json.access_token
        expires_in: json.expires_in

/* ## proxyApi
  Proxy the CAS api to the dev server in the Openshift cluster.
  Must be called with the route and token like this
  `/api/dev/{endpoint here}?token={token here}`
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
proxyApi = (req,res) !->
  dev = process.env.AR_PATHFINDER_DEV_URL # The DEV API url
  endpoint = req.params.endpoint 
  token = req.query.token

  unless endpoint and token
    return res.send "Need a token and endpoint"

  url = "#dev/api/#endpoint?token=#token"
  request.get url, (err,code,body) !->
    if err
      console.error "Could not fetch token: ",err
      res.json access_token: false
    else
      res.json body

getProponents = (req,res) !->
  cas = process.env.AR_PATHFINDER_CAS_URL + '/cfs/parties' # url
  token = req.query.token # token

  console.log "CAS url: ",cas

  request do # run request
    url: cas
    headers:
      Content-Type: 'application/json'
      Authorization: "Bearer #token"
    , (err, code, body) ->
      if err
        console.error 'Dang error from CAS'
        return console.error that
      else
        console.log typeof body
        console.log body
        stuff = JSON.parse body
        console.log typeof stuff
        console.log stuff
        res.json stuff



# Configure and start server
app = express!
  .use helmet!
  .use cors!
  .use morgan if prod then 'combined' else 'dev' # verbose logs in dev
  .use compression!
  .use bodyParser.json limit: '50mb'
  .use bodyParser.urlencoded limit: "50mb", extended: true
  .use express.static 'frontend/dist' # Only used in Prod
  .set 'view engine', 'pug'
  .set 'views', 'backend/pug'
  .get '/login', login # Not used yet
  # .get '/test-html', testHtml # Not used yet
  # .get '/test-data', testData # Not used yet
  # .post '/testing', testing # Not used yet
  .get '/api/get-token', getToken
  .get '/api/dev/:endpoint', proxyApi
  .get '/api/proponents', getProponents
  .get '*', lost
  .listen 8080
