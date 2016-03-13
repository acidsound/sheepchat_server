waiter = ''
haiter = ''
log = (q)-> console.log "#{(new Date()).toISOString()}:#{q}"
log process.env["HOST"]
log "no waiter"
mqtt = require 'mqtt'
client = mqtt.connect
  'host': process.env["HOST"]
  'port': process.env["PORT"] or 1883
  'username': process.env["USERNAME"]
  'password': process.env["PASSWORD"]
log 'server started'
client.on 'connect', ->
  log 'MQTT connected'
  client.subscribe 'waiters', (err, granted)->
    log err and err or "subscribed at #{JSON.stringify granted}"
proxy =
  "topic":
    "waiters" : (topic, message)->
      msg = message.toString()
      [request, second] = msg.split(',')
      log "current waiter is [#{waiter}]"
      # subscribe requester's die topic
      client.subscribe "die/#{request}" unless waiter?
      if second is waiter and not second?
        haiter = request
        client.publish "queue/#{request}", request
        log "[request] added hater #{request}"
      else
        waiter = waiter and waiter or request
        client.publish "queue/#{request}", waiter
        waiter = '' if waiter isnt request
        if hater?
          log "[request] hater #{hater} promoted to waiter"
          waiter = hater
          hater = ''
        log "[request] #{waiter is request and 'host' or 'guest'} #{request} to #{waiter}"
    # die
    "die" : (topic, message)->
      waiter = haiter? and haiter or "" if waiter is topic.replace /^die\//, ""
      client.unsubscribe topic
      log "#{topic} is dead"
client.on 'message', (topic, message)->
  method = topic.replace /\/.*/, "" # remove the sub topic
  log "[#{method}] #{topic}/#{message}"
  proxy.topic[method](topic, message) if proxy.topic[method]
