EVENTS = {}
	
function Init_Audio()
	
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc1/t01")
	g_MissionSpeechPath = "theater_of_war/dlc1/t01"
	
end

Scar_AddInit(Init_Audio)


--
-- Intro speech
--
EVENTS.MissionStart = function() -- 010

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11050988) -- LOCDB [11050988] 'The Germans have held the Don river region since early August. Today, we try to cut them off at the bridge in Kalach, and encircle their forces in Stalingrad.' - 'Soviet Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11050989) -- LOCDB [11050989] 'We have armies arriving from the north-east and from the south-west. We attack the Germans from both sides.' - 'Soviet Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11050990) -- LOCDB [11050990] 'Once we control most of the east and west banks of the river, we shall then make a move for the crossing itself.' - 'Soviet Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11050994) -- LOCDB [11050994] 'Yes, again.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11052275) -- LOCDB [11052275] 'Yes, again.'
	CTRL.WAIT()

end



-- Start of round to capture ferry points
EVENTS.CaptureFerryPoints_Initial = function() -- 020
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11050991) -- LOCDB [11050991] 'To start with, Command wants you to capture the watchtowers in the dockyards on either side of the Don river.' - 'Soviet Officer'
	CTRL.WAIT()
end

EVENTS.CaptureFerryPoints_Normal = function() -- 030
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11050992) -- LOCDB [11050992] 'New orders, men! Capture the watchtowers in the dockyards either side of the Don river!' - 'Soviet Officer'
	CTRL.WAIT()
end

EVENTS.CaptureFerryPoints_Repeat = function() -- 040
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11050993) -- LOCDB [11050993] 'New orders. Command wants the watchtowers in the dockyards either side of the Don river captured.' - 'Soviet Officer'
	CTRL.WAIT()
end



-- Start of round to capture radio towers
EVENTS.CaptureRadioPoints_Initial = function() -- 050
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11050995) -- LOCDB [11050995] 'To start with, Command wants you to capture the radio towers on the hills.' - 'Soviet Officer'
	CTRL.WAIT()
end

EVENTS.CaptureRadioPoints_Normal = function() -- 060
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11050996) -- LOCDB [11050996] 'New orders, men! Capture the radio towers on the hills!' - 'Soviet Officer'
	CTRL.WAIT()
end

EVENTS.CaptureRadioPoints_Repeat = function() -- 070
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11050997) -- LOCDB [11050997] 'New orders. Command wants the radio towers on the hills captured.' - 'Soviet Officer'
	CTRL.WAIT()
end



-- Start of round to capture road checkpoints -- 080
EVENTS.CaptureCheckpoints_Initial = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11050998) -- LOCDB [11050998] 'To start with, Command wants you to capture the checkpoints on the roads leading out of the area.' - 'Soviet Officer'
	CTRL.WAIT()
end
EVENTS.CaptureCheckpoints_Normal = function() -- 090
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11050999) -- LOCDB [11050999] 'New orders, men! Capture the checkpoints on the roads leading out of the town!' - 'Soviet Officer'
	CTRL.WAIT()
end
EVENTS.CaptureCheckpoints_Repeat = function() -- 100
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051000) -- LOCDB [11051000] 'New orders. Command wants the checkpoints on the roads leading out of the town captured.' - 'Soviet Officer'
	CTRL.WAIT()
end



-- Start of round to capture fuel points
EVENTS.CaptureFuelPoints_Initial = function()
	-- Not used (this type never comes up as the first round)
end

EVENTS.CaptureFuelPoints_Normal = function() -- 110
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051001) -- LOCDB [11051001] 'New orders, men! Capture the fuel points!' - 'Soviet Officer'
	CTRL.WAIT()
end

EVENTS.CaptureFuelPoints_Repeat = function() -- 120
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051002) -- LOCDB [11051002] 'New orders. Command wants the fuel points captured.' - 'Soviet Officer'
	CTRL.WAIT()
end



