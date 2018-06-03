

relaySvc = require "relay-switch"

print("handleTopicData-OFF received: turn off relay")
relaySvc.turnOff(RELAY_PIN)