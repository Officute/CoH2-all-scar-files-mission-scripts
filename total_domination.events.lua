EVENTS = {}

	
EVENTS.VPVictoryMessage = function()
	Objective_Complete(OBJ_Victory)

end

-- INTRO ------------------------------------------------------------------------------------------------
EVENTS.Briefing = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Briefing"))
end

EVENTS.Briefing_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, 11075457)      -- LOCDB [11075457] 'Securing this sector is key.  If we can capture and hold all the target territories the Germans will have to fallback.' - 'American Major'
	CTRL.WAIT()
end

EVENTS.Briefing_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079818) -- LOCDB [11079818] 'Listen -- we gotta'  secure the sector.  Maintain the target areas -- show the Krauts we mean business!'
	CTRL.WAIT()
end

EVENTS.Briefing_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081638) -- LOCDB [11081638] 'Look we've got a huge mountain to climb…We have to do everything in our power to secure the sector…  We have to capture and hold all of the target areas… It's a hell of a task, but it's up to us…Glory is within reach.'
	CTRL.WAIT()
end

EVENTS.Briefing_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079940) -- LOCDB [11079940] 'Our objective here is to capture and maintain the whole damn sector… We gotta gain control of all the target regions. Get out there and show Fritz who's boss!'
	CTRL.WAIT()
end

EVENTS.Briefing_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080180) -- LOCDB [11080180] 'Here's the objective, and it ain't easy -- we gotta secure and hold this whole goddamn sector.  We hit the Germans hard enough and they'll tuck tail and run.  Show em' what Rangers are capable of out there!'
	CTRL.WAIT()
end



EVENTS.VPPlayerStatus = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075459)      -- LOCDB [11075459] 'We're denying them strategic locations.  We're startin' to drive them out.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.VPAIStatus = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075460)      -- LOCDB [11075460] 'Germans tipped the balance.  Capture areas as soon as possible!' - 'Intel'
	CTRL.WAIT()
	
end

EVENTS.VPAllPlayer = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075461)      -- LOCDB [11075461] 'All strategic locations under our control.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.VPPlayerLostControlOfAll = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075462)      -- LOCDB [11075462] 'The balance of control is shifting.  Adjust your attack strategy.' - 'Intel'
	CTRL.WAIT()
	

end


EVENTS.VPAllEnemy = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075463)      -- LOCDB [11075463] 'Germans hold all key locations!  Counterattack and get 'em outta there.' - 'Intel'
	CTRL.WAIT()
	

end


EVENTS.EnemyForce = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075499)      -- LOCDB [11075499] 'Radio intercept indicates the Germans are movin' to recapture strategic areas.  Get your lines ready.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.EnemyForceSpawn = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075521)           -- LOCDB [11075521] 'We've I-D'd  a major enemy force pushing on a territory!  Scramble units and stop them before they can dig in.' - 'Intel'
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

EVENTS.FirstPointCaptured = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, 11081208) -- LOCDB [11081208] 'Nice work! Now, we  just gotta capture the other two strategic locations.'
	CTRL.WAIT()
end


EVENTS.CaptureReminder = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, 11081209) -- LOCDB [11081209] 'Remember, we gotta control all three goddamn strategic locations if we wanna push the enemy outta the area.'
	CTRL.WAIT()
end


-- VICTORY --------------------------------------------------------------------------------------------------------

EVENTS.Victorious = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Victorious"))
end

EVENTS.Victorious_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, 11076134)    -- LOCDB [11076134] 'All key locations secured.  German forces are withdrawing.  Good work boys.' - 'American Major'
	CTRL.WAIT()	
end

EVENTS.Victorious_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079820) -- LOCDB [11079820] 'All key sectors clear. Way to step up to the plate boys!'
	CTRL.WAIT()
end

EVENTS.Victorious_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081640) -- LOCDB [11081640] 'We're in great shape -- all key areas are clear…Germans are falling back…'
	CTRL.WAIT()
end

EVENTS.Victorious_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079942) -- LOCDB [11079942] 'The sector is ours!... The Germans threw all they got at us - but we persevered…I'm damn proud of you boys.'
	CTRL.WAIT()
end

EVENTS.Victorious_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080182) -- LOCDB [11080182] 'Area secure -- Germans didn't stand a chance against us.  Good work, Rangers!'
	CTRL.WAIT()
end

-- DEFEAT --------------------------------------------------------------------------------------------------------

EVENTS.Defeated = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Defeated"))
end

EVENTS.Defeated_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, 11076133)    -- LOCDB [11076133] 'The Germans control the sector!  Get everyone back!  Pull 'em outta there!' - 'American Major'
	CTRL.WAIT()	
end

EVENTS.Defeated_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079819) -- LOCDB [11079819] 'Goddamnit -- Krauts took the sector -- pull back before things gets more bungled up!'
	CTRL.WAIT()
end

EVENTS.Defeated_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081639) -- LOCDB [11081639] 'German's have seized control of the region -- fall back before they wipe out the entire unit!'
	CTRL.WAIT()
end

EVENTS.Defeated_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079941) -- LOCDB [11079941] 'Damnit -- the Germans have managed to take control of the sector…Fall back and regroup…I don't want any unnecessary losses on my hands.'
	CTRL.WAIT()
end

EVENTS.Defeated_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080181) -- LOCDB [11080181] 'The Germans have taken the sector -- goddamnit!...Fall back!'
	CTRL.WAIT()
end
