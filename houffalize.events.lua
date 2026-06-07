print("\tLoading .events file...")
-- IntelEvents Table Container.
EVENTS = {}

-- NIS events table container.
NIS_EVENTS = {}


--[[********************************************************************************************************]]
------------------------------------------ NIS EVENTS -----------------------------------------------------
--[[********************************************************************************************************]]
--<none>


-- Who I've used for what:
-- ACTOR.American_Captain_01      -- the leader of the player's forces.
-- ACTOR.American_Major_01        -- the leader of the allies fighting from the north. They ask for artillery support
-- ACTOR.American_Riflemen_01  	  -- generic on-the-ground alerts
-- ACTOR.None  	 				  -- intel



--[[********************************************************************************************************]]
------------------------------------------ OBJECTIVE_1 Link-up with the 1st Army -------------------------------------------
--[[********************************************************************************************************]]

EVENTS.OBJ_LinkUp = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("OBJ_LinkUp"))
end

EVENTS.OBJ_LinkUp_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074724)      -- LOCDB [11074724] 'The 1st is trying to push into Houffalize from  the north.  We need to pull  some of the Germans off their front.  Get in there and  secure the town center.  From there, they can link up with you.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.OBJ_LinkUp_AIRBORNE= function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079784)   						   -- LOCDB [11079784] 'Alright boys -- our objective is to secure and hold the town center in Houffalize.  The 1st is moving in from the North and we gotta' clear out the Kraut's laying  fire on em'.  When the deed is done we'll link with 'em to beef up our forces.'
	CTRL.WAIT()
end

EVENTS.OBJ_LinkUp_MECHANIZED= function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081604)    					  -- LOCDB [11081604] 'Alright -- the 1st is attempting to advance into Houffalize from the North, and Baker's gotta meet 'em there.  We need take the town center, and then drive the Kraut's from the area. Get to it, men!'
	CTRL.WAIT()
end

EVENTS.OBJ_LinkUp_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079906)    						  -- LOCDB [11079906] 'Alright boys -- the 1st needs our support in Houffalize.  They're trying to push through from the North.  Move in and clear the town center. Once you've  nullified the German opposition we'll be free and clear to link up.'
	CTRL.WAIT()
end

EVENTS.OBJ_LinkUp_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080146)   						   -- LOCDB [11080146] 'The 1st needs our support boys.  They're trying to advance into Houffalize from the North, but the Germans are giving them a bumpy ride.  Head into town and suppress the German attack on the town center…From there there the 1st will be home free.'
	CTRL.WAIT()
end


--[[********************************************************************************************************]]
------------------------------------------ OBJECTIVE_2 Push the enemy out -------------------------------------------
--[[********************************************************************************************************]]


EVENTS.OBJ_PushEnemyOut = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074725)      -- LOCDB [11074725] 'This is it!  Give it to 'em!  Keep up the pressure!  We need to drive these bastards out!' - 'American Captain'
	CTRL.WAIT()
end


-- Mission Complete --------------------------------------------------------------------------------------------------------------
EVENTS.OBJ_PushEnemyOutComplete = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("OBJ_PushEnemyOutComplete"))
end

EVENTS.OBJ_PushEnemyOutComplete_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074726)      -- LOCDB [11074726] 'We've done it! They're falling back! Houffalize is ours!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.OBJ_PushEnemyOutComplete_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079785)      -- LOCDB [11079785] 'Great fuckin' job out there!  German's are bailing out of Houffalize with their tails between their legs!'
	CTRL.WAIT()
end

EVENTS.OBJ_PushEnemyOutComplete_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081605)      -- LOCDB [11081605] 'We've driven the enemy back, Houffalize is secured!'
	CTRL.WAIT()
end

EVENTS.OBJ_PushEnemyOutComplete_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079907)      -- LOCDB [11079907] 'The German attack's been stymied -- Houffalize is clear!...You handled yourselves well out there!'
	CTRL.WAIT()
end

EVENTS.OBJ_PushEnemyOutComplete_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080147)      -- LOCDB [11080147] 'We've broken the Germans' will to fight -- we've put them on their heels…Houffalize is secure thanks to us!'
	CTRL.WAIT()
end



