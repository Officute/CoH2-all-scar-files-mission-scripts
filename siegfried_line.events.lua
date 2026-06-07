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




-- MISSION "Siegfried_Line" SEQUENCE "" CHARACTER ""
EVENTS.MissionIntro = function()	-- s110
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075832) -- LOCDB [11075832] 'Your main objective is the command bunker at the top of the hill.  It's the last thing between us and a clear road into Germany.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075833) -- LOCDB [11075833] 'You're clear to engage.  All companies advance to contact.  Good luck.' - 'Intel'
	CTRL.WAIT()
end


--[[********************************************************************************************************]]
------------------------------------------ Artillery - Airborne. Vastano. Able Co. ------------------------------------------
--[[********************************************************************************************************]]
EVENTS.IntroArtillery = function()	--s120
	CTRL.Actor_PlaySpeech(ACTOR.None, 11080864) -- LOCDB [11080864] 'Alright, we need you to move up the southern flank and take out the enemy gun positions along the ridge.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11080865) -- LOCDB [11080865] 'We've got men set to advance along the main road, so we need that German artillery cleared out.'
	CTRL.WAIT()
end

EVENTS.NoAirborne = function()	--s130
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075768) -- LOCDB [11075768] 'The Ardennes Offensive hit Able Company hard - There'll be no airborne support coming. Redeploy your elements accordingly!' - 'Intel'
	CTRL.WAIT()
end

EVENTS.StartArtillery = function()	--s140
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11075771) -- LOCDB [11075771] 'Able Company!  Get your asses up front!  Give it to those  bastards!' - 'Lazzaro'
	CTRL.WAIT()
end

EVENTS.Artillery_SupportAssist = function()	--s150
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075773) -- LOCDB [11075773] 'That D-Z's gonna need support.  Assigning artillery to your sector.' - 'Derby'
	CTRL.WAIT()
end

EVENTS.OutroArtillery = function()	--s170
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11075775) -- LOCDB [11075775] 'Able's got the objective,  redeploy front elements!' - 'Lazzaro'
	CTRL.WAIT()
end

EVENTS.AbleObjectiveFailed = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11080903)		-- LOCDB [11080903] 'Krauts are killing us here! We’re taking too many losses! Able company withdrawing!'
	CTRL.WAIT()
end



--[[********************************************************************************************************]]
------------------------------------------ Main road - Mechanized. Edwards, Baker Co.  ------------------------------------------
--[[********************************************************************************************************]]
EVENTS.NoMechanized = function()	--s180
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075776) -- LOCDB [11075776] 'Baker Company's a no go, took a beating back in Belgium. They won't be providing muscle for our push.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.IntroSecureRoad = function()		--s190
	CTRL.Actor_PlaySpeech(ACTOR.None, 11080866) -- LOCDB [11080866] 'We need that main road. Form an assault team and take it from the Germans!'
	CTRL.WAIT()
end

EVENTS.StartSecureRoad = function()		--s200
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11075779) -- LOCDB [11075779] 'Baker Company, fall in!' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11075780) -- LOCDB [11075780] 'The objective is heavily fortified and dug in.   There's gonna be heavy resistance so adjust attack as needed!' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11075781) -- LOCDB [11075781] 'Move out!' - 'Edwards'
	CTRL.WAIT()
end

EVENTS.Artillery_AirborneGift = function()		--s210
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11081304) -- LOCDB [11081464] 'Heads up, air recon is inbound.  Stand by for enemy updates.'
	CTRL.WAIT()
end

EVENTS.WarnEnemyArtillery = function()		--s220
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075783) -- LOCDB [11075783] 'Be advised, German artillery is moving into position.  I say again, German artillery is moving into position.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.OutroSecureRoad = function()		--s230
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11075784) -- LOCDB [11075784] 'This is Baker company!  Main road secured! I say again, main road secure.  We got a straight line into the bunker!' - 'Edwards'
	CTRL.WAIT()
end

EVENTS.BakerObjectiveFailed = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081493)		-- LOCDB [11081493] 'Baker Company is taking heavy casualties. We are not combat effective! I I say again -  We are not combat effective! Withdrawing to a safe distance!'
	CTRL.WAIT()
