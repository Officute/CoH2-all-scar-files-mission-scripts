----------------------------------------------------------------------------------------------------------------
-- Actor / NIS helper functions
-- (c) 2005 Relic Entertainment Inc.

--? @group scardoc;Presentation

--? @shortdesc Tie a single squad to an actor, so audio comes from a squad member
--? @result Void
--? @args ActorTable actor, SquadID squad
function Actor_SetFromSquad(actor, squadid)
	SGroup_Add(actor.group, squadid)
end


--? @shortdesc Tie an entire sgroup to an actor, so audio comes from a squad member
--? @result Void
--? @args ActorTable actor, SGroupID sgroup
function Actor_SetFromSGroup(actor, sgroupid)
	SGroup_AddGroup(actor.group, sgroupid)
end


--? @shortdesc Clear ties between an actor and any units
--? @result Void
--? @args ActorTable actor
function Actor_Clear(actor)
	SGroup_Clear(actor.group)
end


function Actor_PlaySpeechInternal(portrait, icon, nameID, locID, continueButton, stickySubtitle, blockInput)

	if continueButton == nil then continueButton = false end
	if stickySubtitle == nil then stickySubtitle = false end
	if blockInput == nil then blockInput = false end

	-- single place to check SP mission path...
	local path = ""
	
	-- supporting old code from COH
	if g_MissionSpeechPath ~= nil then
		path = g_MissionSpeechPath
	end
	
	-- play speech
	Subtitle_PlaySpeech(icon, nameID, locID, not portrait, continueButton, blockInput, stickySubtitle, path)

end


--? @shortdesc Plays a speech event for a given actor WITH a portrait and subtitle
--? @result Void
--? @args ActorTable actor, Integer locID[, Boolean continueButton, Boolean stickySubtitle, Boolean blockInput]
--? @extdesc Be VERY careful how you use the 'blockInput' parameter. It blocks all input except mouse movement, a few critical keyboard keys, and the Continue and Menu buttons. So you should always allow a continue button when blocking input. You shouldn't block input for a sticky subtitle!
--? If the speech file is not available, a placeholder time will be calculated for the message using the number of words and the message will be displayed for that length of time.\n
--? Actors: ACTOR.GenericAlly, ACTOR.GenericAxis, ACTOR.Keller, ACTOR.McKay, ACTOR.Conti, ACTOR.Franks, ACTOR.Peoples, ACTOR.Coogi, etc...
function Actor_PlaySpeech(actor, locID, continueButton, stickySubtitle, blockInput)
	if scartype(locID) == ST_NUMBER then 
		print("INTEL: "..locID)
	end
	
	local icon = ""
	if type(actor) == "string" then
		icon = actor
	elseif type(actor) == "table" and actor.icon ~= nil then
		icon = actor.icon
	end
	
	local nameID = 0;
	if type(actor) == "table" and actor.nameID ~= nil then
		nameID = actor.nameID
	end
	
	--Deal with summer vs. winter protraits.
	if(World_IsWinterMap()) then
		actor = string.gsub(actor, "_s_", "_w_")
	end
	
	Actor_PlaySpeechInternal(true, icon, nameID, locID, continueButton, stickySubtitle, blockInput)
end


--? @shortdesc Plays a speech event for a given actor WITHOUT a portrait or subtitle. See Actor_PlaySpeech for more details
--? @result Void
--? @args ActorTable actor, Integer locID[, Boolean continueButton, Boolean stickySubtitle, Boolean blockInput]
function Actor_PlaySpeechWithoutPortrait(actor, locID, continueButton, stickySubtitle, blockInput)
	if scartype(locID) == ST_NUMBER then 
		print("AMBIENT: "..locID)
	end
	
	local icon = ""
	if type(actor) == "string" then
		icon = actor
	elseif type(actor) == "table" and actor.icon ~= nil then
		icon = actor.icon
	end
	
	local nameID = 0;
	if type(actor) == "table" and actor.nameID ~= nil then
		nameID = actor.nameID
	end
	
	Actor_PlaySpeechInternal(false, icon, nameID, locID, continueButton, stickySubtitle, blockInput)
end

