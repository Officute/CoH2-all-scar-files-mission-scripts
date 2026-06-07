EVENTS = {}

-- Who I've used for what:
--
-- ACTOR.American_Captain_01      -- the leader of the player's forces.
-- ACTOR.None      -- intel

-- INTRO --------------------------------------------------------------------------------------

EVENTS.IntroMsg = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("IntroMsg"))
end

EVENTS.IntroMsg_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11075430) -- LOCDB [11075430] 'Regiment wants a show of force.  They need to send a message to the Krauts.  We need to knock out as much armor as we can so they know we mean business.' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11075431) -- LOCDB [11075431] 'There's abandoned armor on the field.   They're likely to be out of fuel or a bit busted up.  Get to 'em before the Germans.' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.IntroMsg_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079814) -- LOCDB [11079814] 'Guys at the top want us to use our vehicles to really bring the Krauts to their knees.  Let's cut the bastards down!'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079815) -- LOCDB [11079815] 'Word is there's some abandoned tanks 'round these parts. Haul ass and take 'em before the German's get their hands on them.  They'll pack some serious punch!'
	CTRL.WAIT()
end

EVENTS.IntroMsg_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081634) -- LOCDB [11081634] 'Guys at the top insist we show the German's what we're truly capable of…to Break them down...Our armor should get the job done...krauts will be begging for mercy.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081635) -- LOCDB [11081635] 'There are unmanned tanks in the area.  Hustle - if we can get them up and running before the Germans it'll give us a real edge!'
	CTRL.WAIT()
end

EVENTS.IntroMsg_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079936) -- LOCDB [11079936] 'Regiment wants us to flex our muscles…Use our vehicles to crush the German will…Let's give them what they want.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079937) -- LOCDB [11079937] 'Got eyes on deserted armor on the field…Make your way over to it and get it online ASAP.  We don't want the Germans beating us to the punch.'
	CTRL.WAIT()
end

EVENTS.IntroMsg_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080176) -- LOCDB [11080176] 'No more fucking around okay?  Orders are a full-on vehicle assault. Krauts won't know what hit em'.  Let's get it done!'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080177) -- LOCDB [11080177] 'Listen up Rangers -- we need to haul ass and secure the abandoned armor in the area before the Germans do. Get it up and running so we can take it to em!'
	CTRL.WAIT()
end



EVENTS.EnemyCapturing = function()
	local choices = {
		11075432, 	-- LOCDB [11075432] 'Germans are recovering an abandoned tank.  Get a squad over there and stop 'em.' - 'Intel'
		11075433, 	-- LOCDB [11075433] 'Enemy's tryin' to field another abandoned tank.' - 'Intel'
		11075434, 	-- LOCDB [11075434] 'They're tryin' to put an abandoned tank back into action.  Get some men over there before they can!' - 'Intel'
	}
	CTRL.Actor_PlaySpeech(ACTOR.None, Table_GetRandomItem(choices))
	CTRL.WAIT()
end

EVENTS.EnemyCapturedTank = function()
	local choices = {
		11075435, 	-- LOCDB [11075435] 'Shit they've got the tank up and runnin'!' - 'Intel'
		11075436, 	-- LOCDB [11075436] 'Too late.  They've got it back in action!' - 'Intel'
		11075437, 	-- LOCDB [11075437] 'Goddamnit, they've just added another tank to their side!' - 'Intel'
	}
	CTRL.Actor_PlaySpeech(ACTOR.None, Table_GetRandomItem(choices))
	CTRL.WAIT()
end

-- VICTORY --------------------------------------------------------------------------------------

EVENTS.Victory = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Victory"))
end

EVENTS.Victory_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11075657) -- LOCDB [11075657] 'Kraut's are tuckin' tail! They're gonna think twice next time they want to tangle with our armor!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.Victory_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079816) -- LOCDB [11079816] 'Krauts are withdrawing their forces.  Won't be so eager to pick a fight with our armor next time.'
	CTRL.WAIT()
end

EVENTS.Victory_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081636) -- LOCDB [11081636] 'Direct hit!...That ought to knock the wind out of their sails!'
	CTRL.WAIT()
end

EVENTS.Victory_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079938) -- LOCDB [11079938] 'Germans are on their heels…They'll be licking their wounds after a beating like that.'
	CTRL.WAIT()
end

EVENTS.Victory_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080178) -- LOCDB [11080178] 'Effective hit!  Bastards didn't stand a chance against that kind of firepower!'
	CTRL.WAIT()
end


-- DEFEAT --------------------------------------------------------------------------------------

EVENTS.Defeat = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Defeat"))
end

EVENTS.Defeat_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11076056) -- LOCDB [11076056] 'Oh fuck, we've lost too many tanks!  Pull the rest outta there!  Hurry!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.Defeat_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079817) -- LOCDB [11079817] 'Shit -- we got too many tanks down!...Bail out!...Bail out!'
	CTRL.WAIT()
end

EVENTS.Defeat_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081637) -- LOCDB [11081637] 'German's have wiped out too many of our damn tanks -- Fall back, I say again… Fall back!'
	CTRL.WAIT()
end

EVENTS.Defeat_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079939) -- LOCDB [11079939] 'Shit -- Germans have hit a bunch of our tanks…We're on the wrong end of this battle…The rest of you fall back -- now!'
	CTRL.WAIT()
end

EVENTS.Defeat_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080179) -- LOCDB [11080179] 'Germans took out our tanks! Move out!  Move out!'
	CTRL.WAIT()
end


-- CALL OUTS -----------------------------------------------------------------------------------------

-- first time player gets a kill with a vehicle
EVENTS.FirstPlayerKill= function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11080802) -- LOCDB [11080802] 'Good work boys, keep pushing an' hittin' 'em with our armor!'
	CTRL.WAIT()
end

-- first time player sees an abandoned vehicle
EVENTS.FirstTankSpotted = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11080801) -- LOCDB [11080801] 'We’ve got eyes on an abandoned vehicle; let’s get the needed fuel and patch that bad boy up.'
	CTRL.WAIT()
end

-- first time enemy kills a player vehicle
EVENTS.FirstGermanKill = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11080810) -- LOCDB [11080810] 'Damnit, Krauts just took out some armor! Careful out there boys, this operation's a bust if we keep takin' hits like that!'
	CTRL.WAIT()
end

