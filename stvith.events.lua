print("\tLoading .events file...")
-- IntelEvents Table Container.
--	This contains all Regular IntelEvent functions (simple dialogue).
EVENTS = {}

-- NIS events table container.
--[[	Unlike the EVENTS table, NIS_EVENTS contains more complex intel events that involve logic, unit movement, etc. 
		These are kept separete in order to allow QA to rapidly iterate to all dialogue sequences without breaking any mission logic. ]]--
NIS_EVENTS = {}



--[[********************************************************************************************************]]
------------------------------------------ NIS EVENTS -----------------------------------------------------
--[[********************************************************************************************************]]




--[[********************************************************************************************************]]
------------------------------------------ OBJECTIVE_1 HOLD THE TOWN ---------------------------------
--[[********************************************************************************************************]]
--SEQUENCE "" MISSION "StVith" CHARACTER "American Riflemen"
EVENTS.Intro = function()	--s110
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Intro"))
end

--COmpany-specific intro lines
EVENTS.Intro_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074578)	-- LOCDB [11074578] 'We got three key locations to defend; set up on the church, those crossroads and the rail yard.  Don't waste any time.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11080873)	-- LOCDB [11080873] 'Hold those lines!  We can’t let the Germans recapture St. Vith!'
	CTRL.WAIT()
end

EVENTS.Intro_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079810)	-- LOCDB [11079810] 'Alright, To hold St. Vith we gotta' set up shop in three key spots: the church, the rail yard, and the main crossroads.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079811)	-- LOCDB [11079811] 'Hold those lines -- whatever it takes - we're not giving up St. Vith to those bastards! Clock's tickin' so  get a move on!'
	CTRL.WAIT()
end

EVENTS.Intro_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081630)	-- LOCDB [11081630] 'Time's not on our side so I'll keep this brief…There's three locations we must defend In St.Vith; The rail yard, the church, and the main cross-roads. I want men positioned it all three.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081631)	-- LOCDB [11081631] 'Do everything you can to hold the Germans off - we can't let St. Vith fall!'
	CTRL.WAIT()
end

EVENTS.Intro_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079932)	-- LOCDB [11079932] 'We've got our hands full here in St. Vith…We need men protecting the church, the main crossroads, and the rail yard…Move with caution out there.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079933)	-- LOCDB [11079933] 'Hold the goddamn lines…Germans can't be allowed to break through!'
	CTRL.WAIT()
end

EVENTS.Intro_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080172)	-- LOCDB [11080172] 'Here we go boys  -- we're tasked with defending three positions.  We need men at the church,  the rail yard, and the main crossroads.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080173)	-- LOCDB [11080173] 'Dig in and hold fast!  Germans can't breach our defenses, even if it takes every last one of us -- they need to be held off!'
	CTRL.WAIT()
end




EVENTS.Outro = function()	--s120
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Outro"))
end

--Company-specific
EVENTS.Outro_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074580)	-- LOCDB [11074580] 'Looks like that's the last of them. Well done, men.' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.Outro_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079812)	-- LOCDB [11079812] 'Tide's have turned - the Kraut's are done for! You boys really delivered -- great job!'
	CTRL.WAIT()
end

EVENTS.Outro_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081632)	-- LOCDB [11081632] 'Looks like that's the last of them. Well done boys…You're really earning your stripes out here.'
	CTRL.WAIT()
end

EVENTS.Outro_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079934)	-- LOCDB [11079934] 'Targets eliminated…Nice shooting out there.'
	CTRL.WAIT()
end

EVENTS.Outro_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080174)	-- LOCDB [11080174] 'That's it -- The Germans are finished, no way they're getting St. Vith now!'
	CTRL.WAIT()
end



EVENTS.MissionFail = function()	--s130
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("MissionFail"))
end

--Company-specific
EVENTS.MissionFail_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11076043) -- LOCDB [11076043] 'They've broken through our defenses, all forces fall back! Repeat, fall back!' - 'Intel'
	CTRL.WAIT()
end

EVENTS.MissionFail_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079813)	-- LOCDB [11079813] 'Goddamnit!  German's punched through our defenses.  Bail out…Now!'
	CTRL.WAIT()
end

EVENTS.MissionFail_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081633)	-- LOCDB [11081633] 'They've broken through our defenses, all forces fall back! I say again - fall back!'
	CTRL.WAIT()
end

EVENTS.MissionFail_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079935)	-- LOCDB [11079935] 'They've smashed through our defenses…We're exposed…Fucking pull back!'
	CTRL.WAIT()
end

EVENTS.MissionFail_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080175)	-- LOCDB [11080175] 'We lost St. Vith!  Fall back! Fall back goddamnit!'
	CTRL.WAIT()
end



