
local relaySvc = {}

function relaySvc.relayToggle(pin)

    -- Pin definition 

    local status = gpio.LOW

    -- Initialising pin
    gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, status)
    
    -- Create an interval
--    tmr.alarm(0, duration, 1, function ()
        if status == gpio.LOW then
            status = turnOn(pin)
        else
            status = turnOff(pin)
        end
    
--    end)

end

function relaySvc.initRelay(pin)
    gpio.mode(pin, gpio.OUTPUT)

end


function relaySvc.turnOn(pin)
    print("Turn On")
    gpio.write(pin, gpio.HIGH)

    return gpio.HIGH

end

function relaySvc.turnOff(pin)
    print("Turn Off")
    gpio.write(pin, gpio.LOW)

    return gpio.LOW
end


return relaySvc