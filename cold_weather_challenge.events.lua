EVENTS = {}
	
function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/c01")
	g_MissionSpeechPath = "theater_of_war/c01"
end

Scar_AddInit(Init_Audio)

EVENTS.Intro = function()
	CTRL.Scar_PlayNIS( NIS01 )
	CTRL.SUB()
		CTRL.Event_Delay(0.5)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035209 ) -- LOCDB [11035209] 'This blizzard has caught a fascist armored column by surprise, comrade.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035210 ) -- LOCDB [11035210] 'They are completely bogged down.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035211 ) -- LOCDB [11035211] 'Move in to eliminate those German vehicles while the cold weather lasts.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035212 ) -- LOCDB [11035212] 'But have a care: General Winter will not spare you if you remain exposed to the cold.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035213 ) -- LOCDB [11035213] 'You will need to raid German supplies for ammunition.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035214 ) -- LOCDB [11035214] 'The fascists hold the major crossroads, Comrade.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035215 ) -- LOCDB [11035215] 'Dislodge them and we can send you additional reinforcements.'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	Return()
end


EVENTS.ReturnToPlayer = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035216 ) -- LOCDB [11035216] 'Your troops are equipped with flares.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035217 ) -- LOCDB [11035217] 'Use them to scout out locations without exposing yourself.'
	CTRL.WAIT()
end

EVENTS.ReinforcementsComplete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035219 ) -- LOCDB [11035219] 'Well done, Comrade.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035220 ) -- LOCDB [11035220] 'Conscripts and combat engineers are moving in to reinforce your troops.'
	CTRL.WAIT()
end


EVENTS.Partisans = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11035221 ) -- LOCDB [11035221] 'My thanks, Comrade.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11035222 ) -- LOCDB [11035222] 'My partisans are at your disposal.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11035223 ) -- LOCDB [11035223] 'Just point us at the fascists.'
	CTRL.WAIT()
end

EVENTS.Bonus = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049370) -- LOCDB [11049370] "Excellent. The blizzard shows no sign of lifting."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049371) -- LOCDB [11049371] "Continue your efforts and eliminate the last of the German vehicles."
	CTRL.WAIT()
end
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049372) -- LOCDB [11049372] "A few squads of Soviet infantry, taking advantage of the cold, were able to eliminate an entire German armored column. "
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049373) -- LOCDB [11049373] "It would be victories like this that would weaken the overextended Germans and ultimately save Moscow."
	CTRL.WAIT()
end


