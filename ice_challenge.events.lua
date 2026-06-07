EVENTS = {}
	
function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/c02")
	g_MissionSpeechPath = "theater_of_war/c02"
end

Scar_AddInit(Init_Audio)

EVENTS.Intro = function()
	CTRL.Scar_PlayNIS( NISOpening )
	CTRL.SUB()
		CTRL.Event_Delay(2)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035259 ) -- LOCDB [11035259] 'This point is of strategic value, Comrade.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035260 ) -- LOCDB [11035260] 'We cannot allow it to fall into German hands.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035261 ) -- LOCDB [11035261] 'The Germans will be attacking across the frozen river, so use the ice to your advantage.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035262 ) -- LOCDB [11035262] 'Additional troops and resources will arrive as you hold back successive German waves.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035263 ) -- LOCDB [11035263] 'Good luck, Comrade.'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	introReturn()
end


EVENTS.Approaches = function()

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035261 ) -- LOCDB [11035261] 'The Germans will be attacking across the frozen river, so use the ice to your advantage.'
	CTRL.WAIT()
	
end


EVENTS.Reinforcements = function()

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035262 ) -- LOCDB [11035262] 'Additional troops and resources will arrive as you hold back successive German waves.'
	CTRL.WAIT()
	
end


EVENTS.Return = function()

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035263 ) -- LOCDB [11035263] 'Good luck, Comrade.'
	CTRL.WAIT()
	
end

EVENTS.Bonus = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049374) -- LOCDB [11049374] "Well done, Comrade."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049375) -- LOCDB [11049375] "But the fascists are not yet backing down."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049376) -- LOCDB [11049376] "Prepare to repel additional waves of attackers."
	CTRL.WAIT()
end
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049381) -- LOCDB [11049381] "This victory, and countless other stands against the fascists, finally halted the German advance into the Soviet Union. "
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049382) -- LOCDB [11049382] "Leningrad, Moscow and other key cities would stand, and the Red Army would ultimately drive into the heart of Germany itself."
	CTRL.WAIT()
end


