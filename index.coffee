express = require 'express'
app = express()
rh = require './requestHandlers.js'

app.set 'port', (process.env.PORT || 5000)


app.use '/StructuredMixer',express.static(__dirname + '/public')


app.get '/StructuredMixer/getSchedule', rh.getSchedule
app.get '/StructuredMixer/submitPreference', rh.submitPreference;
app.get '/StructuredMixer/initialize', rh.initialize


app.listen app.get('port'), ()->
	console.log "Running at:" + app.get('port')