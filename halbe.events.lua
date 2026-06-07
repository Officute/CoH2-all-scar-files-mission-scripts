function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("mission/m13")
	g_MissionSpeechPath = "mission/m13"
end
Scar_AddInit(Init_Audio)

EVENTS = {} --Container

-------------------------------------
-- NIS
-------------------------------------
--Intro
EVENTS.NIS_Intro = function()
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 0)
	
	CTRL.Event_Delay(1.0)
	CTRL.WAIT()
	
	CTRL.SitRep_PlayMovie("m13_cin01")
	CTRL.WAIT()
	
	Game_FadeToBlack(FADE_IN, 2.5)
	CTRL.WAIT()
end

--Opening sequence
EVENTS.Intro_Opening = function()
	CTRL.Event_Delay(1.0)
	CTRL.WAIT()
	Game_SubTextFade(11046888, 11046887, 0.5, 4, 0.5) -- LOCDB [11046888] 'April, 1945'  -- LOCDB [11046887] 'Halbe, Germany'
	CTRL.Event_Delay(2.0)
	CTRL.WAIT()
	
	Camera_ResetToDefault()
	Camera_SetSlideTargetRate(0.2)
	
	CTRL.Event_Delay(2.0)
	CTRL.WAIT()
	
	SpawnIntroUnits()
	
	CTRL.Event_Delay(1.0)
	CTRL.WAIT()
	
	TriggerReconPlane()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11038618) -- LOCDB [11038618] 'Hold on, men. Friendly reconnaissance plane is inbound.' - 'Junior_Officer'
	CTRL.WAIT()
	
	CTRL.Event_Delay(1.5)
	CTRL.WAIT()
	
	Camera_MoveTo(World_Pos(9.3457, 9.0316, -128.387), true, 0.085)
	CTRL.Event_Delay(6.0)
	CTRL.WAIT()
	CTRL.Game_FadeToBlack(FADE_OUT, 1.5)
	CTRL.WAIT()
end

--End
EVENTS.NIS_Outro = function()
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 3.0)
	
	CTRL.Event_Delay(2.0)
	CTRL.WAIT()
	CTRL.SitRep_PlayMovie("m13_cin04")
	CTRL.WAIT()
end


 -- LOCDB CREATE  MISSION "M13" CHARACTER ""
-------------------------------------
--[[OBJECTIVE 1 - Secure the bridgehead]]
-------------------------------------
EVENTS.Secure_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038619) -- LOCDB [11038619] 'The Germans have a strong defensive position ahead.' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038620) -- LOCDB [11038620] 'You must secure that territory before our forces can keep pushing forward.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Secure_IntroAT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038621) -- LOCDB [11038621] 'Those Anti-Tank guns will tear apart our tanks.' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038622) -- LOCDB [11038622] 'Take them out and I'll be able to provide armored reinforcements.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Secure_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038623) -- LOCDB [11038623] 'Excellent work, Comrades. The road is now under our control.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Secure_ATDestroyed = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11038624) -- LOCDB [11038624] 'Sir, we've taken out their Anti-Tank support!' - 'Junior_Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038625) -- LOCDB [11038625] 'Well done, Comrade. Armor support has been dispatched to your location.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Secure_Reinforcements = function()
	local t_lines = {
		11038626, -- LOCDB [11038626] 'Additional support is on the way. Keep pushing forward!' - 'Commissar'
		11038627, -- LOCDB [11038627] 'The might of the Red Army is behind you! We will not let them push us back!' - 'Commissar'
		11038628, -- LOCDB [11038628] 'Reinforcements have been dispatched! Give them hell!' - 'Commissar'
	}
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, t_lines[World_GetRand(1, #t_lines)])
	CTRL.WAIT()
end



--[[Tank battle]]
EVENTS.Tanks_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11049564) -- LOCDB [11049564] 'Panther tank! Take cover!' - 'soviet_soldier_01'
	CTRL.WAIT()
	CTRL.Event_Delay(0.75)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038630) -- LOCDB [11038630] 'We have come to far to be pushed back. Heavy tank support is on its way!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Tanks_RemindAT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11038631) -- LOCDB [11038631] 'We need to take out those fucking AT guns!' - 'Soldier_02'
	CTRL.WAIT()
end




-------------------------------------
--[[OBJECTIVE 2 - Encircle Halbe]]
-------------------------------------
EVENTS.Encircle_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038632) -- LOCDB [11038632] 'We have strict orders from Marshal Konev to avoid strongholds and continue our advance towards Berlin.' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038633) -- LOCDB [11038633] 'Divide your forces into two separate flanks and encircle the town.' - 'Commissar'
	CTRL.WAIT()
	CTRL.Event_Delay(0.5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038634) -- LOCDB [11038634] 'Remember, we must control BOTH exits to the town if we are to stop the cowards from escaping.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Encircle_WarnAwareness = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038635) -- LOCDB [11038635] 'It's only a matter of time before the Germans discover our plan.' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038636) -- LOCDB [11038636] 'Use all resources at your disposal and secure those exits at once!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Encircle_WarnManeuver = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Commander, 11038637) -- LOCDB [11038637] 'We don't have much room to maneuver in these woods. Keep an eye out for Panzerschrecks!' - 'Tank_Commander'
	CTRL.WAIT()
