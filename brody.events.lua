EVENTS = {}
	
function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/t01")
	g_MissionSpeechPath = "theater_of_war/t01"
end

Scar_AddInit(Init_Audio)

EVENTS.Intro = function()

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040415 ) -- LOCDB [11040415] 'The Fascist invasion is upon us, Comrades.' - 'Intelligence Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040416 ) -- LOCDB [11040416] 'It is our duty to hold the Germans back.' - 'Intelligence Officer'
	CTRL.WAIT()
	
end

EVENTS.Points = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040417 ) -- LOCDB [11040417] 'There are four strategic locations nearby.' - 'Intelligence Officer'
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046721 ) -- LOCDB [11046721] 'There are several strategic locations nearby.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040418 ) -- LOCDB [11040418] 'If we cannot hold these, we will be unable to stop the Fascists.' - 'Intelligence Officer'
	CTRL.WAIT()
end

EVENTS.Reinforcements = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040419 ) -- LOCDB [11040419] 'You are to hold the area for four days and nights.' - 'Intelligence Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040420 ) -- LOCDB [11040420] 'Expect reinforcements at dawn of each new day.' - 'Intelligence Officer'
	CTRL.WAIT()
end

EVENTS.DayTwo = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040421 ) -- LOCDB [11040421] 'Well done, Comrades.' - 'Intelligence Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040422 ) -- LOCDB [11040422] 'Reinforcements await your orders to deploy.' - 'Intelligence Officer'
	CTRL.WAIT()
end

EVENTS.DayThree = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040423 ) -- LOCDB [11040423] 'A new day dawns, Comrades.' - 'Intelligence Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040424 ) -- LOCDB [11040424] 'Reinforcements are waiting to deploy.' - 'Intelligence Officer'
	CTRL.WAIT()
end

EVENTS.DayFour = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040425 ) -- LOCDB [11040425] 'Daybreak is here, Comrades.' - 'Intelligence Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040426 ) -- LOCDB [11040426] 'Summon your final reinforcements and hold through another day and night.' - 'Intelligence Officer'
	CTRL.WAIT()
end

EVENTS.Warning1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040427 ) -- LOCDB [11040427] 'We hold too few strategic points, Comrade commander.' - 'Russian Soldier'
	CTRL.WAIT()
end

EVENTS.Warning2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040428 ) -- LOCDB [11040428] 'We will not hold long at this rate.' - 'Russian Soldier'
	CTRL.WAIT()
end

EVENTS.Warning3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040429 ) -- LOCDB [11040429] 'We must retake some ground or all is lost!' - 'Russian Soldier'
	CTRL.WAIT()
end

EVENTS.Victory = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040430 ) -- LOCDB [11040430] 'Well done, Comrades!' - 'Intelligence Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040431 ) -- LOCDB [11040431] 'You have shown the Fascists the cost of invading the Motherland.' - 'Intelligence Officer'
	CTRL.WAIT()
end

EVENTS.Defeat = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11040432 ) -- LOCDB [11040432] 'Withdraw! The Fascists have overrun you!' - 'Intelligence Officer'
	CTRL.WAIT()
end

EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049425) -- LOCDB [11049425] "The desperate defense and counterattacks in and around Brody managed – at great cost -- to blunt the First Panzer Division’s drive through the Ukraine. "
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049426) -- LOCDB [11049426] "What’s more, the Red Army proved that its T-34s and KV-1s could face German Panzers."
	CTRL.WAIT()
end
