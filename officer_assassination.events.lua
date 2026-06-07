EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/c05")
	g_MissionSpeechPath = "theater_of_war/c05"
end

Scar_AddInit(Init_Audio)
	
EVENTS.Intro = function()
	CTRL.Scar_PlayNIS( NISOpening )
	CTRL.SUB()
		CTRL.Event_Delay(1.0)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035239 ) -- LOCDB [11035239] 'Six high-ranking Bolsheviks are located in this area.' - 'German Announcer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035240 ) -- LOCDB [11035240] 'Locate and assassinate these officers to cripple Soviet command in the region.' - 'German Announcer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035241 ) -- LOCDB [11035241] 'Beware. Each officer is well defended.' - 'German Announcer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035242 ) -- LOCDB [11035242] 'Use alternate approaches to flank the enemy are take out your targets.' - 'German Announcer'
		CTRL.WAIT()
		CTRL.Event_Delay(2.0)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035243 ) -- LOCDB [11035243] 'You are behind enemy lines, so you will have to raid Russian supplies for ammunition.' - 'German Announcer'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	introReturn()
end
EVENTS.IntroOfficer = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035240 ) -- LOCDB [11035240] 'Locate and assassinate these officers to cripple Soviet command in the region.' - 'German Announcer'
	CTRL.WAIT()
end
EVENTS.IntroGuard = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035241 ) -- LOCDB [11035241] 'Beware. Each officer is well defended.' - 'German Announcer'
	CTRL.WAIT()
end
EVENTS.IntroFlank = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035242 ) -- LOCDB [11035242] 'Use alternate approaches to flank the enemy are take out your targets.' - 'German Announcer'
	CTRL.WAIT()
end
EVENTS.Return = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035243 ) -- LOCDB [11035243] 'You are behind enemy lines, so you will have to raid Russian supplies for ammunition.' - 'German Announcer'
	CTRL.WAIT()
end
EVENTS.Reinforcements = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035244 ) -- LOCDB [11035244] 'Additional troops have arrived to support you.' - 'German Announcer'
	CTRL.WAIT()
end
EVENTS.ScoutCar1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035245 ) -- LOCDB [11035245] 'Take heed. The Bolsheviks have increased their patrols.' - 'German Announcer'
	CTRL.WAIT()
end

EVENTS.ScoutCar2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035246 ) -- LOCDB [11035246] 'Take care. More Soviet patrols are covering the area.' - 'German Announcer'
	CTRL.WAIT()
end

EVENTS.SniperTeam = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035247 ) -- LOCDB [11035247] 'Radio intercepts indicate Soviet snipers have been dispatched to hunt you down.' - 'German Announcer'
	CTRL.WAIT()
end

EVENTS.T70 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035248 ) -- LOCDB [11035248] 'Light armor is being send against you.' - 'German Announcer'
	CTRL.WAIT()
end

EVENTS.enc6CounterAttack = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11035249 ) -- LOCDB [11035249] 'Fascists!' - 'Junior Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11035250 ) -- LOCDB [11035250] 'Call in the Shock Troops to attack their flank!' - 'Junior Officer'
	CTRL.WAIT()
end

EVENTS.enc8CounterAttack = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11035251 ) -- LOCDB [11035251] 'Germans!' - 'Junior Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11035252 ) -- LOCDB [11035252] 'Call in the tanks!' - 'Junior Officer'
	CTRL.WAIT()
end

EVENTS.enc9BombingRun = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11035253 ) -- LOCDB [11035253] 'We are under attack!' - 'Junior Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11035254 ) -- LOCDB [11035254] 'Bombing run on this position!' - 'Junior Officer'
	CTRL.WAIT()
end

EVENTS.Search = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11046242) -- LOCDB [11046242] "Search the nearby farmsteads to find your other targets."
	CTRL.WAIT()
end
EVENTS.Bonus = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049387) -- LOCDB [11049387] "Excellently done."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049388) -- LOCDB [11049388] "But two additional Soviet officers are nearby. Eliminate them as well."
	CTRL.WAIT()
end
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049389) -- LOCDB [11049389] "By finding and killing the field officers coordinating Soviet defenses, the Wehrmacht continued to sow discord in the enemy ranks."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049390) -- LOCDB [11049390] "With every slain officer, one more nail was driven into the Soviet coffin."
	CTRL.WAIT()
end
