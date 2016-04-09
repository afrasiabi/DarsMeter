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

	start: (optNow) ->
		return if @running
		@running = yes
		if optNow?
			@now = optNow	
		else
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

startTimer = (optStartTime) ->
	stopWatch.start(optStartTime)
	startClk.value = "Stop"
	showTime.innerHTML = formatTime(0)
	stopWatch.getValueEvery 1000, (timeSec) ->
		showTime.innerHTML = formatTime((stopWatch.getValue())/1000)

stopWatch = new StopWatch
startClk.addEventListener "click", (event) ->
	# it will return timestamp
	dt = Date.now()

	if stopWatch.running
		stopWatch.stop()
		# utcDateEnd = dt.toUTCString()
		startClk.value = "Start"
		makeRequest "http://localhost:3000/setTime", {type: "stop", time: dt}, (res) ->
			console.log res

	else
		startTimer()
		makeRequest "http://localhost:3000/setTime", {type: "start", time: dt}, (res) ->
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
		if window.token?
			data.token = window.token
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
		email: username.value
		password: password.value
	makeRequest "http://localhost:3000/login", signInData, (res) ->
		resObj = JSON.parse res
		if resObj.success	
			window.token = resObj.token
			showStartPage()
			if resObj.startTime?
				startTimer resObj.startTime
		else
			alert "Login not successful"

signUpId.addEventListener "submit", (event) ->
	event.preventDefault()
	name = document.getElementById "nameInput"
	email = document.getElementById "emailInp"
	password = document.getElementById "regPassword"
	passRepeat = document.getElementById "regPassRep"
	signUpData =
		fullName: name.value
		email: email.value
		password: password.value
		confirmPassword: passRepeat.value
	makeRequest "http://localhost:3000/register", signUpData, (res) ->
		resObj = JSON.parse res
		if resObj.success	
			window.token = resObj.token
			showStartPage()
		else
			alert resObj.msg