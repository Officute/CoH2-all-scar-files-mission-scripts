-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Unit Testing Framework

-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")

-------------------------------------------------------------------------
-- [[ Essence LUnit Testing ]]
-------------------------------------------------------------------------

local ELTestStep =
{
	name = "<step>", -- short descriptive title, used to identify step
	delay = 0, -- time in seconds to wait, after the previous step completes, before calling evaluate
	setup = nil, -- function to update world; called when step starts, delay time before evaluation function called
	evaluate = function() return true end, -- assert evaluation function; step succeeds if return true; if step fails, return false, "reason" 
}

-- name_str -- short descriptive title, used to identify step
-- delay_time -- time in seconds to wait, after the previous step completes, before calling functions
-- setup_fn -- function to update world; called when step starts, delay time before evaluation function called
-- evaluate_fn -- assert evaluation function; step succeeds if return true; if step fails, return false, "reason" 
function ELTestStep_Create(name_str, delay_time, setup_fn, evaluate_fn)
	return ELTestStep:Create(name_str, delay_time, setup_fn, evaluate_fn)
end

-- see ELTestStep_Create
function ELTestStep:Create(name_str, delay_time, setup_fn, evaluate_fn)
	assert(name_str ~= nil and type(name_str) == "string", "ELTestStep:Create - name_str must be a string")
	assert(setup_fn == nil or type(setup_fn) == "function", "ELTestStep:Create - setup_fn must be a function")
	assert(evaluate_fn ~= nil and type(evaluate_fn) == "function", "ELTestStep:Create - evaluate_fn must be a function")

	local step = Clone(self)
	
	step.name = name_str
	step.delay = delay_time
	step.setup = setup_fn
	step.evaluate = evaluate_fn
	
	return step
end

-- resultCallback -- continuation function(step_obj, result_bool, reason_str) called when step finally evaluates
function ELTestStep:Test(resultCallback)

	-- PROGRESS ------------
	print("**UTEST** -  Start Step: " .. (self.name or "<unnamed>"))
	------------------------

	if (self.setup ~= nil) then
		self.setup()
	end
	
	if (self.delay <= 0) then
		self:Evaluate(resultCallback)
		return
	end
	
	UnsavedTimeRule_AddOneShot(function() self:Evaluate(resultCallback) end, self.delay, 1)
end

-- private function
-- called by ELTestStep:Test
function ELTestStep:Evaluate(resultCallback)

	-- PROGRESS ------------
	print("**UTEST** -  Finish Step: " .. (self.name or "<unnamed>"))
	------------------------

	if (self.evaluate == nil) then
		resultCallback(self, false, "Missing step:evaluate")
		return
	end
	
	local result, reason = self.evaluate()
	
	resultCallback(self, result, reason)
end


-------------------------------------------------------------------------

local ELTestUnit = 
{
	name = "<basic unit test>", -- unique descriptive text
	setup = nil, -- init map state for  this test (assume map is in original state)
	cleanup = nil, -- return map to initial state 
	
	steps = {}, -- ordered list of ELTestSteps
	
	timer = nil, -- objective timer (not used if nil)
}

-- name_str -- unique descriptive text
-- setup -- init map state for  this test (assume map is in original blank, or parent test unit, state)
-- cleanup -- return map to initial state
function ELTestUnit_Create(name_str, setup_fn, cleanup_fn)
	return ELTestUnit:Create(name_str, setup_fn, cleanup_fn)
end

-- see ELTestUnit_Create
function ELTestUnit:Create(name_str, setup_fn, cleanup_fn)
	assert(name_str ~= nil and type(name_str) == "string", "ELTestUnit:Create - name_str must be a string")
	assert(setup_fn == nil or type(setup_fn) == "function", "ELTestUnit:Create - setup_fn must be a function")
	assert(cleanup_fn == nil or type(cleanup_fn) == "function", "ELTestUnit:Create - cleanup_fn must be a function")

 	local test = Clone(self)

	test.name = name_str
	test.setup = setup_fn
	test.cleanup = cleanup_fn
	
	test.timer =
	{
		SetupUI = function() end,
		OnStart = function() end,
		OnComplete = function() end,
		OnFail = function()	end,
		IsComplete = function() return false; end,
		
		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,
		Title = LOC(""),
		Description = LOC(""),
		TitleEnd = LOC("Done"),	
		TitleFail = LOC("FAILED"),	
		Type = OT_Primary,
	}
	
	return test
end

-- step is a ELTestStep
function ELTestUnit:AddStep(step)
	assert(step ~= nil and type(step) == "table", "ELTestUnit:AddStep - expected valid step object")
	
	table.insert(self.steps, step)
