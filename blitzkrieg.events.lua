EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/c04")
	g_MissionSpeechPath = "theater_of_war/c04"
end

Scar_AddInit(Init_Audio)
	
EVENTS.Intro = function()
	
	CTRL.Scar_PlayNIS( NISOpening )
	CTRL.SUB()
		CTRL.Event_Delay(2)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035233 ) -- LOCDB [11035233] 'Your force has broken through the Soviet lines.' - 'German Announcer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035234 ) -- LOCDB [11035234] 'Use your mobility and firepower to dislodge the Bolsheviks from as many positions are possible.' - 'German Announcer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035235 ) -- LOCDB [11035235] 'Capturing enemy points will gain you supplies.' - 'German Announcer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035236 ) -- LOCDB [11035236] 'But Soviet counter attacks are likely once a point is captured.' - 'German Announcer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035237 ) -- LOCDB [11035237] 'Stukka aircraft will provide you with reconnaissance and air support once you have take a few points.' - 'German Announcer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035238 ) -- LOCDB [11035238] 'The Russians are not expecting you, so use speed and surprise to your advantage.' - 'German Announcer'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	Return2()
	
end

EVENTS.Point = function()
end

EVENTS.Return = function()
end


EVENTS.Minefield = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, 11040383 ) -- LOCDB [11040383] 'Beware! They've mined the area!'
	CTRL.WAIT()
end

EVENTS.Trap = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, 11040384 ) -- LOCDB [11040384] 'Clear out! There's a bomb!'
	CTRL.WAIT()
end

EVENTS.Bonus = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049383) -- LOCDB [11049383] "Good work, Commander."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049384) -- LOCDB [11049384] "The Bolsheviks remain in disarray. Continue to secure the remaining strategic locations."
	CTRL.WAIT()
end
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049385) -- LOCDB [11049385] "The highly mobile and well disciplined Panzer divisions continued to be devastatingly effective against the poorly organized Soviets."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049386) -- LOCDB [11049386] "Ultimately, only the mud of autumn and the snow of winter would slow the Wehrmacht's advance sufficiently for the Soviets to muster an effective defense."
	CTRL.WAIT()
end


