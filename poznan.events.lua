
EVENTS = {}


-- Commander names:
-- P1 - Player			General Chuikov (8th Guards Army)			ACTOR.Poznan_Officer_01
-- P2 - Enemy			Generalmajor Mattern						ACTOR.German_Officer
-- P3 - Ally			Colonel-General Kolpakchi (69th Army)		ACTOR.None (so he appears as a radio icon)


EVENTS.Poznan_Intro = function() -- played between the opening movie and the sitrep
	
	Game_FadeToBlack(FADE_IN, 1)
	FOW_EnableTint(false)
	Game_SetMode(UI_Cinematic)
	Camera_SetInputEnabled(false)
	
	Util_CreateSquads(player2, sg_nis_guys, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_nisstart_guys_spawn, mkr_nisstart_guys_dest, 1, 4)
	Util_CreateSquads(player2, sg_nis_guys, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_walldefender02)
	Util_CreateSquads(player2, sg_nis_guys, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, mkr_walldefender03)
	Util_CreateSquads(player2, sg_nis_guys, SBP.GERMAN.PANZER_GRENADIER_SQUAD, eg_leftWallBridge_tower1)
	Util_CreateSquads(player2, sg_nis_guys, SBP.GERMAN.PANZER_GRENADIER_SQUAD, eg_leftWallBridge_tower2)
	Util_ApplyModifier(sg_nis_guys, "posture_speed_modifier", -1, MUT_Addition) 
	FOW_RevealSGroupOnly(sg_nis_guys, -1)

	local timeline = 11046688			-- LOCDB [11046688] 'February 1945'
	local location = 11046687			-- LOCDB [11046687] 'Poznan, Poland'
	
	CTRL.Scar_PlayNIS(NIS_Start)
	CTRL.SUB()
		CTRL.Event_Delay(1)
		CTRL.WAIT()
		Game_SubTextFade(timeline, location, 0.5, 4, 0.5)
		CTRL.Event_Delay(1)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeechWithoutPortrait(ACTOR.Russian_Soldier_04, 11038036)		-- LOCDB [11038036] 'Sir, we are in position outside the walls of Poznan.' - 'Soldier'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	
	
	Game_FadeToBlack(FADE_OUT, 0)
	Game_SetMode(UI_Normal)
	Camera_SetInputEnabled(true)
	FOW_EnableTint(true)
	
	SGroup_DestroyAllSquads(sg_nis_guys)
	
end



--------------------------------------------------------------------------------
-- Banter between P1 and P3
--------------------------------------------------------------------------------

-- played when the player is introduced to the competing team who is also trying to cpature Poznan
EVENTS.Poznan_MeetTheAlly = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038037)						-- LOCDB [11038037] 'General Chuikov, this is Colonel-General Kolpakchi of the 69th Army.' - 'Poznan Officer 2'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038038)						-- LOCDB [11038038] 'We want the honour of capturing Poznan. We can take this city - why don't you rest up for Berlin?' - 'Poznan Officer 2'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11046744)		-- LOCDB [11046744] 'I don't think so, Colonel-General.' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038040)		-- LOCDB [11038040] 'We will not be content to just sit back and provide support to you here.' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038041)						-- LOCDB [11038041] 'Then we attack from two fronts. Inform your men that we are attacking from the east, and watch your fire.' - 'Poznan Officer 2'
	CTRL.WAIT()
end

-- played when the competing team is called off
EVENTS.Poznan_AllyWithdraws = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038042)						-- LOCDB [11038042] '69th army! New orders! Withdraw from battle at once!' - 'Poznan Officer 2'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038043)						-- LOCDB [11038043] 'General Chuikov, I have been instructed to leave this in your hands. Good luck.' - 'Poznan Officer 2'
	CTRL.WAIT()
end



--------------------------------------------------------------------------------
-- Time pressure warnings
--------------------------------------------------------------------------------

-- after the ally has withdrawn, you get messages and timers relating to the end of YOUR battle support
EVENTS.Poznan_PatienceHint = function()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038044)		-- LOCDB [11038044] 'Comrades!  We are progressing too slowly! We must push harder to capture Poznan, and soon.' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038045)		-- LOCDB [11038045] 'We will not be given infinite resources to accomplish this. Resources are required elsewhere!' - 'Poznan Officer 1'
	CTRL.WAIT()
end

-- some undefined time after the ally's withdrawl, the timer starts. 
EVENTS.Poznan_StartPatienceTimer = function()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038046)		-- LOCDB [11038046] 'Soviet Command has given us an ultimatum. Accomplish the mission by the following deadline or face losing supplies, men and equipment.' - 'Poznan Officer 1'
	CTRL.WAIT()
end
EVENTS.Poznan_PatienceTimerRunningLow = function()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038047)		-- LOCDB [11038047] 'Soviet Command patience is wearing thin, comrades!' - 'Poznan Officer 1'
	CTRL.WAIT()