end


--[[********************************************************************************************************]]
------------------------------------------ AA Guns - Support. Derby. Dog Co. ------------------------------------------
--[[********************************************************************************************************]]
EVENTS.NoSupport = function()	--s240
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075785) -- LOCDB [11075785] 'Dog Company remains combat ineffective following the fighting back in the Ardennes.  Do you hear me?  Dog is ineffective.  They can not provide support for the attack.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.IntroAAGuns = function()	--s250
	CTRL.Actor_PlaySpeech(ACTOR.None, 11080867) -- LOCDB [11080867] 'Report in: what's your status?  I say again, what's your status?'
	CTRL.WAIT()
end

EVENTS.StartAAGuns = function()	--s260
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075787) -- LOCDB [11075787] 'We're moving in from the south on enemy AA positions.' - 'Derby'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075788) -- LOCDB [11075788] 'Encountering light resistance, stand by for updates.  Over.' - 'Derby'
	CTRL.WAIT()
end

EVENTS.OutroAAGuns = function()	--270
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075790) -- LOCDB [11075790] 'This is Dog Company, SitRep - all enemy AA Guns destroyed! Position clear!' - 'Derby'
	CTRL.WAIT()
end

EVENTS.DogObjectiveFailed = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11081203)		-- LOCDB [11081203] 'Enemy forces are pushing us back. We are unable to reach target! Dog company is standing down!'
	CTRL.WAIT()
end

EVENTS.AA_AirborneAssist = function()	--s280
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11081305) -- LOCDB [11081466] 'Heads up.  Friendlies inbound.  Watch your fire.'
	CTRL.WAIT()
end

EVENTS.AAGun2ArmorSpotted = function()	--s290
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11075792) -- LOCDB [11075792] 'Contact! Kraut panzers!' - 'American_Riflemen'
	CTRL.WAIT()
end

EVENTS.AA_MechanizedAssist = function()	--s300
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11075793) -- LOCDB [11075793] 'Stand fast!  Hold your position!  I'm sendin' armor support your way!' - 'Edwards'
	CTRL.WAIT()
end




--Triggered if all start challenges are failed.
EVENTS.ChallengesFailed = function()	--s310
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075794) -- LOCDB [11075794] 'All stations, all stations!  Mission fail, mission fail.  Kraut defenses are too strong. Disengage and fall back. I say again, disengage and fall back!' - 'Intel'
	CTRL.WAIT()
end




--[[********************************************************************************************************]]
------------------------------------------ Command bunker assault ------------------------------------------
--[[********************************************************************************************************]]
EVENTS.CommanderSelection = function()	--s320
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075818) -- LOCDB [11075818] 'This is it boy.  Final German defensive line.  Once we push past this, it's clear sailin' into Germany.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075819) -- LOCDB [11075819] 'Now who's going to spearhead the push?' - 'Intel'
	CTRL.WAIT()
end


EVENTS.AirborneSelected = function()	--s330
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11075797) -- LOCDB [11075797] 'Able Company will be primary assault team.' - 'Lazzaro'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075820) -- LOCDB [11075820] 'All combat teams, push off on Captain Vastano's lead.  Continue the advance toward the German stronghold.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.MechanizedSelected = function()	--s340
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11075798) -- LOCDB [11075798] 'Baker ready to jump off on final assault!' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075821) -- LOCDB [11075821] 'All combat teams, push off on Captain Edwards' lead.  Continue the advance toward the German stronghold.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.SupportSelected = function()	--s350
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075799) -- LOCDB [11075799] 'Dog Company ready for final attack!' - 'Derby'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075822) -- LOCDB [11075822] 'All combat teams, push off on Captain Derby's lead.  Continue the advance toward the German stronghold.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.ReconSelected = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080846) 		-- LOCDB [11080846] 'Fox Company ready to take lead'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11080868)		-- LOCDB [11080868] 'All combat teams, push off on Captain Durante's lead.  Continue the advance toward the German stronghold'
	CTRL.WAIT()
end




