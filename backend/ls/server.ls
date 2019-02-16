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

/* ## testHtml
  Serving html file ala pug now
  Pass in the express parameters and the url query stuff
  @param req {object} Node/Express request object
  @param res {object} Node/Express response object
 */
testHtml = (req,res) -> res.render 'test', req.params <<< req.query


# Configure and start server
app = express!
  .use helmet!
  .use morgan if prod then 'combined' else 'dev' # verbose logs in dev
  .use compression!
  .use express.static 'dist' # Only used in Prod
  .set 'view engine', 'pug'
  .set 'views', 'backend/pug'
  .get '/test-html', testHtml
  .get '*', lost
  .listen 8080