EVENTS.InformRecon = function()	--s140
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074581)	-- LOCDB [11074581] 'We got aerial recon on station.  They should be able to give us a heads up on enemy movement.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.StartWaves = function()	--s150
	CTRL.Event_Delay(4.0)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074582)	-- LOCDB [11074582] 'Air recon just spotted German's closing on your position.  Stand to.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11080800)	-- LOCDB [11080800] 'Here they come!  Get ready!  Make it count!'
	CTRL.WAIT()
end

EVENTS.ScoutWave = function()	--s160
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074584)	-- LOCDB [11074584] 'Re-org those lines -- shake out the men.  That was just a probing attack.  They'll be comin' back soon.' - 'American Captain'
	CTRL.WAIT()
end


--Cues for whenever any of the points are being lost
EVENTS.LosingChurch = function()	--s170
	UI_CreateMinimapBlip(eg_terrChurch, 7, BT_CaptureHere)
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074585)	-- LOCDB [11074585] 'We're losing the church!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.LostChurch = function()	--s180
	UI_CreateMinimapBlip(eg_terrChurch, 7, BT_AttackHere)
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074586)	-- LOCDB [11074586] 'German's over-ran the goddamn church!' - 'American Riflemen'
	CTRL.WAIT()
end


EVENTS.LosingRailyard = function()	--s190
	UI_CreateMinimapBlip(eg_terrRailyard, 7, BT_CaptureHere)
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074587)	-- LOCDB [11074587] 'We're losin' ground at the railyard!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.LostRailyard = function()	--s200
	UI_CreateMinimapBlip(eg_terrRailyard, 7, BT_AttackHere)
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074588)	-- LOCDB [11074588] 'Railyard just got overrun!' - 'American Riflemen'
	CTRL.WAIT()
end


EVENTS.LosingCrossroad = function()	--s210
	UI_CreateMinimapBlip(eg_terrCrossroad, 7, BT_CaptureHere)
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074589)	-- LOCDB [11074589] 'German's stickin' it to us at the crossroads!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.LostCrossroad = function()	--s220
	UI_CreateMinimapBlip(eg_terrCrossroad, 7, BT_AttackHere)
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074590)	-- LOCDB [11074590] 'Germans just pushed through!  They got the crossroads!' - 'American Riflemen'
	CTRL.WAIT()
end


--Attack hints (SINGLE direction)
EVENTS.HintChurch = function()	--s230
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074591)	-- LOCDB [11074591] 'Be advised, we have eyes on enemy units closing on the church.  Say again, enemy closing on the church.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.HintRail = function()	--s240
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074592)	-- LOCDB [11074592] 'German's are making a push on the rail yard.  They're closin' fast, over.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.HintRoad = function()	--s250
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074593)	-- LOCDB [11074593] 'Heads up on the crossroads.  Enemy making a push on your lines.' - 'Intel'
	CTRL.WAIT()
end


--Attack hints (MULTIPLE directions)
EVENTS.HintChurchRail = function()	--s260
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074594)	-- LOCDB [11074594] 'Be advised, Germans are making a two prong assault on the church and rail yard.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.HintChurchRoad = function()	--s270
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074595)	-- LOCDB [11074595] 'Heads up - Enemy moving on the church and crossroads.  They'll be on you any second.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.HintRailRoad = function()	--s280
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074596)	-- LOCDB [11074596] 'Germans pushing on the rail yard and crossroads!' - 'Intel'
	CTRL.WAIT()
end

--Miniboss hints
EVENTS.WarnMiniBoss1 = function()	--s290
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074597)	-- LOCDB [11074597] 'Armor inbound!  I say again, armor inbound.  Panzer IV's approaching your location!' - 'Intel'
	CTRL.WAIT()
end

EVENTS.WarnKingTiger = function()	--s290
	CTRL.Actor_PlaySpeech(ACTOR.None, 11080874)	-- LOCDB [11080874] 'Don't want to alarm you, but there's a King Tiger headed towards your position.'
	CTRL.WAIT()
end

EVENTS.WarnFinalWave = function()	--s300
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074598)	-- LOCDB [11074598] 'They're throwing everything they got at us!  Hold the lines!  Hold the lines!' - 'American Riflemen'
	CTRL.WAIT()
end

--Radio jammer cues
EVENTS.InformJammer = function()	--s310
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074599)	-- LOCDB [11074599] '<Garbled radio message>  Enemy has set up radio jammers. They're blocking relays from air recon.  Find and destroy them.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074600)	-- LOCDB [11074600] 'Comm's are down.  We can't reach battalion Intel!' - 'American Riflemen'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074601)	-- LOCDB [11074601] 'German's are blocking our radio frequencies.  Find their jammers and take them out!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.GarbledRadio = function()	--s320 (though it's just a repeat of a text line from s310 above)
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074599) -- LOCDB [11074599] '<Garbled radio message>  Enemy has set up radio jammers. They're blocking relays from air recon.  Find and destroy them.' - 'Intel'
	CTRL.WAIT()
	UIWarning_Show(11076631)		-- LOCDB [11076631] 'Radio Jammer in the area'
end

