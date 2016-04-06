express = require "express"
cors = require 'express-cors'
MongoClient = require('mongodb').MongoClient
ObjectID = require('mongodb').ObjectID
url = 'mongodb://localhost:27017/darsMeter'

Authenticator = require './Authenticator'

MongoClient.connect url, (err, db) ->
	if err?
		console.log err
		return

	console.log("Connected correctly to mongo")
	
	auth = new Authenticator db
	auth.login "a@gmail.com", "aaa", (result) ->
		console.log result
	auth.logout 3019347850, (result) ->
		console.log result

	auth.getUserByToken 6746959207, (result) ->
		console.log result

	port = 3000

	app = express()
	app.use cors {allowedOrigins: ['localhost']}
	app.get '/register', (req, res) ->
		res.json req.query
	app.get '/login', (req, res) ->
		res.json req.query
	app.get '/setTime' , (req, res) ->
		params = req.query
		if params.type is "start"
			console.log "start", params.time
			db.collection('times').insert {startTime: params.time}, (err, data) ->
				if err?
					res.json {success: false}
					return
				res.json {success: true}
				console.log err, data

		else if params.type is "stop"
			console.log "stop", params.time
			db.collection('times').update {endTime: {$exists: false}}, {$set:{endTime: params.time}}, (err, data) ->
				if err?
					res.json {success: false}
					return
				res.json {success: true}
				console.log err, data

	app.listen port, ->
		console.log "server is ready on port #{port}"