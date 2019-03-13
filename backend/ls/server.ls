/* Bare bones static file server */
require! {
  fs
  pug
  cors
  http
  morgan
  helmet
  express
  \express-vue # Maps to expressVuew
  request
  \body-parser # Maps to bodyParser
  compression
}

# Are we in prod or dev
prod = if process.env.NODE_ENV is \production then yes else no

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
  Server the login page
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
login = (req,res) ->
  res.send 'yo'


/* ## testing
  Test reverse proxy to CAS interface
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
testing = (req,res) !->
  # Must have a url... Bare minimum
  unless req.body?url then return res.send 'need a url'

  # try
  #   json = JSON.parse req.body.data
  # catch
  #   return res.send 'Invalid JSON data'

  # Use the handy request tool
  # TODO: handle POST/GET
  # request.post req.body.url, json, (err,_,body) ->
  #   if err then return res.send that # Exit and replay on error
  #   res.send body # Return response from distination

  request req.body.url, (err,_,body) ->
    if err then return res.send that # Exit and replay on error
    res.send body # Return response from distination



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
  .get '/login', login
  .get '/test-html', testHtml
  .get '/test-data', testData
  # .post '/testing', govOnly, testing
  .post '/testing', testing
  .get '*', lost
  .listen 8080
