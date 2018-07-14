# LUA-Google-MQTT-Relay

This project was a simple NodeMCU board with a relay to turn on/off an LED light strip by using Google Assistant, IFTT, and MQTT.

The parts of this project can be split into(Cloud / Local):

Cloud: 
1) adafruit.io has the MQTT (message queue telemetry transport) Topic for pub/sub to send receive feed data.  
	This will be the post office where Google Assistant will publish messages to the topic, and NodeMCU can subscribe to receive the messages.
	
		setup account: https://io.adafruit.com
		Free for small projects -fee for larger ones.(this case free)
		
			need to get your AIO KEY
				the username will be stored in mqtt-io-adafruit-creds.lua for getUserID
				the active Key will be stored in mqtt-io-adafruit-creds.lua for getPass
			
			Create the feed: ONOFF
			Click Feed Information setup icon to get name, key, endpointURL mqtt by id will be stored in mqtt-io-adafruit-creds.lua for getEndPoint
			You can trigger topic data publishing(by using Add Data action) 
			
			
			Setup Dashboard - > Created LEDLightStrip ( this will allow you to quickly see visually when the topic is being called by google assistant)
			
			Create New Block for Dashboard - ONOFF
			Select Feed for Dashboard - ONOFF Feed
				Select block settings for on/off
	
	
	
	
2) IFTT - setup for working with Google Assistant -> when the turn on/off intents are recognized, then the data will be published to the adafruit.io MQTT Topic

			Use Google Assistant 
			For If portion of IfThisthenThat, use Google Assistant for IFTT to handle google assitant command and send to Adafruit.io 

			Choose simple phrase…

			"Turn Off my LED Light"
			Respond with
			"OK, turning off LED Light"
			 

			Select Create trigger button

			Choose 'That' portion, Select ‘+’ for that action service which is "adaFruit"
			Select Send Data

			Select Feed Name setup in AdaFruit
			"ONOFF" Feed
			Data to Save: Off

			Select Create Action button

			* Repeat process for Turning on the LED Lights....


Local: 
1) NodeMCU & Relay circuitry

		NodeMCU Circuitry
		1) used USB to power NodeMCU
		2) connect NodeMUC to Relay for turning on/off
			a) 3.3V to middle pin on my 5V relay(circuit side)
			b) Ground to last pin on 5V relay
			c) Digital Pin 8 to 1st pin on relay(should match what is defined in init.lua script)
			-- device to power on / off
			d) Ground from power source goes to Target Device(LED Light Strip)
			-- insert relay into target device supply of power
			e) Positive from power source goes to Relay first position
			f) Relay second position goes to  Target Device(LED Light Strip).




2) NodeMCU Firmware built using https://nodemcu-build.com (allows you to select what to include and it builds custom firmware for you) 
		*this could have been smaller, but added extra to allow for other projects
		The firmware was built against the master branch and includes the following modules: adc, file, gpio, mqtt, net, node, tmr, uart, websocket, wifi, tls.
		
		if you custom build your version, you will be notified via email when ready( within minutes)- download to PC to be used with esptool command
		
		
		To connect nodeMCU to comport for flashing on my windows PC I needed updated drivers for USB-UART
		
		-- need drivers for this.
		https://www.silabs.com/products/development-tools/software/usb-to-uart-bridge-vcp-drivers

		

		To flash NodeMCU with firmware 

		
		install esptool.py using: pip install esptool
		
		-- IF YOU have already install esptool.py using: pip install esptool
		then you can use esptool.py(NO PYTHON cmd before)

		
		connect nodeMCU to PC

		-- Verify the COM port!
		-- update the last parameter to name of the custom firmware you created above
	
		C:\dev\NodeMCU\Firmware\ADC-WebSocket-MQTT-WIFI>esptool.py --baud 115200 --port COM12 write_flash -fs 4MB -ff 80m --flash_mode dio 0x00000 nodemcu-master-11-modules-2018-04-15-00-39-22-float.bin



		
		
		
		
		
		
		
3) software using LUA(5.1) - 

		I used Esplorer for loading and running the software on the NodeMCU
		Download latest version http://esp8266.ru/esplorer-latest/?f=ESPlorer.zip

		for more details goto: https://esp8266.ru/esplorer/
		
		---- Run Esplorer.bat

		*** I Needed JDK 1.8 version 10 was causing error in esplorer.
				
		Open Files (or add)
		Select the COM Port select baud rate and open
		Select Save to ESP 
		Select RUN

		Files: 
			- init.lua - startup script - defines IO PIN for relay and call to setup WiFi
			- wifi-svc.lua - handles wifi connection
			- wifi-creds.lua - stores you local wifi credentials
			- handleWiFiConnected.lua - called on wifi connection(put code to do what you want ie startup MQTT client)
			- relay-switch.lua - assing input/out mode to pin, toggle, turn-on/off
			- mqtt-svc.lua - MQTT client for subscribing to topic
			- MQTT-io-adafruit-creds.lua - stores credentials for io.adafruit mqtt topic
			- handleTopicData-On.lua - invoked when MQTT topic recieves On message calls relay turnOn
			- handleTopicData-Off.lua - invoked when MQTT topic recieves On message calls relay turnOff
			
			

		init.lua for Startup the NodeMCU :
			requires relay-switch.lua & wifisvc.lua  
			
			Defines the digital IO Pin for the relay and initializes it to set to output mode
						
			makes a call to wifisvc.SetupWiFi to setup the connection to local WiFi
				*note: wifisvc.lua will require the wificreds.lua that you have to create as shown at bottom of readme.
			
			on connecting to WiFi the handleWiFiConnected.lua script will be called.
				handleWiFiConnected will require the mqtt-svc.lua file (mqtt-svc will require the mqtt-io-adafruit-creds.lua script you need to create)
				and it will startup the MQTT client for the adafruit MQTT topic
				
				on receiving a message, the client checks the data to see if the feed returned ON or OFF and 
				will call a LUA script(handleTopicData-On.lua or handleTopicData-Off.lua) to handle the on/off which will turn the relay switch on/off accordingly.
			
			
		



*** You must Add 2 files to scripts directory and update

-- 1)
------ MQTT-io-adafruit-creds.lua --------------

local mqttCreds = {}

function mqttCreds.getUserID()
    return "YOUR USERID"
end

function mqttCreds.getPass()
    return "YOUR PASSWORD"
end

function mqttCreds.getTimeOut()
    return 120
end

function mqttCreds.getHost()
    return "io.adafruit.com"
end

function mqttCreds.getPort()
    return 1883
end

function mqttCreds.getEndPoint()
    return "YOUR-ACCT/feeds/YOUR_MQTT-KEYID"
end

function mqttCreds.getTopic()
    return "YOUR-ACCT-TOPIC"
end

return mqtttCreds

----------------------------------


--2) 
------------ wifi-creds.lua --------------
local wifiCreds = {}




function wifiCreds.getSSID()
    return "YOUR-WIFI-SSID"
end

function wifiCreds.getPassword()
    return "YOUR-WIFI-PWD"
end


return wifiCreds

------------------------------------------
