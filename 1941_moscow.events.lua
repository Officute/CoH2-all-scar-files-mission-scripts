EVENTS = {}
	
function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/t02")
	g_MissionSpeechPath = "theater_of_war/t02"
end

Scar_AddInit(Init_Audio)

EVENTS.Intro = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040433 ) -- LOCDB [11040433] 'Comrades, the hour is dire.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040434 ) -- LOCDB [11040434] 'The Fascists are mere kilometers from Moscow itself.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040435 ) -- LOCDB [11040435] 'But they have underestimated the resolve of the Soviet People --'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040436 ) -- LOCDB [11040436] 'And the fierceness of the winter.'
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040437 ) -- LOCDB [11040437] 'Wave of bitter cold and blowing snow are battering both armies.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040438 ) -- LOCDB [11040438] 'When the blizzard is active, take care to keep troops under cover or by campfires lest they freeze to death.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040439 ) -- LOCDB [11040439] 'Your Combat Engineers can build additional campfires to keep your troops warm.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040441 ) -- LOCDB [11040441] 'We must win this battle if the capital is to stand.'
	CTRL.WAIT()
end


EVENTS.BlizzardWarning1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040442 ) -- LOCDB [11040442] 'The weather is worsening again.'
	CTRL.WAIT()
end

EVENTS.BlizzardWarning2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040443 ) -- LOCDB [11040443] 'Damnation! The cold is back.'
	CTRL.WAIT()
end

EVENTS.BlizzardWarning3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040444 ) -- LOCDB [11040444] 'Get someplace warm before we all freeze to death.'
	CTRL.WAIT()
end

EVENTS.BlizzardWarning4 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040445 ) -- LOCDB [11040445] 'The wind is picking up again.'
	CTRL.WAIT()
end

EVENTS.BlizzardWarning5 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040446 ) -- LOCDB [11040446] 'General Winter is back, Comrades. Find shelter.'
	CTRL.WAIT()
end

EVENTS.BlizzardWarning6 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040447 ) -- LOCDB [11040447] 'The weather is taking a turn for the worse.'
	CTRL.WAIT()
end

EVENTS.BlizzardLifting1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040448 ) -- LOCDB [11040448] 'The Blizzard is lifting.'
	CTRL.WAIT()
end

EVENTS.BlizzardLifting2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040449 ) -- LOCDB [11040449] 'The weather is clearing.'
	CTRL.WAIT()
end

EVENTS.BlizzardLifting3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040450 ) -- LOCDB [11040450] 'Ah, the cold front has lifted.'
	CTRL.WAIT()
end

EVENTS.BlizzardLifting4 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040451 ) -- LOCDB [11040451] 'The cold is lessening at last.'
	CTRL.WAIT()
end

EVENTS.BlizzardLifting5 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040452 ) -- LOCDB [11040452] 'Clearer weather - for now.'
	CTRL.WAIT()
end

EVENTS.BlizzardLifting6 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040453 ) -- LOCDB [11040453] 'The weawther has lifted, Comarades.'
	CTRL.WAIT()
end

EVENTS.BlizzardLifting7 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040454 ) -- LOCDB [11040454] 'Best take advantage of it.'
	CTRL.WAIT()
end

EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049427) -- LOCDB [11049427] "The defense of Moscow would be the first time the Soviet Union managed to truly thwart the Third Reich. "
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049428) -- LOCDB [11049428] "Operation Typhoon died in the frigid snows of late 1941. "
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049429) -- LOCDB [11049429] "The capital would stand and from it, the Soviets would start on their grueling path to victory."
	CTRL.WAIT()
end