end

-- resultCallback -- continuation function(test_obj, {result_str}) called when test completes
function ELTestUnit:Test(resultCallback)
	local test = self
	local title = (test.name or "<unnamed>") .. ": <" .. tostring(table.getn(test.steps)) .. " steps>"
	
	-- PROGRESS ------------
	print("**UTEST** - Running Test: " .. title)
	------------------------

	if (table.getn(self.steps) <= 0) then
		resultCallback(self, {self.name .. ": <no test steps>"})
		return
	end
	
	if (self.setup ~= nil) then
		self.setup()
	end

	local results = {}
	local step_itr, step = next(test.steps)
	local testContinuation -- need to assign afterwards for function recursion to work
	testContinuation = function(step_obj, result_bool, reason_str)

		table.insert(results, {title=step_obj.name .. ": <reason:" .. tostring(reason_str or ((result_bool and "succeeded") or "failed")) .. ">", result=result_bool})
		step_itr, step = next(test.steps, step_itr)
		
		if (step ~= nil) then
			if (test.timer ~= nil) then
				Objective_UpdateText(test.timer, LOC(step.name), LOC(title), true)
				Objective_StartTimer(test.timer, COUNT_DOWN, step.delay)
			end
			step:Test(testContinuation)
		else
			if (test.timer ~= nil) then
				Objective_StopTimer(test.timer)
				if (result_bool) then
					Objective_Complete(test.timer)
				else
					Objective_Fail(test.timer)
				end
				UnsavedTimeRule_AddOneShot(function() Objective_Show(test.timer, false) end, 2, 1)
			end
			if (test.cleanup ~= nil) then
				test.cleanup()
			end
			resultCallback(test, {title=title, step_results=results})
		end
	end
	
	if (step ~= nil) then
		if (test.timer ~= nil) then
			test.timer.Title = LOC(step.name)
			test.timer.Description = LOC(title)
			Objective_Register(test.timer)
			Objective_Start(test.timer, true)
			Objective_StartTimer(test.timer, COUNT_DOWN, step.delay)
		end
		step:Test(testContinuation)
	else
		resultCallback(test, {title=title, step_results=results})
	end
end


-------------------------------------------------------------------------

local ELTestFramework =
{
	tests = {}, -- ordered list of tests to run
	results = {},
}

-- returns a new testing framework; requires client to add tests  
function ELTestFramework_Create()
	return ELTestFramework:Create()
end

-- see ELTestFramework_Create
function ELTestFramework:Create()
	local testing = Clone(self)
	
	return testing
end

function ELTestFramework:AddTest(test)
	assert(test ~= nil and type(test) == "table", "ELTestFramework:AddTest - expected valid test object")
	
	table.insert(self.tests, test)
end

function ELTestFramework:RunTests()

	self.results = {title="ELTestFramework <Top Level>", test_results={}}

	local tester = self
	local test_itr, test = next(tester.tests)
	local testContinuation -- need to assign afterwards for function recursion to work
	testContinuation = function(test_obj, result_table)

		table.insert(tester.results.test_results, result_table)
		test_itr, test = next(tester.tests, test_itr)
		
		if (test ~= nil) then
			test:Test(testContinuation)
		else
			self:OutputResultsTable(tester.results)
		end
	end

	if (test ~= nil) then
		test:Test(testContinuation)
	else
		self:OutputResultsTable({title="<no tests>"})
	end
end

-- results_table is a table of results entries; it has the form: {title="str", test_results={...}} or {title="str", step_results={...}}
-- test_results are a table with entries of the second form,
-- step_results are a table with entries of the form: {title="str", result=bool}
function ELTestFramework:OutputResultsTable(results_table, indent_str)
	local indent = indent_str or ""
	local next_indent = indent .. "  "

	print(indent .. tostring(results_table.title or "<no tests>") .. "\n")
	
	if (results_table.test_results ~= nil) then
		for i,v in ipairs(results_table.test_results) do 
			self:OutputResultsTable(v, next_indent)
		end
	end
	
	if (results_table.step_results ~= nil) then
		for i,v in ipairs(results_table.step_results) do 
			local result_str = (v.result and "pass") or "FAILED"
			
			print(next_indent .. result_str .. " : " .. tostring(v.title or "<nil>") .. "\n")
		end
	end

	-- quit on completion if run as an autotest
	Scar_DebugConsoleExecute("if cmdline_exist(\"autotest\") then\nGame_QuitApp()\nend")
end
