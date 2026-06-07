EVENTS = {}

-- intro ---------------------------------------------------------------------------------------------------

EVENTS.Mission_Start = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Mission_Start"))
end

EVENTS.Mission_Start_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01,  11075443) -- LOCDB [11075443] 'You have 60 seconds to shake out your forces.  I want you to hit Oberkommando West  and keep them occupied while I push adjacent A.O.s' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01,  11080803) -- LOCDB [11080803] 'The Germans are already set up in key locations, expect stiff resistance right out of the gates!'
	CTRL.WAIT()
end

EVENTS.Mission_Start_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079781) -- LOCDB [11079781] 'Listen -- we got 60 seconds to form up! This is how it'll shake out… We gotta' hit Oberkommando West and keep em' busy here while other forces hit adjacent A.O.'s. Don't let me down -- let's go!'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01,  11080803) -- LOCDB [11080803] 'The Germans are already set up in key locations, expect stiff resistance right out of the gates!'
	CTRL.WAIT()
end

EVENTS.Mission_Start_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081601) -- LOCDB [11081601] 'We've gotta shake out our forces, now!  We need to hit the Germans here to keep them occupied while other forces push nearby.  It won't be easy, but Baker's up to the task!'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01,  11080803) -- LOCDB [11080803] 'The Germans are already set up in key locations, expect stiff resistance right out of the gates!'
	CTRL.WAIT()
end

EVENTS.Mission_Start_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079903) -- LOCDB [11079903] 'Alright, dog - here's the deal. We gotta hit the Germans hard to tie 'em up here while our forces stike nearby regions. Move with caution -- I'm counting on you boys.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01,  11080803) -- LOCDB [11080803] 'The Germans are already set up in key locations, expect stiff resistance right out of the gates!'
	CTRL.WAIT()
end

EVENTS.Mission_Start_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080143) -- LOCDB [11080143] 'Let's get down to business… I want our forces formed up and ready to go.  While other units are leadin' the charge elsewhere, we've gotta strike Oberkommando West hard to keep their hands full here…Should be a breeze for this group.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01,  11080803) -- LOCDB [11080803] 'The Germans are already set up in key locations, expect stiff resistance right out of the gates!'
	CTRL.WAIT()
end




EVENTS.Wave_Approaching = function()
	local choices = {
		11080878, -- LOCDB [11080878] 'Germans are sending reinforcements, shore up your defenses!'
		11080879, -- LOCDB [11080879] 'Jerry's moving on your point, be prepared!'
		11080880, -- LOCDB [11080880] 'Careful out there, got reports of a German force moving on your position!'
		11080881, -- LOCDB [11080881] 'Heads up, Krauts headed your way!'
		11080882, -- LOCDB [11080882] 'Enemy forces converging on your sector!'
		11080883, -- LOCDB [11080883] 'Get ready, enemy forces approaching!'
	}
	CTRL.Actor_PlaySpeech(ACTOR.None, Table_GetRandomItem(choices))
	CTRL.WAIT()
end



-- Victory -----------------------------------------------------------------------------------------------

EVENTS.Victory = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Victory"))
end

EVENTS.Victory_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01,  11075652) -- LOCDB [11075652] 'Your attack has been quite effective and, it's allowed assaults in other regions resounding success' - 'American Major'
	CTRL.WAIT()
end

EVENTS.Victory_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079782) -- LOCDB [11079782] 'Assaults all over are goin' our way thanks to you guys…You're really on top of your game…Keep it up!'
	CTRL.WAIT()
end

EVENTS.Victory_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081602) -- LOCDB [11081602] 'Damn fine job out there, men! We've kept them busy long enough for the other regions to be secured.'
	CTRL.WAIT()
end

EVENTS.Victory_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079904) -- LOCDB [11079904] 'Alright, men, you've done your part -- excellent work out there!'
	CTRL.WAIT()
end

EVENTS.Victory_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080144) -- LOCDB [11080144] 'Alright! Our execution was spot on…  Great work, Fox!'
	CTRL.WAIT()
end

-- Defeat -----------------------------------------------------------------------------------------------

EVENTS.Defeat = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Defeat"))
end

EVENTS.Defeat_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, 11075653) -- LOCDB [11075653] 'It's not working,  Fallback and regroup!' - 'American Major'
	CTRL.WAIT()
end

EVENTS.Defeat_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079783) -- LOCDB [11079783] 'We're not getting' it done! Fall back…now goddamnit!'
	CTRL.WAIT()
end

EVENTS.Defeat_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081603) -- LOCDB [11081603] 'Goddamnit -- the assault has been ineffective!  Fall back before we lose more men!'
	CTRL.WAIT()
end

EVENTS.Defeat_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079905) -- LOCDB [11079905] 'Christ, Fritz is puttin us through hell out here! We gotta pull out before things get any worse!'
	CTRL.WAIT()
end

EVENTS.Defeat_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080145) -- LOCDB [11080145] 'We're getting' hammered -- pull back!...This engagement has turned into a fucking disaster!'
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