end

EVENTS.Encircle_AvoidTown = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049561) -- LOCDB [11049561] 'The Fascists are well-entrenched within the town, stay clear of it!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Encircle_SecuredExit = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11046565) -- LOCDB [11046565] 'We have secured one of the exits, Comrade Colonel.' - 'Soldier_02'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11049563) -- LOCDB [11049563] 'Good. Keep an eye out for any Germans trying to flee the town, and secure the other exit.' - 'Commissar'
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046566) -- LOCDB [11046566] 'Good. Keep an eye out for any Germans trying to flee the town, and secure the other exit at once.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Encircle_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038638) -- LOCDB [11038638] 'Well done Comrade. The German rats have nowhere to run now.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Encircle_GermansAware = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038639) -- LOCDB [11038639] 'Comrade! You cannot waste any time!' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038640) -- LOCDB [11038640] 'The Germans are now aware of our plans to encircle the town.' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038641) -- LOCDB [11038641] 'Expect heavy enemy resistance.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.InformPanzerNorth = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11038642) -- LOCDB [11038642] 'They are sending reinforcements from the town!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.InformMortarHT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11038643) -- LOCDB [11038643] 'Mortar half-track! Take it out!' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.InformTreeline = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11038644) -- LOCDB [11038644] 'Germans in the treeline!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.InformHill = function()
	--Removed 2012-11-15
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11038645) -- LOCDB [11038645] 'Take out that hill!' - 'Soldier_02'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11046545) -- LOCDB [11046545] 'Lay some smoke cover and take out that fucking hill!' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.InformValley = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11038646) -- LOCDB [11038646] 'Ambush!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.Partisans1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11038647) -- LOCDB [11038647] 'I don't think these are all civilians...' - 'Soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038648) -- LOCDB [11038648] 'When in doubt- shoot!' - 'Commissar'
	CTRL.WAIT()
end





-------------------------------------
--[[OBJECTIVE 3 - Stop escaping germans]]
-------------------------------------
EVENTS.Breakout_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038649) -- LOCDB [11038649] 'We have reports that the German Ninth Army is trying to retreat to the West.' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038650) -- LOCDB [11038650] 'We must not let them escape. Hold the road and railway and prevent any Germans from getting through.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Breakout_Awareness = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038651) -- LOCDB [11038651] 'The Germans are well aware of the encirclement. Expect them to fight hard to break out.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Breakout_NoAwareness = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038652) -- LOCDB [11038652] 'The Germans are not yet aware of the encirclement. We will catch them off-guard when they try to evacuate.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Breakout_Inform1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11038653) -- LOCDB [11038653] 'Here they come!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.Breakout_Railway = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11038654) -- LOCDB [11038654] 'Sir, we have movement by the railway!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.Civilians2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11038655) -- LOCDB [11038655] 'I can't tell if they are soldiers... Should we let them go?' - 'Soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038656) -- LOCDB [11038656] 'I told you to shoot, dammit! Shoot them before they shoot us!' - 'Commissar'
	CTRL.WAIT()
end



--~ EVENTS.Breakout_Attempt2 = function() --TODO: remove?
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038657) -- LOCDB [11038657] 'They won't give up that easily. Keep an eye on any other exits to the town.' - 'Commissar'
--~ 	CTRL.WAIT()
--~ end

EVENTS.Breakout_Attempt3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038658) -- LOCDB [11038658] 'Stand ready Comrades! The fascists are not done yet!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Breakout_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038659) -- LOCDB [11038659] 'It seems the Germans have given up for now.' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11038660) -- LOCDB [11038660] 'Shall we proceed into the town, Comrade Commissar?' - 'Soldier_1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049562) -- LOCDB [11049562] 'There is no need for that. Our rear forces will... deal with them.' - 'Commissar'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038661) -- LOCDB [11038661] 'There is no need for that. They have nowhere to go. We will deal with them later.' - 'Commissar'
end

EVENTS.Breakout_Halfway = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038662) -- LOCDB [11038662] 'We cannot afford to have the Germans flee to the West. Do not let them escape!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Breakout_Fail = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11038663) -- LOCDB [11038663] 'German forces have escaped our encirclement. The Red Army will not tolerate this failure!' - 'Commissar'
	CTRL.WAIT()
end

