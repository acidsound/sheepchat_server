waiter = ''
console.log process.env["HOST"]
mqtt = require 'mqtt'
client = mqtt.connect
  'host': process.env["HOST"]
  'port': process.env["PORT"] or 1883
  'username': process.env["USERNAME"]
  'password': process.env["PASSWORD"]
console.log 'server started'
client.on 'connect', ->
  console.log 'MQTT connected'
  client.subscribe 'waiters', (err, granted)->
    console.log err and err or "subscribed at #{JSON.stringify granted}"
client.on 'message', (topic, message)->
  request = message.toString()
  waiter = waiter and waiter or request
  client.publish "queue/#{request}", waiter
  console.log "[request] #{waiter is request and 'host' or 'guest'} #{topic} - #{message} to #{waiter}"
  waiter = '' if waiter isnt request 
