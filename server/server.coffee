express = require "express"
cors = require 'express-cors'

port = 3000

app = express()
app.use cors {allowedOrigins: ['localhost']}
app.get '/login', (req, res) ->
	res.json req.query
app.get '/setStartTime', (req, res) ->
	res.json req.query
app.get '/setTime' , (req,res) ->
	res.json req.query

app.listen port, ->
	console.log "server is ready on port #{port}"