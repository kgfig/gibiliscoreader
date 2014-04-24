local storyboard = require "storyboard"
local db = require "appDb"
local idGenerator = require "randomIdSelector"
local images = require "imageFiles"

-- Initialize state variables

storyboard.state = {}
storyboard.state.db = db
storyboard.state.questions = {}
storyboard.state.currentQuestionNumber = 0
storyboard.state.idGenerator = idGenerator

-- Splash objects

local splashSize, splashSequence, splashSheet, splashImage

local function removeSplash()
	splashImage:removeSelf()
	storyboard.gotoScene( "askQuestionScene" )
end

-- Create splash

splashSize = {
	width = 720,
	height = 1280,
	numFrames = 10,
	sheetContentWidth = 1440,
	sheetContentHeight = 6400
}

splashSequence = {
	{ 
	name = "strangeUsui",
	start = 1,
	count = 10,
	time = 800,
	loopCount = 0,
	loopDirection = "forward"
	}
}

splashSheet = graphics.newImageSheet( images.splash, splashSize )
splashImage = display.newSprite( splashSheet, splashSequence )
splashImage.x = display.contentWidth / 2
splashImage.y = display.contentHeight / 2

splashImage:play()

-- Retrieve ids from database

local qids = storyboard.state.idGenerator.getNextIds( 200 )
local questions = storyboard.state.db.getQuestionsById( qids )
storyboard.state.questions = questions
storyboard.state.currentQuestionNumber = 1
timer.performWithDelay( 8000,  removeSplash )