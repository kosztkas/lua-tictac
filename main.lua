-- Your app starts here!
local bg = director:createSprite(director.displayCenterX, director.displayCenterY, "bg.jpg")
bg.xAnchor=0.5; bg.yAnchor=0.5

--local p1name = nui:readString("Enter your name X", "")
--local p2name = nui:readString("Enter your name O", "")
local p1name = "Alice"
local p2name = "Bob"
local nxt=p1name

local Next = director:createLabel({x=director.displayWidth/10, y=director.displayWidth/3, text='Next: '..nxt, color=color.black, hAlignment="center"})
local title = director:createLabel({x=0, y=-10, text='Tic-Tac-Toe', color=color.black, hAlignment="center", vAlignment="top",})
local Player1 = director:createLabel({x=director.displayWidth/25, y=director.displayWidth/3+50, text="X:"..p1name, color=color.black, hAlignment="left"})
local Player2 = director:createLabel({x=director.displayWidth/25, y=director.displayWidth/3, text="O:"..p2name, color=color.black, hAlignment="left"})

--Drawing the board
function DrawLines(x, y, v, h)

	return director:createLines( {
		x=x, y=y,
		coords={0,0, v,h},
		strokeColor=color.black,
	} )
end
local Lines = {}
Lines[0]=DrawLines(10, director.displayHeight-director.displayWidth/3-30, director.displayWidth-20, 0)
Lines[1]=DrawLines(director.displayWidth/3, director.displayHeight-45, 0, -(director.displayWidth-20))
Lines[2]=DrawLines(2*(director.displayWidth/3), director.displayHeight-45, 0, -(director.displayWidth-20))
Lines[3]=DrawLines(10, director.displayHeight-2*director.displayWidth/3-30, director.displayWidth-20, 0)

local turn=0
local cnt=1
local ended=0
local Nodes = {}
local Message = {}

function winMessage(winner)
	Message[1]=director:createSprite({
		x=director.displayCenterX, 
		y=director.displayCenterY,
		xAnchor=0.5,
		yAnchor=0.5,
		xScale=0.8,
		yScale=0.8,
		source = "note.png",
		alpha=0.985
		})
	Message[2]=director:createLabel({x=0, y=director.displayCenterY+25, text="The winner is", color=color.black, hAlignment="center", rotation=2.7})
	Message[3]=director:createLabel({x=0, y=director.displayCenterY-20, text=winner, color=color.black, hAlignment="center", rotation=2.7})
end

function touchHandler(event)

    if (event.phase == 'began' and event.target.value==0 and ended==0) then
	
		if (turn==0) then
			event.target.sprite = DrawX(event.target.x-5,event.target.y-5)
			event.target.value=1
			turn=1
		elseif (turn==1) then
			event.target.sprite = DrawO(event.target.x+5,event.target.y)
			event.target.value=33
			turn=0
		end
		
		print('targetZone:'..event.target.id)
		cnt = cnt+1
		
	end
	if (event.phase == 'ended' and ended==0) then
		check()
		updateNext()
	end
end

function updateNext()
	if (turn==1) then
		nxt= "Next:"..p2name
	else 
		nxt= "Next:"..p1name
	end
	Next.text=nxt
end

function check()
	if ((Nodes[1].value+Nodes[2].value+Nodes[3].value)==3 or
		(Nodes[4].value+Nodes[5].value+Nodes[6].value)==3 or
		(Nodes[7].value+Nodes[8].value+Nodes[9].value)==3 or
		(Nodes[1].value+Nodes[4].value+Nodes[7].value)==3 or
		(Nodes[2].value+Nodes[5].value+Nodes[8].value)==3 or
		(Nodes[3].value+Nodes[6].value+Nodes[9].value)==3 or
		(Nodes[1].value+Nodes[5].value+Nodes[9].value)==3 or
		(Nodes[3].value+Nodes[5].value+Nodes[7].value)==3 and
		ended==0)
	then
		print('X won ')
		winMessage(p1name)
		ended=1
		
	elseif ((Nodes[1].value+Nodes[2].value+Nodes[3].value)==99 or
		(Nodes[4].value+Nodes[5].value+Nodes[6].value)==99 or
		(Nodes[7].value+Nodes[8].value+Nodes[9].value)==99 or
		(Nodes[1].value+Nodes[4].value+Nodes[7].value)==99 or
		(Nodes[2].value+Nodes[5].value+Nodes[8].value)==99 or
		(Nodes[3].value+Nodes[6].value+Nodes[9].value)==99 or
		(Nodes[1].value+Nodes[5].value+Nodes[9].value)==99 or
		(Nodes[3].value+Nodes[5].value+Nodes[7].value)==99 and
		ended==0)  
	then
		print('O won ')
		winMessage(p2name)
		ended=1
	elseif (cnt==10 and ended==0)
	then
		print('TIE ')
		winMessage("nobody, it's a tie!")
		ended=1
	end	