------------------------ DLC Commander - Fox Company ------------------------ 
--Recon not available for challenge
EVENTS.NoRecon = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11080899) 		-- LOCDB [11080899] 'Fox company is down and out - they took serious hits in the Ardennes - Don't expect support from the Rangers out there!'
	CTRL.WAIT()
end

EVENTS.FoxStartArtillery = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080835) 		-- LOCDB [11080835] 'Fox Company! Move up and close in on those artillery positions! Secure the area and take them out.'
	CTRL.WAIT()
end

EVENTS.FoxStartRoad = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080837)		-- LOCDB [11080837] 'Alright, listen up Fox Company! We’ve got heavy resistance along the main road.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080838)		-- LOCDB [11080838] 'Flanking paths are an option, but they are well defended.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080839)		-- LOCDB [11080839] 'Proceed with caution.'
	CTRL.WAIT()
end

EVENTS.FoxStartAAGuns = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080832)		-- LOCDB [11080832] 'Fox Company approaching the target area from the south.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080833)		-- LOCDB [11080833] 'We’re encountering light resistance so far. Advancing on target! Over!'
	CTRL.WAIT()
end

EVENTS.FoxObjectiveFailed = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080841)		-- LOCDB [11080841] 'Fox Company is getting beat up pretty hard! Fall back! Fall back!'
	CTRL.WAIT()
end

EVENTS.FoxOutroArtillery = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080836)		-- LOCDB [11080836] 'Enemy artillery positions have been disabled! You are clear to advance on target.'
	CTRL.WAIT()
end

EVENTS.FoxOutroRoad = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080840)		-- LOCDB [11080840] 'German forces on the main road have been eliminated and the position is secure. Say again: Main road is secure.'
	CTRL.WAIT()
end

EVENTS.FoxOutroAAGuns = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080834)		-- LOCDB [11080834] 'Fox Company reporting. Enemy AA guns have been neutralized. Skies are clear for further deployments.'
	CTRL.WAIT()
end


--Fox Assistance events
EVENTS.FoxAssistanceRangers = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080842)		-- LOCDB [11080842] 'Fox Company is providing Rangers to support you, stand by!'
	CTRL.WAIT()
end

EVENTS.FoxAssistanceCluster = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080843)		-- LOCDB [11080843] 'Durante here. Deploying cluster bombs on target. Clear the area.'
	CTRL.WAIT()
end

EVENTS.FoxAssistanceArtillery = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080845)		-- LOCDB [11080845] 'Fox Company can provide artillery support. Coordinates locked. Fire incoming!'
	CTRL.WAIT()
end

EVENTS.FoxAssistanceGeneric = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080844)		-- LOCDB [11080844] 'This is Durante with Fox Company. We’re sending some reinforcements your way.'
	CTRL.WAIT()
end





--Periodic german counter-attacks
EVENTS.WarnGermanAttack = function()	--s360
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075800) -- LOCDB [11075800] 'Be advised: German counter attack is moving on your position.' - 'Intel'
	CTRL.WAIT()
end


--Warn about pillboxes
EVENTS.WarnPillboxRecrew = function()	--s370
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11075801) -- LOCDB [11075801] 'Krauts keep mannin' those pillboxes - we've gotta find a way to take the damn things out!' - 'American_Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075802) -- LOCDB [11075802] 'Understood.  Armor assistance directed to your position.  Stand by.' - 'Intel'
	CTRL.WAIT()
end



--Dialogue after spotting a heavy tank on the main road
EVENTS.RoadTankSpotted = function()	--s380
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11075803) -- LOCDB [11075803] 'Contact!  Heavy panzer on the main road!  Request immediate support!' - 'American_Riflemen'
	CTRL.WAIT()
end

EVENTS.RoadTankArtillery = function()	--s381	(continuation)
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075804) -- LOCDB [11075804] 'Roger.  Stand by AT barrage to your front.  Adjust your position.' - 'Derby'
	CTRL.WAIT()
end

EVENTS.RoadTankM10 = function()	--s382 	(continuation)
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11075805) -- LOCDB [11075805] 'Roger, understood.  I'm sendin' a tank over to your position.' - 'Edwards'
	CTRL.WAIT()
end


