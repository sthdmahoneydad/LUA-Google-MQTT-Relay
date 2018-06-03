
local httpSvc = {}


function httpSvc.getWebPage()
    print("getting web page?")
    print("create socket for connecting")
    
    sk = net.createConnection(net.TCP, 0)
    
    print("after async call to create socket")
    
    sk:on("connection", function(sck)
                            print("on connection...")
                            sk:send("GET /testwifi/index.html HTTP/1.1\r\nHost: wifitest.adafruit.com\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n")
                            print("back from sending data to receive web page....")
                        
                        end )
    

    sk:on("receive",    function(sck, c) 
                            print(c)   
                        end )
    print("call socket connect on port 80")
    
    sk:connect(80, "wifitest.adafruit.com")

end


return httpSvc