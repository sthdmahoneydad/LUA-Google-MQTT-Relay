local mqttSvc = {}


mqttCreds = require "MQTT-io-adafruit-creds"
wifiSvc = require "wifi-svc"

function mqttSvc.startUpMQTT()
  --Subscribe to the onoff topic
    
    -- init mqtt client with logins, keepalive timer 120sec
    print("start up MQTT....")
    m = mqtt.Client(mqttCreds.getEndPoint(), 0, mqttCreds.getUserID(), mqttCreds.getPass())
    
    print("back from creating client Object....")
    
    
    -- setup Last Will and Testament (optional)
    -- Broker will publish a message with qos = 0, retain = 0, data = "offline" 
    -- to topic "/lwt" if client don't send keepalive packet
    m:lwt("/lwt", "offline", 0, 0)
    
    --m:on("connect", function(client) print ("connected") end)
    m:on("offline", function(client) 
        print ("offline..... call connect again.") 
        connectToWiFi(TIMEOUT)
    
    end)
    
    -- on publish message receive event
    m:on("message", function(client, topic, data) 
        print("message received")
        
          print(topic .. ":" ) 
          if data ~= nil then
            print(data)
            if data == "ON" then
                dofile("handleTopicData-On.lua")
            else 
                dofile("handleTopicData-Off.lua")
            end
          end
    end)
    
    -- for TLS: m:connect("192.168.11.118", secure-port, 1)
    m:connect(mqttCreds.getHost(), mqttCreds.getPort(), 0, function(client)
          print("connected")
          -- Calling subscribe/publish only makes sense once the connection
          -- was successfully established. 
        
          -- subscribe topic with qos = 0
          client:subscribe(mqttTopic, 0, function(client) print("subscribe success") end)
          -- publish a message with data = 1, QoS = 0, retain = 0
          client:publish(mqttTopic, "1", 0, 0, function(client) print("sent") end)
        end,
        
        function(client, reason)
          print("failed reason: " .. reason)
          wifi.disconnect = true
          wifiSvc.setupWiFi()
          
    end)
    
    --m:close();
    

end


return mqttSvc