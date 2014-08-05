//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

//Few global vars to track the blob
var/list/blobs = list()
var/list/blob_cores = list()
var/list/blob_nodes = list()

/datum/game_mode/blob
	name = "blob"
	config_tag = "blob"

	required_players = 15
	required_players_secret = 25
	restricted_jobs = SILICON_JOBS

	var/declared = 0

	var/cores_to_spawn = 1
	var/players_per_core = 30
	var/blob_point_rate = 3

	var/blobwincount = 500 // WAS: 350

	available_roles=list("blob")

	var/known_stage=0

/datum/game_mode/blob/announce()
	world << {"<B>The current game mode is - <span class='blob'>Blob!</span></B>
<B>A dangerous alien organism is rapidly spreading throughout the station!</B>
You must kill it all while minimizing the damage to the station."}

/datum/game_mode/blob/post_setup()

	if(emergency_shuttle)
		emergency_shuttle.always_fake_recall = 1

	/*// Disable the blob event for this round.
	if(events)
		var/datum/round_event_control/blob/B = locate() in events.control
		if(B)
			B.max_occurrences = 0 // disable the event
	else
		error("Events variable is null in blob gamemode post setup.")*/

	spawn(10)
		start_state = new /datum/station_state()
		start_state.count()

	spawn(0)

		var/wait_time = rand(waittime_l, waittime_h)

		sleep(wait_time)

		send_intercept(0)

		sleep(100)

		show_message("<span class='alert'>You feel tired and bloated.</span>")

		sleep(wait_time)

		show_message("<span class='alert'>You feel like you are about to burst.</span>")

		sleep(wait_time / 2)

		burst_blobs()

		// Stage 0
		sleep(40)
		stage(0)

		// Stage 1
		sleep(2000)
		stage(1)
	..()

/datum/game_mode/blob/proc/send_alert(var/stage)
	if(known_stage>=stage) return
	known_stage=stage
	switch(stage)
		if (0)
			biohazard_alert()
			declared = 1
			return

		if (1)
			command_alert("Biohazard outbreak alert status upgraded to level 9.  [station_name()] is now locked down, under Directive 7-10, until further notice.", "Directive 7-10 Initiated")
			for(var/mob/M in player_list)
				if(!istype(M,/mob/new_player))
					M << sound('sound/AI/blob_confirmed.ogg')

	return

