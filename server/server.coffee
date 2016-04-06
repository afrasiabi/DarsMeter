express = require "express"
cors = require 'express-cors'

MongoClient = require('mongodb').MongoClient
ObjectID = require('mongodb').ObjectID
url = 'mongodb://localhost:27017/darsMeter'

MongoClient.connect url, (err, db) ->
	if err?
		console.log err
		return
	console.log("Connected correctly to mongo")
	# db.collection('times').insert({startTime: Date.now()})
	# db.collection('times').update({endTime: {$exists: false}}, {$set:{endTime: Date.now()}})

port = 3000

app = express()
app.use cors {allowedOrigins: ['localhost']}
app.get '/login', (req, res) ->
	res.json req.query
app.get '/setTime' , (req,res) ->
	res.json req.query

app.listen port, ->
	console.log "server is ready on port #{port}"