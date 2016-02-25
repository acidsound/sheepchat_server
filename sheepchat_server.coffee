waiter = ''
haiter = ''
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
  msg = message.toString()
  request = msg.split(',')[0]
  second = msg.split(',')[1]
  if second is waiter
    haiter = request
    client.publish "queue/#{request}", request
    console.log "[request] added hater #{request}"
  else
    waiter = waiter and waiter or request
    client.publish "queue/#{request}", waiter
    waiter = '' if waiter isnt request
    if hater?
      waiter = hater
      hater = ''
      console.log "[request] hater #{hater} promoted to waiter"
    console.log "[request] #{waiter is request and 'host' or 'guest'} #{topic} - #{message} to #{waiter}"
