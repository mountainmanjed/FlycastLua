local mem = flycast.memory;
local gui = flycast.ui;
local emu = flycast.state;

function Memory8viewer(x,y,rows,start)
    local addr = start
    local r = mem.read8;
    local title = string.format("Memory 8 Bit Viewer: %08x",addr)

    gui.beginWindow(title,x,y,430,0)
    for i = 0,rows,1 do
        gui.text(string.format("%08x: ",addr))
        gui.rightText(string.format("%02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x %02x",
        r(addr+0x0),r(addr+0x1),r(addr+0x2),r(addr+0x3),
        r(addr+0x4),r(addr+0x5),r(addr+0x6),r(addr+0x7),
        r(addr+0x8),r(addr+0x9),r(addr+0xa),r(addr+0xb),
        r(addr+0xc),r(addr+0xd),r(addr+0xe),r(addr+0xf)))
        addr = addr + 0x10
    end
    gui.endWindow()
end

function Memory16viewer(x,y,rows,addr)
	local r = mem.read16;
	local title = string.format("Memory 16 Bit Viewer: %08x",addr)

	gui.beginWindow(title,x,y,400,0)
	for i = 0,rows,1 do
	    gui.text(string.format("%08x: ",addr))
        gui.rightText(string.format("%04x %04x %04x %04x %04x %04x %04x %04x",
	    r(addr+0x0),r(addr+0x2),r(addr+0x4),r(addr+0x6),
	    r(addr+0x8),r(addr+0xa),r(addr+0xc),r(addr+0xe)))
	    addr = addr + 0x10
	end
	gui.endWindow()

end

function Memory32viewer(x,y,rows,addr)
    local r = mem.read32;
	local title = string.format("Memory 32 Bit Viewer: %08x",addr)

	gui.beginWindow(title,x,y,400,0)
	for i = 0,rows,1 do
	    gui.text(string.format("%08x: ",addr))
        gui.rightText(string.format("%08x %08x %08x %08x",
	    r(addr),r(addr+4),r(addr+8),r(addr+12)))
	    addr = addr + 0x10
	end
	gui.endWindow()
end

function RatioMath()
	local sh = emu.display.height
	local sw = emu.display.width
	local gw = (4/3)*sh
	wbar = (sw-gw)/2

	local gh = (3/4)*sw
	hbar = (sh-gh)/2


--[[
--debug stuff 
	gui.beginWindow("Display Math",32,256,200,0)
	gui.text(string.format("Screen W,H: %d,%d",sw,sh))
	gui.text(string.format("4:3 Height from W: %f",sw-wbar*2))
	gui.text(string.format("4:3 Width from H: %f",sh-hbar*2))
	gui.text(string.format("Bar W: %f",wbar))
	gui.text(string.format("Bar H: %f",hbar))
	gui.endWindow()

	gui.line(0,128,wbar,128,0xff0000ff)
	gui.line(128,hbar,128,0,0xff00ffff)
]]
end
