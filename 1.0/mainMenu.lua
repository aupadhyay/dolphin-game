--[[
	Coder: Abhi Upadhyay
	Date: 10/15/14
	Project: Dolphin Game - CodeDay 2014 - Test 1
]]--

_W = display.contentWidth
_H = display.contentHeight

--Variables
local storyboard = require("storyboard")
local menuScene = storyboard.newScene()
local bg
local title
local playBtn
local group
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

function menuScene:createScene(e)
	group = display.newGroup( )

	bg = display.newImageRect("images/menuBg.png", _W, _H)
	bg.x = _W/2
	bg.y = _H/2
	group:insert(bg)

	title = display.newImageRect("images/menuTitle.png", 110,70)
	title.x = _W/2
	title.y = 50
	group:insert(title)

	playBtn = display.newImageRect("images/playBtn.png", 200,100)
	playBtn.x = _W/2
	playBtn.y = _H/2
	playBtn.name = "play"
	playBtn:addEventListener( "tap", leaveMenuScreen )
	group:insert(playBtn)
end

function leaveMenuScreen(e)
	if(e.target.name == "play")then
		playBtn:removeEventListener( "tap",leaveMenuScreen)
		storyboard.gotoScene("gameScene")
	end
end

function menuScene:enterScene(e)

end

function menuScene:exitScene(e)

end

function menuScene:destroyScene(e)
	group:removeSelf()

end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

menuScene:addEventListener( "createScene", menuScene )
menuScene:addEventListener( "enterScene", menuScene )
menuScene:addEventListener( "exitScene", menuScene )
menuScene:addEventListener( "destroyScene", menuScene )

return menuScene
