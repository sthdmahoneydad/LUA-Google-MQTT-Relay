--[[--------------------------
   LUA script for configuring an ESP8266 to connect to a Wi-Fi network
   Author: wvanvlaenderen
--------------------------]]--

----------- CONFIG -----------

TIMEOUT    = 30000000 -- 30s
MAIN       = "init.lua"
------------------------------


wifiSvc = require "wifi-svc"
relaySvc = require "relay-switch"


------- Relay PIN ----------------
RELAY_PIN = 8            --  GPIO8
----------------------------------

print ("start relay commands....")

relaySvc.initRelay(RELAY_PIN)

wifiSvc.setupWiFi()







