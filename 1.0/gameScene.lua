--[[
	Coder: Abhi Upadhyay
	Date: 10/15/14
	Project: Dolphin Game - CodeDay 2014 - Test 1
]]--

_W = display.contentWidth
_H = display.contentHeight

--Variables
local storyboard = require('storyboard')
local gameScene = storyboard.newScene()

local mainGroup --
local bg --
local player --
local waterImg
local sharks = {}
local pauseBtn
local score = 0
local scoreTxt
local airBar
local airDamageBar
local maxAir = 100
local currentAir = 50
local energyBar
local energyDamageBar
local maxEnergy = 100
local currentEnergy = 50
local finishImg
local eventBg
local playerUp = false
local playerDown = false
local resumeButton
local finishLineNum = math.random(3000,5000)
local finishLine
local currentEnemy = 1
local scoreTimer
--Functions
local moveBg = {}
local update = {}
local playerJump = {}
local eventListeners = {}
local event = {}
local addEnemies = {}

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

--when scene view doesn't exist
function gameScene:createScene(e)
	mainGroup = display.newGroup()

	bg = display.newImageRect("images/bg.png", _W, _H)
	bg.x = _W/2
	bg.y = _H/2
	mainGroup:insert(bg)

	waterImg  = display.newImageRect("images/water.png", _W,_H)
	waterImg.x = 0
	waterImg.y = _H/2
	mainGroup:insert(waterImg)

	waterImg2  = display.newImageRect("images/water.png", _W,_H)
	waterImg2.x = _W
	waterImg2.y = _H/2
	mainGroup:insert(waterImg2)

	waterImg3  = display.newImageRect("images/water.png", _W,_H)
	waterImg3.x = _W*2
	waterImg3.y = _H/2
	mainGroup:insert(waterImg3)

	player = display.newImageRect("images/player.png", 170,50)
	player.x = 100
	player.y = _H - 70
	mainGroup:insert(player)

	pauseBtn = display.newImageRect( "images/pause.png", 50,50 )
	pauseBtn.x = 30
	pauseBtn.y = 30
	pauseBtn.name = "pause"
	pauseBtn:addEventListener( "tap", pauseTouch)
	mainGroup:insert(pauseBtn)

	scoreTxt = display.newText("Score: " .. score, 120 ,20, native.systemFont, 24)
	scoreTxt:setFillColor( 0/255, 0/255, 0/255)
	mainGroup:insert(scoreTxt)

	airBar = display.newRect(_W - 60,20, maxAir, 10)
	airBar:setFillColor( 000/255, 255/255, 0/255 )
	airBar.strokeWidth = 1
	airBar:setStrokeColor( 255, 255, 255, .5 )
	mainGroup:insert(airBar)
	
	airDamageBar = display.newRect(_W - 60 + airBar.width/2 ,20,maxAir-currentAir,10)
	airDamageBar.anchorX = 1
	airDamageBar:setFillColor( 255/255, 0/255, 0/255 )
	mainGroup:insert(airDamageBar)

	energyBar = display.newRect(_W - 60, 50, maxEnergy, 10)
	energyBar:setFillColor( 000/255, 255/255, 0/255 )
	energyBar.strokeWidth = 1
	energyBar:setStrokeColor( 255, 255, 255, .5 )
	mainGroup:insert(energyBar)
	
	energyDamageBar = display.newRect(_W - 60 + energyBar.width/2 ,50,maxEnergy-currentEnergy,10)
	energyDamageBar.anchorX = 1
	energyDamageBar:setFillColor( 255/255, 0/255, 0/255 )
	mainGroup:insert(energyDamageBar)

	finishLine = display.newImageRect( "images/shark.PNG", 100,100)
	finishLine.x = finishLineNum
	finishLine.y = _H/2

	addEnemies(5);
	scoreTimer = timer.performWithDelay( 500 , addScore , -1)
	timer.performWithDelay( math.random(10000, 20000), enemiesUp , 5)
end

function addScore()

	score = score+1
	scoreTxt.text = "Score: " .. score
end

function addEnemies(num)
	for i=1,num do
		sharks[i] = display.newImageRect("images/shark.PNG", 100,100)
		sharks[i].anchorX = 0
		sharks[i].anchorY = 0
		sharks[i].y = 700
		sharks[i].x = 700
	end
end

function enemiesUp()
	sharks[currentEnemy].x = math.random(0, _W/2)
	sharks[currentEnemy].y = _H + 10
	sharks[currentEnemy].up = true

end

local popupText
local popupTextTimer = nil

function playerJump(e)
	if(currentEnergy >= 2 0)then
		currentAir = maxAir
		airDamageBar.width = maxAir - currentAir
	
		currentEnergy = currentEnergy - 60
		energyDamageBar.width = 100 - currentEnergy
	
		playerUp = true
	else
		popupText = display.newText("Not enough energy!", _W/2,  100, "Norwester", 50)
		popupTextTimer = timer.performWithDelay( 1000, removePopup, 1)
	end
end

function removePopup()
	popupText:removeSelf()
	popupText = nil
	timer.cancel( popupTextTimer )
	popupTextTimer = nil
end

function moveBg(event)
	scrollSpeed = 3

	waterImg.x = waterImg.x - scrollSpeed
	waterImg2.x = waterImg2.x - scrollSpeed
	waterImg3.x = waterImg3.x - scrollSpeed
	
	if (waterImg.x + waterImg.contentWidth/2) < 0 then
	    waterImg:translate( _W*3, 0 )
	end
	if (waterImg2.x + waterImg2.contentWidth/2) < 0 then
	        waterImg2:translate( _W*3, 0 )
	end
	if (waterImg3.x + waterImg3.contentWidth/2) < 0 then
	        waterImg3:translate( _W*3, 0 ) 
	end
