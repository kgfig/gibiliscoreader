local sqlite3 = require "sqlite3"
local dbPath = system.pathForFile( "gibilisco_questions.db", system.ResourceDirectory )
local db = sqlite3.open( dbPath )

local module = {}

local function onSystemEvent( event )
	if event.type == "applicationExit" then
		if db and db:isopen() then
			db:close()
		end
	end
end

local queries = {
	selectQuestionsById = [[SELECT question_id, question_text as question, correct_answer as answer FROM questions WHERE question_id in (%s)]],
	selectAllQuestions = [[SELECT question_id, question_text as question, correct_answer as answer FROM questions]],
}

module.getQuestionsById = function( questionIds )
	local questions, questionIdSet, questionIdCount, selectQuestionsQuery
	
	questions = {}
	questionIdSet = ""
	
	for i, qid in pairs( questionIds ) do
		questionIdSet = questionIdSet .. qid .. ", "
	end
	
	questionIdSet = string.sub( questionIdSet, 1, string.len(questionIdSet) - 2 )
	selectQuestionsQuery = string.format( queries.selectQuestionsById, questionIdSet )
	
	for questionRow in db:nrows( selectQuestionsQuery ) do
		local questionItem = {
			id = questionRow.question_id,
			question = questionRow.question,
			answer = questionRow.answer
		}
		table.insert( questions, questionItem )
	end
	
	return questions
end

module.getAllQuestions = function( questionIds )
	local questions = {}
	
	for questionRow in db:nrows( queries.selectAllQuestions ) do
		local questionItem = {
			id = questionRow.question_id,
			question = questionRow.question,
			answer = questionRow.answer
		}
		table.insert( questions, questionItem )
	end
	
	return questions
end

Runtime:addEventListener( "system", onSystemEvent )

return module