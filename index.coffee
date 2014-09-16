# initialization

http = require 'http'
fs   = require 'fs'
express = require 'express'
ca = require 'connect-assets'
log = require('logule').init(module)
request = require 'request'
yaml = require 'js-yaml'

app = express()
server = http.createServer app

# error handling

process.on 'uncaughtException', (err) ->
  log.error err.stack

# configuration

app.configure ->
  app.set 'views', __dirname + '/app/views'
  app.set 'view engine', 'jade'
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.favicon __dirname + '/public/img/favicon.ico'
  app.use express.static __dirname + '/public'
  app.use ca {
    src: 'app/assets'
    buildDir: 'public'
  }

app.configure 'development', ->
  app.set 'BASE_URL', 'http://localhost:3777'

app.configure 'production', ->
  app.set 'BASE_URL', 'http://dkcalculator.herokuapp.com'

# middlewares

logRequest = (req, res, next) ->
  log.info req.method + ' ' + req.url
  next()

# config loading

try
  keys = yaml.load fs.readFileSync('config/keys.yml', 'utf8')
catch error
  log.error 'Please provide a config/keys.yml file (see README.md)'
  process.exit()

# routes

app.all '*', logRequest, (req, res, next) ->
  next()

app.get '/', (req, res) ->
  res.render 'main'

app.get '/places', (req, res) ->
  url = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=' + req.query.q + '&location=' + req.query.latitude + ',' + req.query.longitude + '&types=(regions)&key=' + keys.google
  request.get(url, {
    json: true
  }, (error, response, body) ->
    res.send body
  )

app.get '/places/:id', (req, res) ->
  url = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=' + req.params.id + '&key=' + keys.google
  request.get(url, {
    json: true
  }, (error, response, body) ->
    res.send body
  )

# 404

app.all '*', (req, res) ->
  res.statusCode = 404
  res.render '404', {
    code: '404'
  }

# server creation

server.listen process.env.PORT ? '3777', ->
  log.info 'Express server listening on port ' + server.address().port + ' in ' + app.settings.env + ' mode'