end

function update()
	if(finishLine.x <= player.x)then
		event("win")
	end

	if(player.y >= waterImg.contentBounds.yMin)then
		currentAir = currentAir - 0.1
		airDamageBar.width = maxAir - currentAir
	end

	if(currentAir <= 0)then
		event("lose")
	end

	if(not(currentEnergy >= 100))then
		currentEnergy = currentEnergy + 0.2
		energyDamageBar.width = maxEnergy - currentEnergy
	end

	finishLine.x = finishLine.x - 3
	if (playerUp == true) then
		player.y = player.y - 3
		player.x = player.x + 2
		if(player.y <= 125 )then
			playerUp = false
			playerDown = true
		end	
	end

	if (playerDown == true) then
		player.y = player.y + 3
		player.x = player.x + 2
		if(player.y >= _H - 70 )then
			playerUp = false
			playerDown = false
		end	
	end

	if(not (player.x <= 100) and not(playerUp == true) and not(playerDown == true))then
		player.x = player.x - 2
	end


	for i=1,5 do
		if(sharks[i].up == true) then
			sharks[i].y = sharks[i].y - 1
			if (sharks[i].y <= _H - 60) then
				sharks[i]. up = false
				sharks[i].down = true
			end
		end

		if(sharks[i].down == true) then
			sharks[i].y = sharks[i].y + 1
			if (sharks[i].y >= _H + 50) then
				sharks[i].down = false
				sharks[i].x = 700
				sharks[i].y = 700
				score = score + 10
				scoreTxt.text = "Score: ".. score
			end
		end

   		local left = player.contentBounds.xMin <= sharks[i].contentBounds.xMin and player.contentBounds.xMax >= sharks[i].contentBounds.xMin
  	 	local right = player.contentBounds.xMin >= sharks[i].contentBounds.xMin and player.contentBounds.xMin <= sharks[i].contentBounds.xMax
   		local up = player.contentBounds.yMin <= sharks[i].contentBounds.yMin and player.contentBounds.yMax >= sharks[i].contentBounds.yMin
   		local down = player.contentBounds.yMin >= sharks[i].contentBounds.yMin and player.contentBounds.yMin <= sharks[i].contentBounds.yMax
		
		if( (left or right) and (up or down))then
			event("lose");
		end
	end
end
local eventGroup
function event(string)
	gameListeners("remove")
	eventGroup = display.newGroup()
	local eventBg
	local eventText
	local eventButton

	eventBg = display.newImageRect( "images/eventBg.png", 296, 259 )
	eventBg.x = _W/2
	eventBg.y = _H/2
	eventGroup:insert( eventBg)

	if(string == "win")then
		eventText = display.newText("You Win!", _W/2, _H/2 - 75,"Norwester", 50)
		eventGroup:insert( eventText)

		eventScore = display.newText("Score:" .. score, _W/2, _H/2, "Norwester", 50)
		eventGroup:insert( eventScore)

		eventButton = display.newText("Main Menu!", _W/2, _H/2 + 75, "Norwester" , 40 )
		eventGroup:insert( eventButton)
	elseif(string == "lose")then
		eventText = display.newText("You Lose!", _W/2, _H/2 - 75,"Norwester", 50)
		eventGroup:insert( eventText)

		eventScore = display.newText("Score:" .. score, _W/2, _H/2, "Norwester", 50)
		eventGroup:insert( eventScore)

		eventButton = display.newText("Play Again?", _W/2, _H/2 + 75, "Norwester" , 40 )
		eventGroup:insert( eventButton)
	end
end

function pauseTouch(e)
	gameListeners("remove")
	eventGroup = display.newGroup()
	eventBg = display.newImageRect( "images/eventBg.png", 296, 259 )
	eventBg.x = _W/2
	eventBg.y = _H/2
	eventGroup:insert( eventBg)

	eventText = display.newText("Pause", _W/2, _H/2 - 75,"Norwester", 50)
	eventGroup:insert( eventText)

	resumeButton = display.newText("Resume",_W/2, _H/2, "Norwester", 50)
	eventGroup:insert( resumeButton)
	resumeButton.name = "resume"
	resumeButton:addEventListener( "tap", resumeTouch)
end

function resumeTouch(e)	
	gameListeners("add")
	eventGroup:removeSelf()
end
--scene transition finished
function gameScene:enterScene(e)
	print("entering")
	gameListeners("add")
end

--before transition begins
function gameScene:exitScene(e)

end

--when being removed
function gameScene:destroyScene(e)
	mainGroup:removeSelf()
end

function gameListeners( action)
	
	if(action == "add")then
		Runtime:addEventListener( "enterFrame", moveBg )
		Runtime:addEventListener("enterFrame", update)
		bg:addEventListener("tap", playerJump)
	elseif(action == "remove")then
		Runtime:removeEventListener( "enterFrame", moveBg )
		Runtime:removeEventListener("enterFrame", update)
		bg:removeEventListener("tap", playerJump)
		timer.cancel( scoreTimer )
	end
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

gameScene:addEventListener( "createScene", gameScene )
gameScene:addEventListener( "enterScene", gameScene )
gameScene:addEventListener( "exitScene", gameScene )
gameScene:addEventListener( "destroyScene", gameScene )

return gameScene