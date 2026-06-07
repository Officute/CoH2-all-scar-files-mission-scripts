EVENTS = {}

-- INTRO -------------------------------------------------------------------------
EVENTS.Mission_Start = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Mission_Start"))
end

EVENTS.Mission_Start_DEFAULT = function()
	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075504)      -- LOCDB [11075504] 'Heavy fighting has caused problems bringin men up to the front.  Reinforcements will be sporadic - at best' - 'Intel'
	CTRL.WAIT()
	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075505)      -- LOCDB [11075505] 'Now use whatever you can.  Just be careful how you use it.  Make sure your combat team is well balanced.' - 'Intel'
	CTRL.WAIT()
	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075506)      -- LOCDB [11075506] 'An after action report says the Germans are sending in veteran officers to try and swing the battle.' - 'Intel'
	CTRL.WAIT()
	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075507)      -- LOCDB [11075507] 'If we can stop these guys from joinin' front line units, we can disrupt their command and control and ease up the pressure on our boys tryin' to join the lines.' - 'Intel'
	CTRL.WAIT()
	
end

EVENTS.Mission_Start_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079793)      -- LOCDB [11079793] 'Alright boys, we're in a tough spot here - heavy fighting in the area's restricting troop movements. Any reinforcements we get are gonna be sporadic.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079794)      -- LOCDB [11079794] 'We're gonna have to be goddamn careful out here - use only what's needed, and use it smart.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079795)      -- LOCDB [11079795] 'We've got word The krauts are sendin' in a unit of seasoned vets to try and turn the tide.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079796)      -- LOCDB [11079796] 'If we can block em' from joinin' the front-line, it oughta turn their command structure on it 's fuckin' head… Could help get our forces up here quicker.'
	CTRL.WAIT()
end

EVENTS.Mission_Start_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081613)      -- LOCDB [11081613] 'Alright Baker - we've gotta prepare for the worst here. We're in a bit of a bind - heavy fighting elsewhere's restricting troop movement. Any extra manpower we get is going to be coming in sporadically.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081614)      -- LOCDB [11081614] 'We're going to have to tread lightly, be efficient.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081615)      -- LOCDB [11081615] 'We've also got word that the German's are trying to pull in some  veteran  officers to coordinate their push.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081616)      -- LOCDB [11081616] 'If we can take them out, it could open the door for our boys to link up with us quicker - ease up our situation.'
	CTRL.WAIT()
end

EVENTS.Mission_Start_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079915)      -- LOCDB [11079915] 'Careful out there.  Do what you gotta do, but I don't want us suffering any unnecessary casualties out there.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079916)      -- LOCDB [11079916] 'Stay sharp.  Germans will be looking to hit us in force -- be prepared for anything…I don't want the rug being pulled out from under you.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079917)      -- LOCDB [11079917] 'Here's the latest: Germans have a group of seasoned officers to try and swing the momentum back their way.  This will be a stiff test -- we just gotta dig deep and stick together.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079918)      -- LOCDB [11079918] 'If we're able to hamper the Germans ability to command front-line units, that will go a long way in disrupting their command and control… Could even take the heat off the men attempting to join the lines...Let's get on it.'
	CTRL.WAIT()
end

EVENTS.Mission_Start_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080155)      -- LOCDB [11080155] 'Assemble your strike team and proceed with caution…Remember your training and you'll make out just fine.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080156)      -- LOCDB [11080156] 'Ready your combat team…Need to be on alert…All hell could break loose at any moment.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080157)      -- LOCDB [11080157] 'Got my hands on an after action report…Says the Krauts are dispatching their veteran officers -- their "best of the best" -- to turn the tables on us.  What they fail to realize, is that this unit is a different breed of soldier...Wars are won by men -- and we have the best men.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080158)      -- LOCDB [11080158] 'Your orders are to hinder the Germans' ability to join front-line units. That will upset their command and control.  Pressure will be off our boys trying to link up with us. The clock is ticking -- let's go!'
	CTRL.WAIT()
end


EVENTS.Officer_Appear = function()
	local choices = {
		
	11080884, -- LOCDB [11080884] 'Got word of an enemy officer headed your way; see what you can do.'
	11080885, -- LOCDB [11080885] 'Got sightings of an enemy officer around your area of operation.'
	11080886, -- LOCDB [11080886] 'A German officer should be near your position; see if you can deal with him.'

	}
	CTRL.Actor_PlaySpeech(ACTOR.None, Table_GetRandomItem(choices))
	CTRL.WAIT()
end

EVENTS.Officer_Dead = function()
	local choices = {
		
		11080887, -- LOCDB [11080887] 'I got word that German lines are in disarray. Taking out that officer must've helped!'
		11080888, -- LOCDB [11080888] 'Sounds like takin' that officer out helped; reinforcements should be arriving soon.'
		11080889, -- LOCDB [11080889] 'Takin' that officer out must've done somethin'! Just got word that we'll be getting reinforcements sooner than anticipated!'

	}
	CTRL.Actor_PlaySpeech(ACTOR.None, Table_GetRandomItem(choices))
	CTRL.WAIT()