end
EVENTS.Poznan_EndPatienceTimer = function()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038048)		-- LOCDB [11038048] 'We have just received word from Soviet Command. We get no more supplies. No more units. No more support.' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038049)		-- LOCDB [11038049] 'We fight, or we die.' - 'Poznan Officer 1'
	CTRL.WAIT()
end





--------------------------------------------------------------------------------
-- Objective 1 - Breach the walls
--------------------------------------------------------------------------------
EVENTS.Obj1_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038050)		-- LOCDB [11038050] 'Our first task is to breach these outer walls and capture some territory inside Poznan.' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038051)		-- LOCDB [11038051] 'Expect heavy defences from the Poznan wall, and watch out for attacks from the redoubts on your flanks.' - 'Poznan Officer 1'
	CTRL.WAIT()
end


EVENTS.Obj1_BridgeOut = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038052)		-- LOCDB [11038052] 'The bridge is out!' - 'Soldier'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038053)		-- LOCDB [11038053] 'We must find another way through!' - 'Poznan Officer 1'
	CTRL.WAIT()
end

EVENTS.Obj1_CallOutHowitzer1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11046573)		-- LOCDB [11046573] 'Watch out for those howitzers. They're killing us!' - 'Poznan Officer 1'
	CTRL.WAIT()
end
EVENTS.Obj1_CallOutHowitzer2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11046574)		-- LOCDB [11046574] 'Active enemy howitzers are located in the redoubts.' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11046575)		-- LOCDB [11046575] 'Take them out with mortar fire or a barrage from our SU-76 guns.' - 'Poznan Officer 1'
	CTRL.WAIT()
end


EVENTS.Obj1_HintAtCrushingWalls = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038054)		-- LOCDB [11038054] 'Sir, some of the forward troops have spotted some places where the wall looks to be in bad condition.' - 'Soldier'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038055)		-- LOCDB [11038055] 'We may be able to break the wall down with some mortar fire.' - 'Soldier'
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11046940)		-- LOCDB [11046940] 'Sir, forward troops have marked weak and damaged sections of the fortress wall.' - 'Soviet_Soldier_04'
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11046942)		-- LOCDB [11046942] 'A mortar barrage may be enough to breach weakened parts of the wall.' - 'Soviet_Soldier_04'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038056)		-- LOCDB [11038056] 'Bring in the ISU-152 from reserves; something that heavy may be able to topple the wall and roll through.' - 'Poznan Officer 1'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038057)		-- LOCDB [11038057] 'Either way is easier than trying to get that bridge repaired under all that incoming fire.' - 'Poznan Officer 1'
--~ 	CTRL.WAIT()
end


EVENTS.Obj1_ThroughWallP1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038058)		-- LOCDB [11038058] 'Sir, we have breached the wall.' - 'Soldier'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038059)		-- LOCDB [11038059] 'Good work. Now take out their defences from behind and capture some territory. We need a beachhead.' - 'Poznan Officer 1'
	CTRL.WAIT()
end
EVENTS.Obj1_ThroughWallP3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038060)						-- LOCDB [11038060] 'We're through the wall over on this side. You really should hurry up.' - 'Poznan Officer 2'
	CTRL.WAIT()
end


EVENTS.Obj1_PointCapturedP1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038061)		-- LOCDB [11038061] 'We have secured some territory inside Poznan's walls.' - 'Poznan Officer 1'
	CTRL.WAIT()
end
EVENTS.Obj1_PointCapturedP3 = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.None, 11038062)						-- LOCDB [11038062] 'Comrades, we have cracked the nut! Their defences have fallen, and we have breached the walls of Poznan!' - 'Poznan Officer 2'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11049485)						-- LOCDB [11049485] 'Comrades, we have cracked the nut! Their defences have fallen, and we have secured some territory inside Poznan's walls!' - 'Poznan Officer 2'
	CTRL.WAIT()
end








--------------------------------------------------------------------------------
-- Objective 2 - Capture the city squares
--------------------------------------------------------------------------------


EVENTS.Obj2_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038063)		-- LOCDB [11038063] 'Let's press on into the city.' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038064)		-- LOCDB [11038064] 'Keep your wits about you, men.  We could get ambushed anywhere.' - 'Poznan Officer 1'
	CTRL.WAIT()
end


EVENTS.Obj2_MortarChatter = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11046577)		-- LOCDB [11046577] 'There's another Howitzer somewhere in this city, and it's shelling the hell out of us!' - 'Soldier'
	CTRL.WAIT()
	UI_CreateMinimapBlip(eg_hq3, 4, BT_General)
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11046578)		-- LOCDB [11046578] 'It sounds like it's coming from the Citadel to the north.' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11046579)		-- LOCDB [11046579] 'Keep your focus on capturing the two outposts, men. We will get to the Citadel later.' - 'Poznan Officer 1'
	CTRL.WAIT()
