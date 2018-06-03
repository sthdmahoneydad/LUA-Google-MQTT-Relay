local wifiSvc = {}


wifiCreds = require "wifi-creds"


-------- Station modes -------
STAMODE = {
STATION_IDLE             = 0,
STATION_CONNECTING       = 1,
STATION_WRONG_PASSWORD   = 2,
STATION_NO_AP_FOUND      = 3,
STATION_CONNECT_FAIL     = 4,
STATION_GOT_IP           = 5
}
------------------------------





function wifiSvc.getWiFiIPAddress()
    return wifi.sta.getip()
end

function wifiSvc.isWiFiConnected()
    return wifi.sta.status() == STAMODE.STATION_GOT_IP
end

function wifiSvc.getWiFiStatus()
    local status = ""
    if wifi.sta.status() == STAMODE.STATION_IDLE            then status = "Station: idling" end
    if wifi.sta.status() == STAMODE.STATION_CONNECTING      then status = "Station: connecting" end
    if wifi.sta.status() == STAMODE.STATION_WRONG_PASSWORD  then status = "Station: wrong password" end
    if wifi.sta.status() == STAMODE.STATION_NO_AP_FOUND     then status = "Station: AP not found" end
    if wifi.sta.status() == STAMODE.STATION_CONNECT_FAIL    then status = "Station: connection failed" end

    return status
end

function wifiSvc.initWiFi()
    wifi.setmode(wifi.STATION)
    
    station_cfg = {}
    station_cfg.ssid= wifiCreds.getSSID()
    station_cfg.pwd= wifiCreds.getPassword()
    station_cfg.save = true
    wifi.sta.config(station_cfg)

end


--[[ Function connect: ------
      connects to a predefined access point
      params: 
         timeout int    : timeout in us
--------------------------]]--
function wifiSvc.connectToWiFi(timeout)
    print("connectToWiFi...")
    
    local time = tmr.now()
    wifi.sta.connect()
    
    -- Wait for IP address; check each 1000ms; timeout
    tmr.alarm(1, 1000, 1,   function() 
                                if wifiSvc.isWiFiConnected() then 
                                       tmr.stop(1)
                                          print("Station: connected! IP: " .. wifiSvc.getWiFiIPAddress() )
                                         -- dofile(MAIN)
                                         --getWebPage()
--                                         mqttSvc.startUpMQTT()
                                        dofile("handleWiFiConnected.lua")
                                else
                                    print(wifiSvc.getWiFiStatus() )
                                    if tmr.now() - time > timeout then
                                        tmr.stop(1)
                                        print("Timeout!")
                                    
                                    end
                                end 
                            end )
end


function wifiSvc.setupWiFi()
    wifiSvc.initWiFi()
    wifiSvc.connectToWiFi(TIMEOUT)
end


return wifiSvc