ACTOR = {
	
	__scardoc_enum = true,

	None					= "",

	-- Generic Russians
	Russian_Commissar		= "Icons_portraits_dialogue_soviet_commissar_s_portrait",
	Russian_Junior_Officer	= "Icons_portraits_dialogue_soviet_poznan_officer_01_w_portrait", -- Poznan_01 looks junior. No unique art for "junior officer".
	Russian_Senior_Officer	= "Icons_portraits_dialogue_soviet_senior_officer_s_portrait",
	Russian_Radio_Command	= "Icons_portraits_dialogue_soviet_command_radio_s_portrait",
	
	Russian_Soldier_01		= "Icons_portraits_dialogue_soviet_soldier_01_s_portrait",
	Russian_Soldier_02		= "Icons_portraits_dialogue_soviet_soldier_02_s_portrait",
	Russian_Soldier_03		= "Icons_portraits_dialogue_soviet_soldier_03_s_portrait",
	Russian_Soldier_04		= "Icons_portraits_dialogue_soviet_soldier_04_s_portrait",
	Russian_Soldier_05		= "Icons_portraits_dialogue_soviet_soldier_05_s_portrait",
	Russian_Soldier_06		= "Icons_portraits_dialogue_soviet_soldier_06_s_portrait",
	Russian_Soldier_07		= "Icons_portraits_dialogue_soviet_soldier_07_s_portrait",
	
	Russian_Sniper			= "Icons_portraits_dialogue_soviet_sniper_s_portrait",
	
	Russian_Engineer		= "Icons_portraits_dialogue_soviet_engineer_s_portrait",
	
	Russian_Tank_Commander	= "Icons_portraits_dialogue_soviet_tank_commander_s_portrait",
	Russian_Tank_Gunner		= "Icons_portraits_dialogue_soviet_tank_gunner_s_portrait",
	Russian_Tank_Officer	= "Icons_portraits_dialogue_soviet_tank_officer_s_portrait",
	
	Civilian				= "Icons_portraits_dialogue_civilian_s_portrait",
	Civilian_Female			= "Icons_portraits_dialogue_civilian_female_s_portrait",
	
	Partisans				= "Icons_portraits_dialogue_partisan_male_s_portrait",
	Partisans_Female 		= "Icons_portraits_dialogue_partisan_female_s_portrait",
	
	-- CoH2 Campaign
	Ania					= "Icons_portraits_dialogue_ania_s_portrait",
	Churkin					= "Icons_portraits_dialogue_churkin_s_portrait",
	Isakovich				= "Icons_portraits_dialogue_isakovich_s_portrait",
	Polivanov				= "Icons_portraits_dialogue_major_polivanov_s_portrait",
	Pozharsky				= "Icons_portraits_dialogue_pozharski_s_portrait",
	Yuri					= "Icons_portraits_dialogue_yuri_s_portrait",
	
	Poznan_Officer_01		= "Icons_portraits_dialogue_soviet_poznan_officer_01_w_portrait",
	Poznan_Officer_02		= "Icons_portraits_dialogue_soviet_poznan_officer_02_w_portrait",
	
	-- Generic Germans
	German_Officer			= "Icons_portraits_dialogue_german_officer_s_portrait",
	German_Ostruppen		= "Icons_portraits_dialogue_german_ostruppen_s_portrait",
	German_Grenadier		= "Icons_portraits_dialogue_german_grenadier_s_portrait",
	German_Panzer_Grenadier	= "Icons_portraits_dialogue_german_panzer_grenadier_s_portrait",
	German_Artillery		= "Icons_portraits_dialogue_german_artillery_officer_s_portrait",
	
	-- CoH2 XP1
	Derby					= {nameID = 11077130, icon = "Icons_bob_companies_dialog_support"},					-- Dog Company – Support
	Vastano					= {nameID = 11077122, icon = "Icons_bob_companies_dialog_airborne"},				-- Able Company - Airborne
	Edwards					= {nameID = 11077126, icon = "Icons_bob_companies_dialog_infantry"},				-- Baker Company - Mechanized
	Durante					= {nameID = 11081058, icon = "Icons_bob_companies_dialog_ranger"},					-- Fox Company - Ranger
	Jackson					= {nameID = 11077132, icon = "Icons_portraits_dialogue_aef_captain_w_portrait"},	-- the commander in the intro mission, temp since we have no jackson portrait
	
	Ouren_112th 			= {nameID = 11080987, icon = ""},	
	Houffalize_1st 			= {nameID = 11080988, icon = ""},	
	
	-- Generic Americans
	American_Riflemen_01	= "Icons_portraits_dialogue_aef_rifleman_w_portrait",
	American_Engineer_01	= "Icons_portraits_dialogue_aef_assault_engineer_w_portrait",
	American_Paratrooper_01	= "Icons_portraits_dialogue_aef_paratrooper_w_portrait", -- temp
	
	American_Lieutenant_01	= "Icons_portraits_dialogue_aef_lieutenant_w_portrait",
	American_Captain_01		= "Icons_portraits_dialogue_aef_captain_w_portrait",
	American_Major_01		= "Icons_portraits_dialogue_aef_major_w_portrait",
}
