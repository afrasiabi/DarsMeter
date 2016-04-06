module.exports = class Authenticator
	constructor: (@db) ->

	login: (email, pass, cb) ->
		# validate yek msg bar migardanad V agar dorost bud null bar migardanad.
		# validateStatus = validate(email, pass)
		# if validateStatus?
		# 	if cb?
		#		cb( {success: false, msg: validateStatus} be dalile async budan dg return nadarad!
		# pas majboorim ye callback bezarim k vaghti javabe in insert ha o find ha o ina umad
		# callback ro seda bezane o behesh parametr bede
		cursor = @db.collection('users').find({email: email, password: pass})
		cursor.each (err, data) =>
			if data?
				token = Math.round(Math.random() * 10000000000)
				@db.collection('session').insert {userId: data._id, token: token, createdAt: new Date()}, (err, data) ->
					if err?
						cb({success: false})
						return
					if cb?
						cb({success: true, token: token})

	logout: (token, cb) ->
		@db.collection('session').deleteOne {token: token}, (err, data) ->
			if err?
				cb({success: false})
				return
			if cb?
				cb({success: true})

	register: ->

	getUserByToken: (token, cb) ->
		cursor = @db.collection('session').find({token: token})
		cursor.each (err, data) =>
			if data?
				cb(data)
				