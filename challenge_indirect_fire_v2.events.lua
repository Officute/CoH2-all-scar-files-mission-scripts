EVENTS = {}
	
function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/c03")
	g_MissionSpeechPath = "theater_of_war/c03"
end

Scar_AddInit(Init_Audio)

	
EVENTS.Intro = function()
	CTRL.Scar_PlayNIS( NISOpening )
	CTRL.SUB()
		CTRL.Event_Delay(2)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035224 ) -- LOCDB [11035224] 'We are preparing to pull our lines back, Comrade, but we cannot leave the fascists anything to use against us.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035225 ) -- LOCDB [11035225] 'Use your Katyusha rocket trucks and other troops to destroy any structure the Germans have built or occupied.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035226 ) -- LOCDB [11035226] 'There are several abandoned Katyushas hidden in the ruins.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035227 ) -- LOCDB [11035227] 'Use infantry to recover them.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035228 ) -- LOCDB [11035228] 'If you can secure strategic points, we can delay the retreat to give you more time.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035229 ) -- LOCDB [11035229] 'Destroying buildings the Germans have yet to occupy will also give you more time.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035230 ) -- LOCDB [11035230] 'Good luck, Comrade'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	introReturn()
end

EVENTS.Intro2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035225 ) -- LOCDB [11035225] 'Use your Katyusha rocket trucks and other troops to destroy any structure the Germans have built or occupied.'
	CTRL.WAIT()
	
end

EVENTS.Katyushas = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035226 ) -- LOCDB [11035226] 'There are several abandoned Katyushas hidden in the ruins.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035227 ) -- LOCDB [11035227] 'Use infantry to recover them.'
	CTRL.WAIT()
end

EVENTS.Point = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035228 ) -- LOCDB [11035228] 'If you can secure strategic points, we can delay the retreat to give you more time.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035229 ) -- LOCDB [11035229] 'Destroying buildings the Germans have yet to occupy will also give you more time.'
	CTRL.WAIT()
end

EVENTS.NeutralBuilding = function()
end

EVENTS.Return = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035230 ) -- LOCDB [11035230] 'Good luck, Comrade'
	CTRL.WAIT()
end

EVENTS.Timer1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035231 ) -- LOCDB [11035231] 'You are running out of time, Comrade.'
	CTRL.WAIT()
end

EVENTS.Timer2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035232 ) -- LOCDB [11035232] 'We must withdraw if you cannot buy us more time.'
	CTRL.WAIT()
end

EVENTS.Bonus = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049379) -- LOCDB [11049379] "Excellent, Comrade."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049380) -- LOCDB [11049380] "Eliminate the remaining German structures to fully cover our retreat from the city."
	CTRL.WAIT()
end

EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049377) -- LOCDB [11049377] "Soviet forces managed to hold Kiev until September 17th, when the encircled city finally fell. "
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049378) -- LOCDB [11049378] "The German invaders took many prisoners, but found much of the city’s infrastructure utterly destroyed. "
	CTRL.WAIT()
end