-- Start of round to capture munitions points
EVENTS.CaptureMunitionsPoints_Initial = function()
	-- Not used (this type never comes up as the first round)
end

EVENTS.CaptureMunitionsPoints_Normal = function() -- 130
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051003) -- LOCDB [11051003] 'New orders, men! Capture the munitions points!' - 'Soviet Officer'
	CTRL.WAIT()
end

EVENTS.CaptureMunitionsPoints_Repeat = function() -- 140
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051004) -- LOCDB [11051004] 'New orders. Command wants the munitions points captured.' - 'Soviet Officer'
	CTRL.WAIT()
end



-- Start of round to capture points on the east riverbank (player 2's side)
EVENTS.CaptureEastPoints_Initial = function()
	-- Not used (this type never comes up as the first round)
end

EVENTS.CaptureEastPoints_Normal = function() -- 150
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051005) -- LOCDB [11051005] 'New orders, men! Capture the watchtowers on the east riverbank!' - 'Soviet Officer'
	CTRL.WAIT()
end

EVENTS.CaptureEastPoints_Repeat = function() -- 160
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051006) -- LOCDB [11051006] 'New orders. Command wants the watchtowers on the east riverbank captured.' - 'Soviet Officer'
	CTRL.WAIT()
end



-- Start of round to capture points on the west riverbank (player 1's side)
EVENTS.CaptureWestPoints_Initial = function()
	-- Not used (this type never comes up as the first round)
end

EVENTS.CaptureWestPoints_Normal = function() -- 170
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051007) -- LOCDB [11051007] 'New orders, men! Capture the watchtowers on the west riverbank!' - 'Soviet Officer'
	CTRL.WAIT()
end

EVENTS.CaptureWestPoints_Repeat = function() -- 180
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051008) -- LOCDB [11051008] 'New orders. Command wants the watchtowers on the west riverbank captured.' - 'Soviet Officer'
	CTRL.WAIT()
end



-- Start of round to capture points on the river
EVENTS.CaptureRiverPoints_Initial = function() -- 190
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051009) -- LOCDB [11051009] 'To start with, Command wants you to capture the points on the Don river.' - 'Soviet Officer'
	CTRL.WAIT()
end

EVENTS.CaptureRiverPoints_Normal = function() -- 200
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051010) -- LOCDB [11051010] 'New orders, men! Capture the points on the Don River!' - 'Soviet Officer'
	CTRL.WAIT()
end

EVENTS.CaptureRiverPoints_Repeat = function() -- 210
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051011) -- LOCDB [11051011] 'New orders. Command wants the points on the Don River captured.' - 'Soviet Officer'
	CTRL.WAIT()
end



-- Start of final round to capture the bridge
EVENTS.CaptureBridge = function() -- 220

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051012) -- LOCDB [11051012] 'This is it! Their last holdout' - 'Soviet Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051013) -- LOCDB [11051013] 'Take out their defences and secure that bridge!' - 'Soviet Officer'
	CTRL.WAIT()
	
end

EVENTS.CaptureBridgeVP = function() -- 230

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051014) -- LOCDB [11051014] 'Capture that Victory Point!' - 'Soviet Officer'
	CTRL.WAIT()
	
end

EVENTS.CaptureBridgeExpectRetaliation = function() -- 240

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051015) -- LOCDB [11051015] 'Good work! Now hold that point and look out for counterattacks.' - 'Soviet Officer'
	CTRL.WAIT()
	
end






EVENTS.MissionWin = function() -- 250

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051016) -- LOCDB [11051016] 'We have the bridge!' - 'Soviet Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051017) -- LOCDB [11051017] 'We have their forces encircled! Congratulations!' - 'Soviet Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11052277) -- LOCDB [11052277] 'We have their forces encircled! Congratulations!' - 'Soviet Officer'
	CTRL.WAIT()
	
end


EVENTS.MissionFail = function() -- 260

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051018) -- LOCDB [11051018] 'The Germans have held strong. Our efforts have been neutralised.' - 'Soviet Officer'
	CTRL.WAIT()
	
end



