EVENTS = {}
	
function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/t04")
	g_MissionSpeechPath = "theater_of_war/t04"
end

Scar_AddInit(Init_Audio)

EVENTS.Part1Start = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040396 ) -- LOCDB [11040396] 'The Bolsheviks are trying to make a stand in the city of Smolensk.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040397 ) -- LOCDB [11040397] 'But they have been unable to defend their flanks and we almost have them encircled.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040398 ) -- LOCDB [11040398] 'You are to link up with your ally to cut them off completely.'
	CTRL.WAIT()

end

EVENTS.Part1Points = function()

	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040399 ) -- LOCDB [11040399] 'Two key points guard the road into Smolensk.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040400 ) -- LOCDB [11040400] 'You must take them from the Soviets.'
	CTRL.WAIT()
	
end

EVENTS.Part1Artillery = function()

	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040401 ) -- LOCDB [11040401] 'Be warned: The Soviets have a series of artillery batteries on the nearby ridge.'
	CTRL.WAIT()
	
end


EVENTS.Part2Start = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040402 ) -- LOCDB [11040402] 'Well done.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040403 ) -- LOCDB [11040403] 'Now, we must tighten the noose by securing the approaches on either side of the ridge.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040404 ) -- LOCDB [11040404] 'The Red Army has established field command there --'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040405 ) -- LOCDB [11040405] 'Destroy those structures.'
	CTRL.WAIT()

end


EVENTS.Part3Start = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040406 ) -- LOCDB [11040406] 'Excellent.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040407 ) -- LOCDB [11040407] 'The Soviets are now trapped in Smolensk.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040408 ) -- LOCDB [11040408] 'We can expect the Red Army to attempt to break out along either of the routes we've closed off.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040409 ) -- LOCDB [11040409] 'Prepare your forces to stymie any escape.'
	CTRL.WAIT()

end

EVENTS.Part3Breakout = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040410 ) -- LOCDB [11040410] 'A Soviet mechanized convoy is approaching.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040411 ) -- LOCDB [11040411] 'We cannot allow them to escape Smolensk.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040412 ) -- LOCDB [11040412] 'Destroy that armor!'
	CTRL.WAIT()
end

EVENTS.MissionWin = function()

	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040413 ) -- LOCDB [11040413] 'Well done. You are both up for commendation.'
	CTRL.WAIT()
	
end

EVENTS.MissionFail = function()

	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040414 ) -- LOCDB [11040414] 'Unacceptable! The Soviets have escaped with their tanks!'
	CTRL.WAIT()
	
end

EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049432) -- LOCDB [11049432] "Once the Wehrmacht fully encircled Smolensk, the city's fate was sealed. The city would fall in early August."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049433) -- LOCDB [11049433] "Fully 300,000 men would be taken  prisoner, further crippling the Soviet ability to resist the invasion."
	CTRL.WAIT()
end