-- Mission Fail  --------------------------------------------------------------------------------------------------------------
EVENTS.MissionFailure = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("MissionFailure"))
end

EVENTS.MissionFailure_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11075029)      -- LOCDB [11075029] 'Ahh fuck, the 1st just got it handed to them outside Houffalize.  There's no way we can take it now.' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.MissionFailure_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079786)      -- LOCDB [11079786] 'Shit -- things have gone down-hill in a real fuckin' hurry boys.  German's hammered the 1st.  Without them we're fucked - withdraw and regroup!'
	CTRL.WAIT()
end

EVENTS.MissionFailure_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081606)      -- LOCDB [11081606] 'Damnit -- the 1st took a serious beating!There's no way we're gonna take Houffalize without their help. Fall back, Baker!'
	CTRL.WAIT()
end

EVENTS.MissionFailure_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079908)      -- LOCDB [11079908] 'Bad news -- the 1st got manhandled outside of Houffalize.  Any attempt to take it would be too risky at this point.'
	CTRL.WAIT()
end

EVENTS.MissionFailure_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080148)      -- LOCDB [11080148] 'Goddamnit --  the 1st's been hit hard.  We needed all hands on deck to defend Houffalize…We gotta regroup and switch up our tactics.'
	CTRL.WAIT()
end


-- requests for artillery support from ally
EVENTS.HelpAlly = function()
	local choices = {
		11074727,    -- LOCDB [11074727] 'We could use fire support over here! Requesting you reassign your artillery coverage!' - 'American Major'
		11074728,    -- LOCDB [11074728] 'The Germans are pushing hard up here!  Redirect your artillery support if possible!  Start droppin' rounds on 'em!' - 'American Major'
		11074729,    -- LOCDB [11074729] 'Any unit on this net!  Requesting artillery support! I say again, requesting artillery support!' - 'American Major'
	}
	CTRL.Actor_PlaySpeech(ACTOR.Houffalize_1st, Table_GetRandomItem(choices))
	CTRL.WAIT()
end

-- requests for artillery support from ally during a strong enemy wave
EVENTS.HelpAllyStrong = function()
	local choices = {
		11074730,      -- LOCDB [11074730] 'We got a huge enemy force comin' our way!  Reference your map for grid!' - 'American Major'
		11074731,      -- LOCDB [11074731] 'We need that god damn artillery!  We're gettin' slaughtered over here!' - 'American Major'
		11074732,      -- LOCDB [11074732] 'Where's that support fire!?  Can anyone read us?!  We need support fire!' - 'American Major'
	}
	CTRL.Actor_PlaySpeech(ACTOR.Houffalize_1st, Table_GetRandomItem(choices))
	CTRL.WAIT()
end


--[[********************************************************************************************************]]
------------------------------------------ Enemy Artillery Objective -------------------------------------------
--[[********************************************************************************************************]]

EVENTS.EnemyArtillery = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074733)      -- LOCDB [11074733] 'German's have artillery hittin' the 1st.  We've pin pointed the location.  Get some men over there and try to capture the emplacement.  We can turn their guns right back on 'em.' - 'American Captain'
	CTRL.WAIT()
end


EVENTS.CapturedArtillery = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074734)      -- LOCDB [11074734] 'Enemy gun position captured.  Ready for fire mission orders.' - 'American Riflemen'
	CTRL.WAIT()
end




--[[********************************************************************************************************]]
------------------------------------------ Enemy Warnings -------------------------------------------
--[[********************************************************************************************************]]

-- warning of panzer attack
EVENTS.PanzerAttack = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074735)      -- LOCDB [11074735] 'Oh shit, Panzers!  Scramble AT support!' - 'American Riflemen'
	CTRL.WAIT()
end

-- warning of light armour counter attack
EVENTS.Counterattack = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074736)      -- LOCDB [11074736] 'Germans have a light armor attack force assembling.  Reports indicate they're targeting our artillery.  Get a quick-reaction-force over there to repel.' - 'Intel'
	CTRL.WAIT()
end

-- warning of pak43 attack
EVENTS.Pak43 = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074737)      -- LOCDB [11074737] 'Fuckin' big ass AT gun is covering our axis of approach!  We gotta take it out before our armour can move up!' - 'American Riflemen'
	CTRL.WAIT()
end
