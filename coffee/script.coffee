signIn = document.getElementById "signIn"
signUp = document.getElementById "signUp"
signUpId = document.getElementById "signUpId"
signInId = document.getElementById "signInId"
InpForm = document.getElementById "InpFormId"
startClk = document.getElementById "startClk"
start = document.getElementById "Start"
showTime = document.getElementById "showTime"

class StopWatch
	constructor: ->
		@running = no
		@interval = null

	start: ->
		return if @running
		@running = yes
		@now = Date.now()

	stop: ->
		return unless @running
		@cancelGettingValue()
		@running = no
		@now = 0

	getValue: ->
		if @running
			Date.now() - @now
		else
			0

	getValueEvery: (timeDist, callbackFunc) ->
		@interval = setInterval =>
			if @running
				callbackFunc(@getValue())
		, timeDist

	cancelGettingValue: ->
		return unless @interval?
		clearInterval @interval
		@interval = null

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

showStartPage = ->
	InpForm.style.display = "none"
	Start.style.display = "block"

formatTime = (timeSec) ->
	sec_num = parseInt(timeSec, 10)
	hours   = Math.floor(sec_num / 3600)
	minutes = Math.floor((sec_num - (hours * 3600)) / 60)
	seconds = sec_num - (hours * 3600) - (minutes * 60)

	if hours < 10
		hours   = "0" + hours
	if minutes < 10
		minutes = "0" + minutes
	if seconds < 10
		seconds = "0" + seconds
	time = hours + ':' + minutes + ':' + seconds

stopWatch = new StopWatch
startClk.addEventListener "click", (event) ->
	timeStamp = Date.now()

	if stopWatch.running
		stopWatch.cancelGettingValue()
		startClk.value = "Start"
		makeRequest "http://localhost:3000/setTime", {type: 'stop', time: timeStamp}, (res) ->
			console.log res

	else
		stopWatch.start()
		startClk.value = "Stop"
		showTime.innerHTML = formatTime(0)
		stopWatch.getValueEvery 1000, (timeSec) ->
			show = formatTime((stopWatch.getValue())/1000)
			showTime.value = show
		makeRequest "http://localhost:3000/setStartTime", {type: 'start', time: timeStamp}, (res) ->
			console.log res

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
	makeRequest "http://localhost:3000/login", signInData, (res) ->
		console.log res
		showStartPage()

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
	makeRequest "http://localhost:3000/login", signUpData, (res) ->
		console.log res
		showStartPage()