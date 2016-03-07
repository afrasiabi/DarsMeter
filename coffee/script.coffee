signIn = document.getElementById "signIn"
signUp = document.getElementById "signUp"
signUpId = document.getElementById "signUpId"
signInId = document.getElementById "signInId"

signIn.addEventListener "click", (event) ->
	signUpId.style.visibility = "hidden"
	signInId.style.visibility = "visible"
	signUp.style.border = "none"
	this.style.border = "solid"

signUp.addEventListener "click", (event) ->
	signInId.style.visibility = "hidden"
	signUpId.style.visibility = "visible"
	signIn.style.border = "none"
	this.style.border = "solid"

makeRequest = (url, data, cbFunc) ->
	alertContents = ->
		if httpRequest.readyState == XMLHttpRequest.DONE
			if httpRequest.status == 200
				cbFunc httpRequest.responseText
			else
				alert "There was a problem with the request to #{url}"
		return

	httpRequest = new XMLHttpRequest

	if !httpRequest
		alert 'Giving up :( Cannot create an XMLHTTP instance'
		return false
	else	
		qs = ""
		for key, value of data
			qs = qs + encodeURIComponent(key) + "=" + encodeURIComponent(value) + "&"
		httpRequest.onreadystatechange = alertContents
		httpRequest.open("GET", url + "?" + qs)
		httpRequest.send(data)
		return

signInId.addEventListener "submit", (event) ->
	event.preventDefault()
	username = document.getElementById "userInput"
	password = document.getElementById "password"
	signInData =
		user: username.value
		pass: password.value
	makeRequest "http://localhost:3000", signInData, (res) ->
		console.log res

signUpId.addEventListener "submit", (event) ->
	event.preventDefault()
	name = document.getElementById "nameInput"
	email = document.getElementById "emailInp"
	password = document.getElementById "regPassword"
	passRepeat = document.getElementById "regPassRep"
	signUpData =
		fullName: name.value
		emailAddr: email.value
		pass: password.value
		passRep: passRepeat.value
	makeRequest "http://localhost:3000", signUpData, (res) ->
		console.log res

