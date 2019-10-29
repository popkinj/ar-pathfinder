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
  port: 5432 
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
  If heading to the API... Forward on. Otherwise Decline.
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
lost = (req,res) ->
  if req.params['0'] is /\/api\//
    req.params.endpoint = req.params['0'].replace '/api/', ''
    readCas ...
  else
    res.status 404 .send '<p>Sorry... You must be lost &#x2639;.</p>'

/* ## lostWrite
  Router for all POST and PUT requests.
  If heading to the API... Forward on. Otherwise Decline.
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
lostWrite = (req,res) ->
  if req.params['0'] is /\/api\//
    req.params.endpoint = req.params['0'].replace '/api/', ''
    writeCas ...
  else
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

/* ## toQueryString
  Flatten an object into an URL query style string
  @param params {object} Key/value object of parameters
  @return {string} String of parameters separated by "&"'s
 */
toQueryString = (params) ->
  Object
    .keys params
    .map -> "#{encodeURIComponent(it)}=#{encodeURIComponent(params[it])}"
    .join '&'


/* ## readCas
  Proxy the CAS api to the dev server in the Openshift cluster.
  All Get requests are passed through with appropriate url and parameters.
  If on a development computer the request goes to the Dev server within
  the Openshift cluster. If in Dev the request gets sent to CAS.
  Must be called with the route and token like this.
  `/api/{endpoint here}?token={token here}`
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
readCas = (req,res) !->

  endpoint = req.params.endpoint 
  token = req.query.token
  params = toQueryString req.query

  console.log 'endpoint: ', endpoint

  unless endpoint and token
    return res.send "Need a token and endpoint"

  url = if prod
    cas = process.env.AR_PATHFINDER_CAS_URL # The CAS API url
    "#cas/cfs/#endpoint?#params"
  else
    dev = process.env.AR_PATHFINDER_DEV_URL # The DEV API url
    "#dev/api/#endpoint?#params"

  options = do
    headers:
      Content-Type: 'application/json'
      Authorization: "Bearer #token"
    url: url

  request.get options, (err,code,body) !->
    if err
      console.error "Could not fetch data: ",err
      res.json access_token: false
    else
      res.json JSON.parse body


/* ## writeCas
  Proxy the CAS api to the dev server in the Openshift cluster.
  All PUT and POST requests are passed through with appropriate url and parameters.
  If on a development computer the request goes to the Dev server within
  the Openshift cluster. If in Dev the request gets sent to CAS.
  Must be called with the route and token like this.
  `/api/{endpoint here}?token={token here}`
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
writeCas = (req,res) !->
  method = if req.route.methods.post then 'post' else 'put'
  console.log(method);

  endpoint = req.params.endpoint 
  token = req.query.token
  params = toQueryString req.query

  console.log 'endpoint: ', endpoint

  unless endpoint and token
    return res.send "Need a token and endpoint"

  url = if prod
    cas = process.env.AR_PATHFINDER_CAS_URL # The CAS API url
    "#cas/cfs/#endpoint?#params"
  else
    dev = process.env.AR_PATHFINDER_DEV_URL # The DEV API url
    "#dev/api/#endpoint?#params"

  options = do
    headers:
      Content-Type: 'application/json'
      Authorization: "Bearer #token"
    url: url

  # request.get options, (err,code,body) !->
  #   if err
  #     console.error "Could not fetch data: ",err
  #     res.json access_token: false
  #   else
  #     res.json JSON.parse body



/* ## getProponentsLive
  Get proponents directly from CAS
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
getProponentsLive = (req,res) !->
  cas = process.env.AR_PATHFINDER_CAS_URL + '/cfs/parties' # url
  token = req.query.token # token

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
        res.json JSON.parse body

/* ## getProponents
  Get proponents from the local cache
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
getProponents = (req,res) !->
  pgPool.query 'select * from proponents', (err,data) ->
    res.json data


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
  .get '/proponents', getProponents # Get proponents from our local cache
  # .get '/test-html', testHtml # Not used yet
  # .get '/test-data', testData # Not used yet
  # .post '/testing', testing # Not used yet
  .get '/api/get-token', getToken
  .get '/api/:endpoint', readCas # All CAS read api calls
  .post '/api/:endpoint', writeCas # All CAS write api calls
  .get '*', lost
  .post '*', lostWrite
  .listen 8080
