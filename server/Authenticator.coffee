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
		@db.collection('users').find({email: email, password: pass}).toArray().then (data) =>
			if data.length is 1
				userData = data.pop()
				token = Math.round(Math.random() * 10000000000)
				@db.collection('session').insert({userId: userData._id, token: token, createdAt: new Date()}).then (insertResult) ->
					delete userData.password
					delete userData._id
					cb({success: true, token: token, user: userData})
			else
				cb({success: false})
				return

	logout: (token, cb) ->
		@db.collection('session').deleteOne {token: token}, (err, data) ->
			if err?
				cb({success: false})
				return
			if cb?
				cb({success: true})

	_validateRegister: (fullName, email, pass, confirmPass) ->
		if fullName.length < 3
			return "Fullname should be more than 3 chars"

	# 	# http://stackoverflow.com/questions/46155/validate-email-address-in-javascript
		emailRegex = /(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
		if not emailRegex.test(email)
			return "Email is not valid"

		if pass isnt confirmPass
			return "Passwords doesn't match"

	# 	# http://stackoverflow.com/questions/14850553/javascript-regex-for-password-containing-at-least-8-characters-1-number-1-upper case
		passRegex = /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])[0-9a-zA-Z]{8,}$/
		if not passRegex.test(pass)
			return "Password is not strong enough"
		return

	register: (fullName, email, pass, confirmPass, cb)->
		validateStatus = @_validateRegister(fullName, email, pass, confirmPass)
		if validateStatus?
			cb({success: false, msg: validateStatus})
			return
		@db.collection("users").find({email: email}).toArray().then (findExistingUser) =>
			if findExistingUser.length > 0
				cb({success: false, msg: "Email already exist"})
				return
			# , confirmPass: confirmPass ro tu DB zakhire nemikonim, faghat baraYe validator migirim
			@db.collection("users").insert({fullName: fullName, email: email, password: pass}).then (insertData) =>
				# userId = insertData.ops[0]._id
				# emailAddr = insertData.ops[0].email
				# userPass = insertData.ops[0].password
				#this dare!
				@login email, pass, (loginResult) ->
					console.log loginResult
					cb(loginResult)

	getUserByToken: (token, cb) ->
		@db.collection('session').find({token: parseInt(token)}).toArray().then (data) =>
			if data.length is 1
				userId = data.pop().userId
				@getUserById userId, (data) ->
					if data.success
						cb({success: true, user: data.user})
					else
						cb({success: false})
			else
				cb({success: false})

	getUserById: (id, cb) ->
		@db.collection('users').find({_id: id}).toArray().then (data) ->
			if data.length is 1
				user = data.pop()
				data = {success: true, user: user}
				cb(data)
			else
				cb({success: false})