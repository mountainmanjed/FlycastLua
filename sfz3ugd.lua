mem = flycast.memory;
gui = flycast.ui;
emu = flycast.state;

require "tools"


nametable = {
	"Ryu",
	"Ken",
	"Akuma",
	"Charlie",
	"Chun",
	"Adon",
	"Sodom",
	"Guy",
	"Birdie",
	"Rose",
	"Dictator",
	"Sagat",
	"Dan",
	"Sakura",
	"Rolento",
	"Dhalsim",
	"Zangief",
	"Gen",
	"SF2 Chun",
	"Gen Crane",
	"Katana Sodom",
	"CPS2 Boxer",
	"Cammy",
	"Evil Ryu",
	"E.Honda",
	"Blanka",
	"Rainbow Mika",
	"Cody",
	"Claw",
	"Karin",
	"Juli",
	"Juni",
	"Guile",
	"Fei Long",
	"Dee Jay",
	"T.Hawk",
	"Shin Akuma",
	"New Boxer"

}

function cbStart()
end



function cbOverlay()
    RatioMath()

--global cheat
    mem.write8(0x0C420219,0x63) -- infinite time

if wbar > 0 then
	cpsx = (emu.display.width-wbar*2)/384
	cpsy = (emu.display.height)/224
	gui.line(0,128,wbar,128,0xff0000ff)
else
	cpsx = (emu.display.width)/384
	cpsy = (emu.display.height-hbar*2)/224
	gui.line(128,0,128,hbar,0xff0000ff)
end


camx = mem.read16s(0xc429046)*cpsx
camy = (mem.read16s(0xc42904a))*cpsy


player(16,16,0xc4202e8)
player(640,16,0xc420744)
player(16,300,0xc420ba0)
player(640,300,0xc420ffc)

end


function drawaxis(x,y,s)
	local sx = s*cpsx
	local sy = s*cpsy
	gui.line(x+sx,y,x-sx,y,0xffffff00)
	gui.line(x,y+sy,x,y-sy,0xffff00ff)
end

function draw_colbox(addr,x,y,f,color1,color2)
	local bxo = ((mem.read16s(addr+0)*f)*cpsx) +x
	local byo = (y-mem.read16s(addr+2)*cpsy)
	local bxr = mem.read16(addr+4)*cpsx
	local byr = mem.read16(addr+6)*cpsy

	local l = bxo-bxr;
	local r = bxo+bxr;
	local t = byo-byr;
	local b = byo+byr;

	gui.line(l,t,r,t,color2)
	gui.line(l,t,l,b,color2)
	gui.line(l,b,r,b,color2)
	gui.line(r,t,r,b,color2)
	gui.line(l,t,r,b,color1)

	--gui.rect(l,t,r,b,color1,color2)
end

function player(x,y,addr)
--player data
	local pl_active = mem.read8(addr)


	local pl_state0 = mem.read8(addr+4)
	local pl_state1 = mem.read8(addr+5)
	local pl_state2 = mem.read8(addr+6)
	local pl_state3 = mem.read8(addr+7)

	local pl_flip = mem.read8(addr+0xb)

	local plx = mem.read16s(addr+0x12)*cpsx
	local ply = mem.read16s(addr+0x16)*cpsy

	local anim_pnt = mem.read32(addr+0x1c)

	local pl_hp = addr+0x60

	local pl_cbset_pnt = mem.read32(addr+0xb8)
	local pl_unkn_pnt = mem.read32(addr+0xbc)
	local pl_head_pnt = mem.read32(addr+0xc0)
	local pl_body_pnt = mem.read32(addr+0xc4)
	local pl_legs_pnt = mem.read32(addr+0xc8)
	local pl_push_pnt = mem.read32(addr+0xcc)
	local pl_attk_pnt = mem.read32(addr+0xd0)


	local taunt_count = addr + 0xee
	--mem.write8(taunt_count,0x20)

	local activebox = mem.read32(addr+0xf0)

--all the stuff that they cut off the original animation data
	local pnt_118 = mem.read32(addr+0x118)

	local charid = mem.read8(addr+0x142)




	local pl_cpuflag = addr+0x165

	local pl_specl_cancel = addr+0x20e

	--local pl_super_cancel = addr+0x273--might be it
	
--math
	if wbar > 0 then
		use_x = (plx-camx)+wbar
		use_y = (camy-ply)+(230*cpsy)
	else
		use_x = (plx-camx)
		use_y = (camy-ply)+(230*cpsy)+hbar
	end

	local xflip = (-1)^(pl_flip&1)

	local head_loc = pl_head_pnt+(mem.read8(activebox+00)*8);
	local body_loc = pl_body_pnt+(mem.read8(activebox+01)*8);
	local legs_loc = pl_legs_pnt+(mem.read8(activebox+02)*8);
	local push_loc = pl_push_pnt+(mem.read8(activebox+03)*8);

	local attk_id = (mem.read8(pnt_118+1))
	local attk_loc = pl_attk_pnt+attk_id*0x20;

--if player active
if pl_active ~= 0 then
--draw
	drawaxis(use_x,use_y,8)
	draw_colbox(head_loc,use_x,use_y,xflip,0x78ff8888,0xffff8888)
	draw_colbox(body_loc,use_x,use_y,xflip,0x78ff8888,0xffff8888)
	draw_colbox(legs_loc,use_x,use_y,xflip,0x78ff8888,0xffff8888)
	draw_colbox(push_loc,use_x,use_y,xflip,0x78ffffff,0xffffffff)
	draw_colbox(attk_loc,use_x,use_y,xflip,0x780000ff,0xff0000ff)


--cheats
	--mem.write8(pl_cpuflag,1) --force Cpu to play
	mem.write16(pl_hp,0x90)


--hud
	gui.beginWindow(string.format("%08x",addr),x,y,200,0)
	gui.text(string.format("Char ID: %x %s",charid,nametable[charid+1]))
	gui.endWindow()

	end

--player end
end

flycast_callbacks = {
	start = cbStart,
	overlay = cbOverlay
}
