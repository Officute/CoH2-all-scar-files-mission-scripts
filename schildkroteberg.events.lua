EVENTS = {}
	
function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/c06")
	g_MissionSpeechPath = "theater_of_war/c06"
end

Scar_AddInit(Init_Audio)

function NIS_Init()
	-- cin00
	NISOpening = "ToW\\Challenges\\Schildkroteberg\\nis\\schildkroteberg_intro_v2" 
	nis_load(NISOpening)
	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(1)
end
Scar_AddInit(NIS_Init)

EVENTS.IntroNISLET = function()
	CTRL.Scar_PlayNIS( NISOpening )
	CTRL.SUB()
		CTRL.Event_Delay(0.8)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035255 ) -- LOCDB [11035255] 'The Bolsheviks are readying to attack our positions.'
		CTRL.WAIT()
		CTRL.Event_Delay(1.0)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035256 ) -- LOCDB [11035256] 'They will send their hordes from these positions.'
		CTRL.Event_Delay(12.5)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035257 ) -- LOCDB [11035257] 'You have a brief window to prepare your defenses.'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035258 ) -- LOCDB [11035258] 'Additional resources and artillery support will become available as you hold back successive waves.'
		CTRL.WAIT()
		CTRL.Event_Delay(1.0)
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	introReturn()
end

EVENTS.VehicleWarning = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11035248 ) -- LOCDB [11035248] 'Light armor is being send against you.'
	CTRL.WAIT()
end

EVENTS.Bonus = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049391) -- LOCDB [11049391] "The Soviets are readying further attacks on your position, Commander."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049392) -- LOCDB [11049392] "Make ready to drive back additional waves. "
	CTRL.WAIT()
end
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049393) -- LOCDB [11049393] "The Wehrmacht's ability to withstand and even utterly crush Red Army counterattacks kept the invasion's momentum strong."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049394) -- LOCDB [11049394] "The Soviets' doctrine of rapid counter strikes to halt the Germans proved a complete failure."
	CTRL.WAIT()
end

