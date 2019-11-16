/datum/component/art
	var/impressiveness = 0

/datum/component/art/Initialize(impress)
	impressiveness = impress
	if(isstructure(parent))
		RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, .proc/on_attack_hand)


/datum/component/art/proc/on_other_examine(datum/source, mob/M)
	apply_moodlet(M, impressiveness)

/datum/component/art/proc/on_obj_examine(datum/source, mob/M)
	var/obj/O = parent
	apply_moodlet(M, impressiveness *(O.obj_integrity/O.max_integrity))

/datum/component/art/proc/on_attack_hand(datum/source, mob/M)
	to_chat(M, "<span class='notice'>You start examining [parent]...</span>")
	if(!do_after(M, 20, target = parent))
		return
	on_obj_examine(source, M)

/datum/component/art/rev

/datum/component/art/rev/apply_moodlet(mob/M, impress)
	M.visible_message("<span class='notice'>[M] stops to inspect [parent].</span>", \
						 "<span class='notice'>You take in [parent], inspecting the fine craftsmanship of the proletariat.</span>")

	if(M.mind && M.mind.has_antag_datum(/datum/antagonist/rev))
		SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "artgreat", /datum/mood_event/artgreat)
	else
		SEND_SIGNAL(M, COMSIG_ADD_MOOD_EVENT, "artbad", /datum/mood_event/artbad)
