express = require "express"
cors = require 'express-cors'

port = 3000

app = express()
app.use cors {allowedOrigins: ['localhost']}
app.get '/', (req, res) ->
	#inja mikham un data k alaki ferestadam ro begiram
	# console.log req.query
	res.json req.query

app.listen port, ->
	console.log "server is ready on port #{port}"