end

EVENTS.Obj2_AtWestSquareP1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038065)		-- LOCDB [11038065] 'We're at the west square.' - 'Poznan Officer 1'
	CTRL.WAIT()
end
EVENTS.Obj2_AtWestSquareP3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038066)						-- LOCDB [11038066] 'We are approaching the outpost over here.' - 'Poznan Officer 2'
	CTRL.WAIT()
end



EVENTS.Obj2_AtEastSquareP1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038067)		-- LOCDB [11038067] 'We're at the market square.' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038068)		-- LOCDB [11038068] 'Good. Move in and capture the city hall.' - 'Poznan Officer 1'
	CTRL.WAIT()
end
EVENTS.Obj2_AtEastSquareP3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038069)						-- LOCDB [11038069] 'General Chuikov, we are approaching the city hall over here on the east flank.' - 'Poznan Officer 2'
	CTRL.WAIT()
end


-- the squares here can refer to either square. 
-- these are for the first square captured
EVENTS.Obj2_SquareCapturedP1 = function()
	
	Game_FadeToBlack(FADE_OUT, 0.8)
	
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	
	saved_camera_pos = Camera_GetCurrentTargetPos()
	Game_SetMode(UI_Cinematic)
	Camera_SetInputEnabled(false)
	Game_FadeToBlack(FADE_IN, 0.8)
	
	CTRL.Scar_PlayNIS(obj2_firstsquare_nis)
	CTRL.SUB()
		CTRL.Event_Delay(1.5)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038070)		-- LOCDB [11038070] 'We have the square, sir.' - 'Poznan Officer 1'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038071)		-- LOCDB [11038071] 'Good work, now start rallying the troops to take on the second square.' - 'Poznan Officer 1'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	
	Game_SetMode(UI_Normal)
	Camera_SetInputEnabled(true)
	Camera_MoveTo(saved_camera_pos)
	Camera_ResetToDefault()
	
	Game_FadeToBlack(FADE_IN, 0.8)
	
end
EVENTS.Obj2_SquareCapturedP3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038072)							-- LOCDB [11038072] 'General Chuikov, we have secured the first square. Hurry up over there.' - 'Poznan Officer 2'
	CTRL.WAIT()
end


-- these are for the second square captured (suffixes designate who captured the first square and who captured the second)
EVENTS.Obj2_SquareCapturedP1P1 = function()

	Game_FadeToBlack(FADE_OUT, 0.8)
	
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	
	saved_camera_pos = Camera_GetCurrentTargetPos()
	Game_SetMode(UI_Cinematic)
	Camera_SetInputEnabled(false)
	Game_FadeToBlack(FADE_IN, 0.8)
	
	Scar_CompleteIntelBulletinTask(player1, "camp12_poznan_player_captured_both_squares")
	
	CTRL.Scar_PlayNIS(obj2_secondsquare_nis)
	CTRL.SUB()
		CTRL.Event_Delay(1.5)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038073)		-- LOCDB [11038073] 'Both squares have been secured, sir.' - 'Soldier'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038074)		-- LOCDB [11038074] 'Excellent work.' - 'Poznan Officer 1'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()

	Game_SetMode(UI_Normal)
	Camera_SetInputEnabled(true)
	Camera_MoveTo(saved_camera_pos)
	Camera_ResetToDefault()
	
	Game_FadeToBlack(FADE_IN, 0.8)
	
end
EVENTS.Obj2_SquareCapturedP3P1 = function()

	Game_FadeToBlack(FADE_OUT, 0.8)
	
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	
	saved_camera_pos = Camera_GetCurrentTargetPos()
	Game_SetMode(UI_Cinematic)
	Camera_SetInputEnabled(false)
	Game_FadeToBlack(FADE_IN, 0.8)
	
	CTRL.Scar_PlayNIS(obj2_secondsquare_nis)
	CTRL.SUB()
		CTRL.Event_Delay(1.5)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038075)		-- LOCDB [11038075] 'We have secured the second square, sir.' - 'Soldier'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038076)		-- LOCDB [11038076] 'That's both of them secure, then. Good work.' - 'Poznan Officer 1'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()

	Game_SetMode(UI_Normal)
	Camera_SetInputEnabled(true)
	Camera_MoveTo(saved_camera_pos)
	Camera_ResetToDefault()
	
	Game_FadeToBlack(FADE_IN, 0.8)
	
end
EVENTS.Obj2_SquareCapturedP1P3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038077)							-- LOCDB [11038077] 'General Chuikov, we have the second square and are moving on towards the fortress.' - 'Poznan Officer 2'
	CTRL.WAIT()
