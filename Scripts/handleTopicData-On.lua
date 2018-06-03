

relaySvc = require "relay-switch"

print("handleTopicData-ON received: turn on relay")
relaySvc.turnOn(RELAY_PIN)


httpSvc = require "http-svc"
httpSvc.getWebPage()