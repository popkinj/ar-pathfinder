/* Bare bones static file server */
require! {
  fs
  pug
  http
  morgan
  helmet
  express
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

# More logs if in dev
logger = if prod then 'combined' else 'dev'

# Configure and start server
app = express!
  .use helmet!
  .use morgan logger
  .use compression!
  .use express.static 'views'
  .set 'view engine', 'pug'
  .set 'views', 'lib/pug'
  .get '*', lost
  .listen 8080