end

function reset()
	print('Setting RE')
	for i=1, 9 do
		if (Nodes[i].sprite~=nil)then
			print("deleting "..i)
			Nodes[i].sprite=Nodes[i].sprite:removeFromParent()
			Nodes[i].value=0
		end
    end
	for i=1, 3 do
		if (Message[i]~=nil)then
			print("deleting mes "..i)
			Message[i]=Message[i]:removeFromParent()
		end
    end
	cnt=1
	turn=0
	updateNext()
	ended=0
end

function resetHandler(event)
    if (event.phase == 'began') then
		reset()
	end
end

function DrawO(x, y)

	return director:createSprite({
		x=x, y=y,
		xScale = (director.displayWidth/160/3.9),
		yScale = (director.displayWidth/160/3.8),
		source = "circle_t.png"})
end	

function DrawX(x, y)

	return director:createSprite({
		x=x, y=y,
		xScale = (director.displayWidth/160/3.3),
		yScale = (director.displayWidth/160/3.2),
		source = "redx_t.png"})
end	

--creating the board touch zones	
Nodes[1] = director:createNode({
	x=10, 
	y=director.displayHeight-director.displayWidth/3-20,
	h=director.displayWidth/3-10,
	w=director.displayWidth/3-10,
	id=1,
	value=0
})
	
Nodes[2] = director:createNode({
	x=10+director.displayWidth/3, 
	y=director.displayHeight-director.displayWidth/3-20,
	h=director.displayWidth/3-10,
	w=director.displayWidth/3-10,
	id=2,
	value=0
})

Nodes[3] = director:createNode({
	x=10+2*director.displayWidth/3, 
	y=director.displayHeight-director.displayWidth/3-20,
	h=director.displayWidth/3-10,
	w=director.displayWidth/3-10,
	id=3,
	value=0
})

Nodes[4] = director:createNode({
	x=10, 
	y=director.displayHeight-2*director.displayWidth/3-20,
	h=director.displayWidth/3-10,
	w=director.displayWidth/3-10,
	id=4,
	value=0
})

Nodes[5] = director:createNode({
	x=10+director.displayWidth/3, 
	y=director.displayHeight-2*director.displayWidth/3-20,
	h=director.displayWidth/3-10,
	w=director.displayWidth/3-10,
	id=5,
	value=0
})

Nodes[6] = director:createNode({
	x=10+2*director.displayWidth/3, 
	y=director.displayHeight-2*director.displayWidth/3-20,
	h=director.displayWidth/3-10,
	w=director.displayWidth/3-10,
	id=6,
	value=0
})

Nodes[7] = director:createNode({
	x=10, 
	y=director.displayHeight-3*director.displayWidth/3-20,
	h=director.displayWidth/3-10,
	w=director.displayWidth/3-10,
	id=7,
	value=0
})

Nodes[8] = director:createNode({
	x=10+director.displayWidth/3, 
	y=director.displayHeight-3*director.displayWidth/3-20,
	h=director.displayWidth/3-10,
	w=director.displayWidth/3-10,
	id=8,
	value=0
})

Nodes[9] = director:createNode({
	x=10+2*director.displayWidth/3, 
	y=director.displayHeight-3*director.displayWidth/3-20,
	h=director.displayWidth/3-10,
	w=director.displayWidth/3-10,
	id=9,
	value=0
})

--reset button
local reset = director:createSprite({
	x=20, 
	y=20,
	xScale=0.7,
	yScale=0.7,
	source = "reset.png"
})

--
for i=1, 9 do
	Nodes[i]:addEventListener('touch', touchHandler)
end

reset:addEventListener('touch', resetHandler)

function hardKeyPressed(event)
  if event.phase == "released" then
    if event.keyCode == key.back then
		system:quit()
    end
  end
end
system:addEventListener("key", hardKeyPressed)