end
EVENTS.Obj2_SquareCapturedP3P3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038078)							-- LOCDB [11038078] 'General Chuikov, we have secured both squares. If you ever feel like joining in, let us know.' - 'Poznan Officer 2'
	CTRL.WAIT()
end





--------------------------------------------------------------------------------
-- Objective Bonus - Rescue the Penal Battalion
--------------------------------------------------------------------------------

-- plays when the bonus objective is announced, part way into Obj2 (as this relates to the two places you have to capture/destroy for Obj2 anyway)
EVENTS.ObjBonus_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038079)		-- LOCDB [11038079] 'Sir! It's possible that one of these command buildings we're targetting is where they're holding a number of prisoners of war.' - 'Soldier'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038080)		-- LOCDB [11038080] 'How many men are we talking about?' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038081)		-- LOCDB [11038081] 'We're not entirely sure, sir, but reports suggest it could be twenty or thirty soldiers.' - 'Soldier'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038082)		-- LOCDB [11038082] 'Troops! Your orders are now to CAPTURE those buildings!  If you can, get inside and look for our comrades.' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038083)		-- LOCDB [11038083] 'Colonel-General Kolpakchi, did you hear that? We may have POWs in one of those command buildings.  So capture them DON'T destroy them.' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038084)						-- LOCDB [11038084] 'We heard, General Chuikov.' - 'Poznan Officer 2'
	CTRL.WAIT()
end

-- this plays if it's the player that rescues the penal batallion from one of the Obj2 locations
EVENTS.ObjBonus_WinP1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038085)		-- LOCDB [11038085] 'Sir! We have found our comrades!' - 'Soldier'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038086)		-- LOCDB [11038086] 'Then equip them and get them ready to fight.' - 'Poznan Officer 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038087)		-- LOCDB [11038087] 'They have sat on the sidelines too long - now it is their time to honour their country.' - 'Poznan Officer 1'
	CTRL.WAIT()
	
	Scar_CompleteIntelBulletinTask(player1, "camp12_poznan_bonus_rescued_penal_battalions")
	
end

-- this plays if it's the AI player that gets there first, and he rescues the penal batallion instead
EVENTS.ObjBonus_WinP3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038088)						-- LOCDB [11038088] 'General Chuikov, we have searched the command building and have found our incarcerated comrades!' - 'Poznan Officer 2'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11038089)						-- LOCDB [11038089] 'They are under my command now, and will help us with our fight.' - 'Poznan Officer 2'
	CTRL.WAIT()
end

-- if both of the potential locations which could have held the penal batallion are destroyed (so no-one gets the penal batallion), this plays
EVENTS.ObjBonus_BuildingsDestroyed = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038090)		-- LOCDB [11038090] 'Sir, both of the enemy command buildings were destroyed before we could search them. Our comrades are almost certainly dead.' - 'Soldier'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038091)		-- LOCDB [11038091] 'Then we must honour their sacrifice by doubling our efforts against the remaining Germans. Punish those that held them!' - 'Poznan Officer 1'
	CTRL.WAIT()
end





--------------------------------------------------------------------------------
-- Objective 3 - Capture the fortress
--------------------------------------------------------------------------------

EVENTS.Obj3_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038092)		-- LOCDB [11038092] 'Now it's time to take on our final objective; the Citadel to the north. That is where all of the remaining German forces will be. One more push, brothers.' - 'Poznan Officer 1'
	CTRL.WAIT()
end

EVENTS.Obj3_InCourtyard = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11038093)		-- LOCDB [11038093] 'We're into the courtyard!' - 'Soldier'
	CTRL.WAIT()
end




--------------------------------------------------------------------------------
-- Mission Complete
--------------------------------------------------------------------------------

-- Germans surrender
EVENTS.Mission_CompleteA = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11038094)			-- LOCDB [11038094] 'This is Generalmajor Mattern. We surrender.' - 'German Officer'
	CTRL.WAIT()
end
EVENTS.Mission_CompleteB = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11049486)						-- LOCDB [11049486] 'Soviet command wants me to pass on their congratulations.' - 'Poznan Officer 2'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11049487)						-- LOCDB [11049487] 'They were ready to pull you out of Poznan, but you proved that it was possible to get the job done.' - 'Poznan Officer 2'
	CTRL.WAIT()
end
EVENTS.Mission_CompleteC = function()
	
	Game_FadeToBlack(FADE_IN, 1)
	Game_SetMode(UI_Cinematic)
	Camera_SetInputEnabled(false)
	
	CTRL.Scar_PlayNIS(NIS_Finish)
	CTRL.SUB()
		CTRL.Event_Delay(2)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Poznan_Officer_01, 11038095)		-- LOCDB [11038095] 'We have the fortress. Poznan is ours.' - 'Poznan Officer 1'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	
end