end


EVENTS.Manpower_Increase = function()
	local choices = {
		
	11080890, -- LOCDB [11080890] 'Okay some manpower's made it through; now put it to good use!'
	11080891, -- LOCDB [11080891] 'We've got some reinforcements ready for assignment!'
	11080892, -- LOCDB [11080892] 'Got some extra manpower; use as you see fit.'
	11080893, -- LOCDB [11080893] 'We've got some reinforcements squeezed through the lines and they're are awaiting orders.'
	11080894, -- LOCDB [11080894] 'You've got extra manpower at your disposal.'


	}
	CTRL.Actor_PlaySpeech(ACTOR.None, Table_GetRandomItem(choices))
	CTRL.WAIT()
end



-- Specific Call outs ------------------------------------------------------------------------

EVENTS.Sniper = function()
	local choices = {
		11080804, -- LOCDB [11080804] 'Heads down, sniper spotted!'
		11080805, -- LOCDB [11080805] 'Watch it, enemy snipers neaby!'
		11080806, -- LOCDB [11080806] 'Got snipers in the area, get to cover!'
	}
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, Table_GetRandomItem(choices))
	CTRL.WAIT()
end

EVENTS.Bunker = function()
	local choices = {
		11080807, -- LOCDB [11080807] 'Shit, Jerry's dug in, gonna have to find a way around.'
		11080808, -- LOCDB [11080808] 'MG nest spotted, dead ahead!'
		11080809, -- LOCDB [11080809] 'Steady up, enemy bunker spotted!'
	}
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, Table_GetRandomItem(choices))
	CTRL.WAIT()
end

EVENTS.Minefield = function()
	local choices = {
		11081211, -- LOCDB [11081211] 'Pipe down! See those signs? We got mines here.'
		11081212, -- LOCDB [11081212] 'Mines, watch your step!'
		11081213, -- LOCDB [11081213] 'Goddamn minefield! We got any sweepers around?'
	}
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, Table_GetRandomItem(choices))
	CTRL.WAIT()
end

EVENTS.Artillery = function()
	local choices = {
		11081214, -- LOCDB [11081214] 'Jesus christ, they got us zeroed!'
		11081215, -- LOCDB [11081215] 'Incoming artillery, take cover!'
		11081216, -- LOCDB [11081216] 'Hit the dirt, Krauts got artillery!'
	}
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, Table_GetRandomItem(choices))
	CTRL.WAIT()
end


-- VICTORY -------------------------------------------------------------------------

EVENTS.Victorious = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Victorious"))
end

EVENTS.Victorious_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11076130)    -- LOCDB [11076130] 'The Germans are runnin' around with their heads cut off.  Enemy lines are in chaos.  Good work.' - 'Intel'
	CTRL.WAIT()	
end

EVENTS.Victorious_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079797) -- LOCDB [11079797] 'German forces are rattled… One hell of a job, fellas.'
	CTRL.WAIT()
end

EVENTS.Victorious_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081617) -- LOCDB [11081617] 'German forces are overwhelmed, They don't know which way is up right now -- That was a hell of a job, men!'
	CTRL.WAIT()
end

EVENTS.Victorious_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079919) -- LOCDB [11079919] 'We've got the German's on the run -- enemy lines are in disarray…You boys never cease to impress me.'
	CTRL.WAIT()
end

EVENTS.Victorious_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080159) -- LOCDB [11080159] 'We've got the German forces scrambling…Their lines are dazed and confused…Now's the time to hit 'em with all the force we can muster!'
	CTRL.WAIT()
end

-- DEFEAT -------------------------------------------------------------------------

EVENTS.Defeated = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Defeated"))
end

EVENTS.Defeated_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11076131)    -- LOCDB [11076131] 'They've consolidated their command structure.  We need to pullback.  Its over.' - 'Intel'
	CTRL.WAIT()	
end

EVENTS.Defeated_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079798) -- LOCDB [11079798] 'Goddamnit -- they've beefed up their lines…We're outmatched…Bail out!'
	CTRL.WAIT()
end

EVENTS.Defeated_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081618) -- LOCDB [11081618] 'German front-line units are reinforced…We don't have a hope in hell of coming out on top…Fall back!..Fall back!'
	CTRL.WAIT()
end

EVENTS.Defeated_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079920) -- LOCDB [11079920] 'Goddamnit -- they've reinforced their numbers…We're out-gunned…Retreat -- that's an order!'
	CTRL.WAIT()
end

EVENTS.Defeated_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080160) -- LOCDB [11080160] 'Germans have rallied, and bolstered their command structure…Goddamnit!...Our only option is to fall back and regroup.'
	CTRL.WAIT()
end

-- not used?!?
EVENTS.BriefingIntro = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11076132)    -- LOCDB [11076132] 'The boys in the sector have been in contact for several days.  Securing strategic sectors will bolster our lines and help drive the Germans out.' - 'Intel'
	CTRL.WAIT()	
end

