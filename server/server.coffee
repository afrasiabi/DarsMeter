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
	# auth.register "pouria", "pouria@gmail.com", "Poorazad218", "Poorazad218", (result) ->
	# 	console.log "should be success: ", result

	# auth.login "a@gmail.com", "aaa", (result) ->
	# 	console.log "should be success: ", result

	# auth.login "sssa@gmail.com", "aaa", (result) ->
	# 	console.log "should fail: ", result
	# auth.logout 3019347850, (result) ->
	# 	console.log result

	# auth.getUserByToken 6746959207, (result) ->
	# 	console.log result

	port = 3000

	app = express()
	app.use cors {allowedOrigins: ['localhost']}
	app.get '/register', (req, res) ->
		params = req.query
		auth.register params.fullName, params.email, params.password, params.confirmPassword, (result) ->
			res.json result
	app.get '/login', (req, res) ->
		params = req.query
		auth.login params.email, params.password, (result) ->
			result.startTime = 1460205592712
			res.json result
	app.get '/setTime' , (req, res) ->
		params = req.query
		if params.type is "start"
			auth.getUserByToken params.token, (result) ->
				user = result.user
				db.collection('times').insert {startTime: params.time, userId: user._id}, (err, data) ->
					if err?
						res.json {success: false}
						return
					res.json {success: true}

		else if params.type is "stop"
			auth.getUserByToken params.token, (result) ->
				user = result.user
				db.collection('times').update {userId: user._id, endTime: {$exists: false}}, {$set:{endTime: params.time}}, (err, data) ->
					if err?
						res.json {success: false}
						return
					res.json {success: true}

	app.listen port, ->
		console.log "server is ready on port #{port}"