--Going up the hill
EVENTS.BunkerResistance = function()	--s390
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11075806) -- LOCDB [11075806] 'We're up against heavy resistance! Request support!' - 'American_Captain'
	CTRL.WAIT()
end

EVENTS.BunkerResistanceAirstrike = function()	--s391	(continuation)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11075807) -- LOCDB [11075807] 'Roger - P-47 inbound!' - 'Lazzaro'
	CTRL.WAIT()
end



EVENTS.HillTaken = function()	--s400
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11075808) -- LOCDB [11075808] 'We're takin' heavy fire from the top of the hill!  We need support!' - 'American_Captain'
	CTRL.WAIT()
end

EVENTS.TargetBunker = function()	--s410
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075809) -- LOCDB [11075809] 'Reinforcements are coming from the bunker.  Direct all fire on that position.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075810) -- LOCDB [11075810] 'Additional troops have been dispatched to aid your efforts. Hold your position.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.BunkerSpawningEnded = function()	--s420
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11075811) -- LOCDB [11075811] 'Bunker destroyed!  Securing final objective!' - 'American_Captain'
	CTRL.WAIT()
end

EVENTS.CommandBunkerSecured = function()
	--Maybe have unique line based on the character traits
	local _line1 = Loc_Empty()
	local _line2 = Loc_Empty()
	
	
	--These should be in individual EVENT functions for DevTest purposes.
	
	if(XP1_GetDivision() == CD_AIRBORNE) then	--s430
		_line1 = 11075812 -- LOCDB [11075812] 'This is Vastano,  we've taken the hill and secured the command bunker.' - 'Lazzaro'
		_line2 = 11075813 -- LOCDB [11075813] 'This is it!  Give it to 'em!  Keep movin' forward!' - 'Lazzaro'
	elseif(XP1_GetDivision() == CD_MECHANIZED) then		--s440
		_line1 = 11075814 -- LOCDB [11075814] 'Captain Edwards here.  Command bunker secured, holding on the final position.' - 'Edwards'
		_line2 = 11075815 -- LOCDB [11075815] 'Assault formations!  Watch your spacin'!   Keep pushin'!' - 'Edwards'
	elseif(XP1_GetDivision() == CD_SUPPORT) then	--s450
		_line1 = 11075816 -- LOCDB [11075816] 'It's Derby.   Hill secured -- bunker overrun.   Holdin' on objective.' - 'Derby'
		_line2 = 11075817 -- LOCDB [11075817] 'Alright boys!  Give it to 'em!' - 'Derby'
	elseif(XP1_GetDivision() == CD_RANGER) then
		_line1 = 11080847		-- LOCDB [11080847] 'Fox Company reporting! Objective secured! I repeat: The bunker has been secured!'
		_line2 = 11080848		-- LOCDB [11080848] 'Rangers lead the way!'
	else
		fatal("Unrecognized Company ID")
	end
	
	
	CTRL.Actor_PlaySpeech(XP1_CommanderPortrait(), _line1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(XP1_CommanderPortrait(), _line2)
	CTRL.WAIT()
end



-- Player base destroyed
EVENTS.PlayerBaseDestroyed = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("PlayerBaseDestroyed"))
end

EVENTS.PlayerBaseDestroyed_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11075837 )  -- LOCDB [11075837] 'They are crushing our base! Retreat! Retreat!' - 'American Rifleman'
	CTRL.WAIT()
end

EVENTS.PlayerBaseDestroyed_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079801) -- LOCDB [11079801] 'HQ's being demolished!  Pull back! Pull back goddamnit!'
	CTRL.WAIT()
end

EVENTS.PlayerBaseDestroyed_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081621) -- LOCDB [11081621] 'Goddamn, the Germans are wreaking havoc on our HQ - Retreat, Baker!'
	CTRL.WAIT()
end

EVENTS.PlayerBaseDestroyed_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079923) -- LOCDB [11079923] 'They've toppled our HQ bases Get to cover!...Move!'
	CTRL.WAIT()
end

EVENTS.PlayerBaseDestroyed_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080163) -- LOCDB [11080163] 'Our bases are absorbing massive blows…Move out!...Go!'
	CTRL.WAIT()
end

