--[[
	--------------------------
		Ask question scene
	--------------------------
--]]

-- Import modules

local images = require "imageFiles"
local storyboard = require "storyboard"
require "storyboardex"

-- Initialize static module-specific info

local questionItem

-- Declare scene objects

local background, questionText, answerText, exitButton

-- Make new storyboard scene

local scene = storyboard.newScene()

--[[
	Object event handlers
--]]

local function onExitButtonTap( self, event )
	os.exit()
end

local function onTouchSlide( self, event )
	local numQuestions = table.getn( storyboard.state.questions )
	if event.phase == "moved" then
		if event.x < event.xStart then
		
			if storyboard.state.currentQuestionNumber < numQuestions then
				storyboard.state.currentQuestionNumber = storyboard.state.currentQuestionNumber + 1
				
			elseif storyboard.state.currentQuestionNumber < 944 then
				local qids = storyboard.state.idGenerator.getNextIds( 10 )
				local questions = storyboard.state.db.getQuestionsById( qids )
				for i, question in pairs( questions ) do
					table.insert( storyboard.state.questions, question )
				end
				storyboard.state.currentQuestionNumber = storyboard.state.currentQuestionNumber + 1
				
			else
				storyboard.state.currentQuestionNumber = 1
			end
			
			storyboard.removeScene( scene )
			storyboard.gotoScene( "askQuestionScene2", { effect = "slideLeft", time = 500, params = {} } )	
			
		elseif event.x > event.xStart then
		
			if storyboard.state.currentQuestionNumber > 1 then
				storyboard.state.currentQuestionNumber = storyboard.state.currentQuestionNumber - 1
				storyboard.removeScene( scene )
				storyboard.gotoScene( "askQuestionScene2", { effect = "slideRight", time = 500, params = {} } )	
			end
			
		end	
	end	
	
	return true
end

--[[
	Scene event handlers
--]]

-- Create scene handler

function scene:createScene( event )
	scene:setScene( event )
end

function scene:setScene( event )

	-- Get current question item
	
	questionItem = storyboard.state.questions[storyboard.state.currentQuestionNumber]
	
	-- Display scene group
	
	local group = scene.view
	
	-- Initialize UI objects
	
	background = display.newRect( 0, 0, display.contentWidth, display.contentHeight )
	background:setFillColor( 255, 255, 255 )
	
	exitButton = display.newImage( images.exitButton )
	exitButton.x = display.contentWidth - 30
	exitButton.y = 50
	
	questionText = display.newText( "Question:\n\n" .. questionItem.question, 20, display.contentHeight / 5, display.contentWidth - 40, 0, nil, 28 )
	questionText:setTextColor ( 0, 0, 0 )

	answerText = display.newText ( "Answer: " .. questionItem.answer, 20, questionText.contentBounds.yMax + 70, display.contentWidth - 40, 0, nil, 30 )
	answerText:setTextColor( 1, 159, 16 )

	-- Add objects to group

	group:insert( background )
	group:insert( exitButton )
	group:insert( questionText )
	group:insert( answerText )
end

-- Enter scene handler

function scene:enterScene( event )

	-- Add UI controls
	
	background.touch = onTouchSlide
	exitButton.tap = onExitButtonTap
	
	background:addEventListener( "touch", background )
	exitButton:addEventListener( "tap", exitButton )
	
end

-- Exit scene handler

function scene:exitScene( event )

	-- Remove UI and controls
	
	background:removeEventListener( "touch", background )
	exitButton:removeEventListener( "tap", exitButton )
	
	background:removeSelf()
	exitButton:removeSelf()
	questionText:removeSelf()
	answerText:removeSelf()
	
end

scene:addEventListener( "createScene", scene)
scene:addEventListener( "setScene", scene)
scene:addEventListener( "enterScene", scene)
scene:addEventListener( "exitScene", scene)

return scene