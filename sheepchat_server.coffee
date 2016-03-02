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
proxy =
  "topic":
    "waiters" : (topic, message)->
      msg = message.toString()
      [request, second] = msg.split(',')
      console.log "current waiter is [#{waiter}]"
      # subscribe requester's die topic
      client.subscribe "die/#{request}" unless waiter?
      if second is waiter and not second?
        haiter = request
        client.publish "queue/#{request}", request
        console.log "[request] added hater #{request}"
      else
        waiter = waiter and waiter or request
        client.publish "queue/#{request}", waiter
        waiter = '' if waiter isnt request
        if hater?
          console.log "[request] hater #{hater} promoted to waiter"
          waiter = hater
          hater = ''
        console.log "[request] #{waiter is request and 'host' or 'guest'} #{request} to #{waiter}"
    # die
    "die" : (topic, message)->
      waiter = haiter? and haiter or "" if waiter is topic.replace /^die\//, ""
client.on 'message', (topic, message)->
  console.log "[message] #{topic}/#{message}"
  proxy.topic[topic](topic, message) if proxy.topic[topic]
