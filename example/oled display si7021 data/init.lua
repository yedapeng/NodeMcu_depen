local sda, scl = 3, 4
i2c.setup(0, sda, scl, i2c.SLOW) -- call i2c.setup() only once
si7021.setup()




cs  = 8 -- GPIO15, pull-down 10k to GND
dc  = 2
res = 0
spi.setup(1, spi.MASTER, spi.CPOL_LOW, spi.CPHA_LOW, 8, 8)
gpio.mode(8, gpio.INPUT, gpio.PULLUP)
disp = u8g.ssd1306_128x64_hw_spi(cs, dc, res)
disp:setFont(u8g.font_freedoomr25n)
disp:setFontPosTop()



function draw(hum, temp, hum_dec, temp_dec) 

disp:drawStr(0, 0, string.format("%d.%03d", hum, hum_dec))
disp:drawStr(0, 38, string.format("%d.%03d", temp, temp_dec))
    

end


disp:begin()


tmr.alarm(0, 1000, tmr.ALARM_AUTO, function()

    hum, temp, hum_dec, temp_dec = si7021.read()

    disp:firstPage()

    repeat 
        draw(hum, temp, hum_dec, temp_dec)
    until (disp:nextPage() ~= true)
    

end)
