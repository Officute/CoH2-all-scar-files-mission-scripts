EVENTS = {}
	
function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc1/c02")-- Sound_PreCacheSoundFolder("speech/dlc1/t02")
	g_MissionSpeechPath = "theater_of_war/dlc1/c02"
end

Scar_AddInit(Init_Audio)

function NIS_Init()

	NIS_INTRO = "ToW\\Challenges\\Convoy\\nis\\convoy_intro" 
	nis_load(NIS_INTRO)
	NIS_OUTRO = "ToW\\Challenges\\Convoy\\nis\\convoy_outro" 
	nis_load(NIS_OUTRO)
	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(1)
end

Scar_AddInit(NIS_Init)

EVENTS.OBJDestroyConvoy = function()
	Game_Letterbox(true, 0)
	_moveIntroTruck1()
	Game_FadeToBlack(FADE_IN, 2)
	Rule_AddOneShot(_moveIntroTruck2, 9.5)
	CTRL.Scar_PlayNIS( NIS_INTRO )
	CTRL.SUB()		
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051263) -- LOCDB [11051263] 'The Bolsheviks continue to hold out in Stalingrad, Commander, but they cannot endure if we cut their supply lines.' - 'German_Officer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051264) -- LOCDB [11051264] 'This is a vital route into the besieged city: You are to stop the convoys using the roads.' - 'German_Officer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051864) -- LOCDB [11051864] 'A lightly defended group is approaching, but we expect heavier vehicles to follow.' - 'German Officer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051865) -- LOCDB [11051865] 'Your force is small, so you must scrounge resources in the field.' - 'German Officer'
		CTRL.WAIT()
		UI_NewHUDFeature(HUDF_None, 11051280, "Icons_abilities_ability_german_panzerfaust", 15)
	CTRL.END()
	CTRL.WAIT()
	_removeIntroTrucks()
	Game_Letterbox(false, 2)
end

---- Intro Squads -----
_moveIntroTruck1 = function ()
	Util_CreateSquads(player2, sg_intro, SBP.SOVIET.T_70M, mkr_introTruck1Spawn, mkr_introTruck1Dest)
	Util_CreateSquads(player2, sg_intro2, SBP.SOVIET.ZIS_6_TRANSPORT_TRUCK, mkr_introTruck1Spawn2, mkr_introTruck1Dest)
	SGroup_SetAnimatorState(sg_intro2, "supplies_loaded", "full")
	Modify_UnitSpeed(sg_intro, 0.6)
	Modify_UnitSpeed(sg_intro2, 0.6)
end

_moveIntroTruck2 = function ()
	Util_CreateSquads(player2, sg_intro, SBP.SOVIET.T_70M, mkr_introTruck2Spawn, mkr_introTruck2Dest)
	Util_CreateSquads(player2, sg_intro2, SBP.SOVIET.ZIS_6_TRANSPORT_TRUCK, mkr_introTruck2Spawn2, mkr_introTruck2Dest)
	SGroup_SetAnimatorState(sg_intro2, "supplies_loaded", "full")
	Modify_UnitSpeed(sg_intro, 0.6)
	Modify_UnitSpeed(sg_intro2, 0.6)
end

_removeIntroTrucks = function ()
	if g_difficulty == GD_HARD then
		FOW_UnRevealAll()
	end
	Rule_RemoveIfExist(_moveIntroTruck2)
	local player2Squads = Player_GetSquads(player2)
	SGroup_DestroyAllSquads(player2Squads)
	SGroup_Destroy(sg_intro)
	SGroup_Destroy(sg_intro2)
end

EVENTS.OBJDestroySecondGroup = function()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051265) -- LOCDB [11051265] 'A second convoy is approaching, including a Soviet T-34 tank.' - 'German_Officer'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051266) -- LOCDB [11051266] 'Eliminate that tank and the supply trucks.' - 'German_Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051866) -- LOCDB [11051866] 'Use mines or sink the tank in the river if you must.' - 'German Officer'
	CTRL.WAIT()
end


EVENTS.OBJDestroyThirdGroup = function()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051267) -- LOCDB [11051267] 'A final convoy is on its way. We have identified several KV heavy tanks in this group.' - 'German_Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051268) -- LOCDB [11051268] 'You must destroy those heavy tanks and the supply trucks they are guarding.' - 'German_Officer'
	CTRL.WAIT()
end

EVENTS.Reinforcements = function()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051581) -- LOCDB [11051581] 'Use these reinforcements well; the Kampfgruppe can spare no more.' - 'German_Officer'
	CTRL.WAIT()
end

EVENTS.Barricades = function()
	if g_difficulty ~= GD_HARD and EGroup_Count(eg_allBarricades) == 4 then
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051867) -- LOCDB [11051867] 'Your Pioneers can erect makeshift barricades to divert the convoy and slow its progress.' - 'German Officer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051868) -- LOCDB [11051868] 'When the enemy spots a barricade, the convoy will be forced to re-route.' - 'German Officer'
		CTRL.WAIT()
	end
end

EVENTS.Fail= function()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051269) -- LOCDB [11051269] 'It appears the Soviets have eluded you, commander...' - 'German_Officer'
	CTRL.WAIT()
end

EVENTS.Success= function()	
	Game_Letterbox(true, 2)
	CTRL.Scar_PlayNIS( NIS_OUTRO )
	CTRL.SUB()	
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051270) -- LOCDB [11051270] 'Throughout November of 1942, the Wehrmacht cut more and more Soviet supply lines.' - 'German_Officer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051271) -- LOCDB [11051271] 'The Soviet defenders would be reduced to holding a mere 10% of Stalingrad, but despite it all, the city refused to fall.' - 'German_Officer'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	
end

EVENTS.PathBlocked = {}

EVENTS.PathBlocked[1] = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051660) -- LOCDB [11051660] 'The convoy has spotted a barricade and is diverting to an alternate path.' - 'German_Officer'
	CTRL.WAIT()
end

EVENTS.PathBlocked[2] = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051661) -- LOCDB [11051661] 'Another barricade spotted. The convoy is changing course.' - 'German_Officer'
	CTRL.WAIT()
end

EVENTS.PathBlocked[3] = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051662) -- LOCDB [11051662] 'The convoy is turning back from a barricade.' - 'German_Officer'
	CTRL.WAIT()
end

EVENTS.PathBlocked[4] = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051663) -- LOCDB [11051663] 'Our barricade has diverted the convoy.' - 'German_Officer'
	CTRL.WAIT()
end

EVENTS.Abandoned = {}

EVENTS.Abandoned[1] = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11052250) -- LOCDB [11052250] 'The Soviets have abandoned a crippled vehicle.' - 'German_Officer'
	CTRL.WAIT()
end

EVENTS.Abandoned[2] = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11052251) -- LOCDB [11052251] 'Another enemy vehicle lies abandoned.' - 'German_Officer'
	CTRL.WAIT()
end

EVENTS.Abandoned[3] = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11052252) -- LOCDB [11052252] 'More Soviet armor has been abandoned.' - 'German_Officer'
	CTRL.WAIT()
end

----
EVENTS.OBJDestroyConvoyFirstGroup = function()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, LOC("The first of the convoy vehicles are upon you!")) 
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, LOC("Use ambush tactics to prevent as much of the convoy as possible from reaching its goal.")) 
	CTRL.WAIT()
end
