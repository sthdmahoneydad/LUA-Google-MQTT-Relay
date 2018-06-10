# LUA-Google-MQTT-Relay

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



adafruit.io has MQTT topic

NodeMCU has custom firmware on it

Have LUA code connect to WIFI-PWD
on connection startupMQTT
	Connect to MQTT endpoint for Adafruit
	subscribe to onoff topic



-- if you use integer version, smaller footprint, but not floating point decimals supported.
esptool.py --baud 115200 --port /COM6 write_flash -fs 4MB -ff 80m --flash_mode dio 0x00000 nodemcu-master-11-modules-2018-04-15-00-39-22-float.bin 




Note: There are a batch of this item are the new grade version. Maybe there are some different between the new one and old one in the aspect of usage. Pls feel free to email us if you have any question about how to use the new vertion module. How to email us? Click "MakerFocus" and click "Ask a question".
There is the way to guide you to use the new version: 
The command you needed to use is: esptool.py --baud 115200 --port /dev/tty.SLAB_USBtoUART write_flash -fs 32m -ff 80m --flash_mode dio 0x00000 boot_v1.7.bin 0x1000 user1.bin 0x37c000 esp_init_data_default.bin 0x37e000 blank.bin 
The important part is “—flash mode dio” https://github.com/espressif/esptool/wiki/SPI-Flash-Modes


Data download access to the website: http://www.nodemcu.com Test Video: https://www.youtube.com/watch?v=Gh_pgqjfeQc. The chip model: CP2102; It is designed to occupy minimal PCB area; ESP8266 is a highly integrated chip designed for the needs of a new connected world
Its high degree of on-chip integration allows for minimal external circuitry
Makerfocus nRF24L01+ and ESP8266 ESP-01 Breadboard Breakout Adapter Board is come for free, it can compatible with nRF24L01+ and ESP8266 ESP-01. If you need more informations about it, pls refer to: https://www.amazon.com/dp/B01N5AK6E1





Add 2 files to scripts directory and update

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

return mqttCreds
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
