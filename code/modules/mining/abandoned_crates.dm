//Originally coded by ISaidNo, later modified by Kelenius. Ported from Baystation12.

/obj/structure/closet/crate/secure/loot
	name = "abandoned crate"
	desc = "What could be inside?"
	icon_state = "securecrate"
	integrity_failure = 0 //no breaking open the crate
	var/code = null
	var/lastattempt = null
	var/attempts = 10
	var/codelen = 4
	tamperproof = 90

/obj/structure/closet/crate/secure/loot/Initialize()
	. = ..()
	var/list/digits = list("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	code = ""
	for(var/i = 0, i < codelen, i++)
		var/dig = pick(digits)
		code += dig
		digits -= dig  //there are never matching digits in the answer

	var/loot = rand(1,100) //100 different crates with varying chances of spawning
	switch(loot)
		if(1 to 5) //5% chance
			new /obj/item/reagent_containers/food/drinks/bottle/rum(src)
			new /obj/item/reagent_containers/food/snacks/grown/ambrosia/deus(src)
			new /obj/item/reagent_containers/food/drinks/bottle/whiskey(src)
			new /obj/item/lighter(src)
		if(6 to 10)
			new /obj/item/bedsheet(src)
			new /obj/item/kitchen/knife(src)
			new /obj/item/wirecutters(src)
			new /obj/item/screwdriver(src)
			new /obj/item/weldingtool(src)
			new /obj/item/hatchet(src)
			new /obj/item/crowbar(src)
		if(11 to 15)
			new /obj/item/reagent_containers/glass/beaker/bluespace(src)
		if(16 to 20)
			new /obj/item/stack/ore/diamond(src, 10)
		if(21 to 25)
			for(var/i in 1 to 5)
				new /obj/item/poster/random_contraband(src)
		if(26 to 30)
			for(var/i in 1 to 3)
				new /obj/item/reagent_containers/glass/beaker/noreact(src)
		if(31 to 35)
			new /obj/item/seeds/ambrosia/gaia(src)
		if(36 to 40)
			new /obj/item/melee/baton(src)
		if(41 to 45)
			new /obj/item/clothing/under/shorts/red(src)
			new /obj/item/clothing/under/shorts/blue(src)
		if(46 to 50)
			new /obj/item/clothing/under/chameleon(src)
			for(var/i in 1 to 7)
				new /obj/item/clothing/neck/tie/horrible(src)
		if(51 to 52) // 2% chance
			new /obj/item/toy/balloon(src)
		if(53 to 54)
			new /obj/item/toy/balloon(src)
		if(55 to 56)
			var/newitem = pick(subtypesof(/obj/item/toy/prize))
			new newitem(src)
		if(57 to 58)
			new /obj/item/toy/syndicateballoon(src)
		if(59 to 60)
			new /obj/item/borg/upgrade/modkit/aoe/mobs(src)
			new /obj/item/clothing/suit/space(src)
			new /obj/item/clothing/head/helmet/space(src)
		if(61 to 62)
			for(var/i in 1 to 5)
				new /obj/item/clothing/head/simplekitty(src)
				new /obj/item/clothing/neck/petcollar(src)
		if(63 to 64)
			for(var/i in 1 to rand(4, 7))
				new /obj/effect/spawner/lootdrop/coin(src)
		if(65 to 66)
			new /obj/item/clothing/suit/ianshirt(src)
			new /obj/item/clothing/suit/hooded/ian_costume(src)
		if(67 to 68)
			for(var/i in 1 to rand(4, 7))
				var/newitem = pick(subtypesof(/obj/item/stock_parts) - /obj/item/stock_parts/subspace)
				new newitem(src)
		if(69 to 70)
			new /obj/item/stack/ore/bluespace_crystal(src, 5)
		if(71 to 72)
			new /obj/item/pickaxe/drill(src)
		if(73 to 74)
			new /obj/item/pickaxe/drill/jackhammer(src)
		if(75 to 76)
			new /obj/item/pickaxe/diamond(src)
		if(77 to 78)
			new /obj/item/pickaxe/drill/diamonddrill(src)
		if(79 to 80)
			new /obj/item/cane(src)
			new /obj/item/clothing/head/collectable/tophat(src)
		if(81 to 82)
			new /obj/item/gun/energy/plasmacutter(src)
		if(83 to 84)
			new /obj/item/toy/katana(src)
		if(85 to 86)
			new /obj/item/defibrillator/compact(src)
		if(87) //1% chance
			new /obj/item/weed_extract(src)
		if(88)
			new /obj/item/organ/brain(src)
		if(89)
			new /obj/item/organ/brain/alien(src)
		if(90)
			new /obj/item/organ/heart(src)
		if(91)
			new /obj/item/soulstone/anybody(src)
		if(92)
			new /obj/item/organ/heart(src)
		if(93)
			new /obj/item/dnainjector/xraymut(src)
		if(96)
			new /obj/item/hand_tele(src)
		if(97)
			new /obj/item/clothing/mask/balaclava
			new /obj/item/gun/ballistic/automatic/pistol(src)
		if(98)
			new /obj/item/organ/heart(src)
		if(99)
			new /obj/item/storage/belt/champion(src)
			new /obj/item/clothing/mask/luchador(src)
		if(100)
			new /obj/item/clothing/head/bearpelt(src)

/obj/structure/closet/crate/secure/loot/on_attack_hand(mob/user, act_intent = user.a_intent, unarmed_attack_flags)
	if(locked)
		to_chat(user, span_notice("The crate is locked with a Deca-code lock."))
		var/input = input(usr, "Enter [codelen] digits. All digits must be unique.", "Deca-Code Lock", "") as text
		if(user.canUseTopic(src, BE_CLOSE))
			var/list/sanitised = list()
			var/sanitycheck = TRUE
			var/char = ""
			var/length_input = length(input)
			for(var/i = 1, i <= length_input, i += length(char)) //put the guess into a list
				char = input[i]
				sanitised += text2num(char)
			for(var/i = 1, i <= length(sanitised) - 1, i++) //compare each digit in the guess to all those following it
				for(var/j = i + 1, j <= length(sanitised), j++)
					if(sanitised[i] == sanitised[j])
						sanitycheck = FALSE //if a digit is repeated, reject the input
			if(input == code)
				to_chat(user, span_notice("The crate unlocks!"))
				locked = FALSE
				cut_overlays()
				add_overlay("securecrateg")
				tamperproof = 0 // set explosion chance to zero, so we dont accidently hit it with a multitool and instantly die
			else if(!input || !sanitycheck || length(sanitised) != codelen)
				to_chat(user, span_notice("You leave the crate alone."))
			else
				to_chat(user, span_warning("A red light flashes."))
				lastattempt = input
				attempts--
				if(attempts == 0)
					boom(user)
	else
		return ..()

//this helps you not blow up so easily by overriding unlocking which results in an immediate boom.
/obj/structure/closet/crate/secure/loot/AltClick(mob/living/user)
	if(user.canUseTopic(src, BE_CLOSE))
		attack_hand(user)
		return TRUE

/obj/structure/closet/crate/secure/loot/attackby(obj/item/W, mob/user)
	if(locked)
		if(istype(W, /obj/item/multitool))
			to_chat(user, span_notice("DECA-CODE LOCK REPORT:"))
			if(attempts == 1)
				to_chat(user, span_warning("* Anti-Tamper Bomb will activate on next failed access attempt."))
			else
				to_chat(user, span_notice("* Anti-Tamper Bomb will activate after [attempts] failed access attempts."))
			if(lastattempt != null)
				var/bulls = 0 //right position, right number
				var/cows = 0 //wrong position but in the puzzle

				var/lastattempt_char = ""
				var/length_lastattempt = length(lastattempt)
				var/lastattempt_it = 1

				var/code_char = ""
				var/length_code = length(code)
				var/code_it = 1

				while(lastattempt_it <= length_lastattempt && code_it <= length_code) // Go through list and count matches
					lastattempt_char = lastattempt[lastattempt_it]
					code_char = code[code_it]
					if(lastattempt_char == code_char)
						++bulls
					else if(findtext(code, lastattempt_char))
						++cows

					lastattempt_it += length(lastattempt_char)
					code_it += length(code_char)

				to_chat(user, span_notice("Last code attempt, [lastattempt], had [bulls] correct digits at correct positions and [cows] correct digits at incorrect positions."))
			return
	return ..()

/obj/structure/closet/secure/loot/dive_into(mob/living/user)
	if(!locked)
		return ..()
	to_chat(user, span_notice("That seems like a stupid idea."))
	return FALSE

/obj/structure/closet/crate/secure/loot/emag_act(mob/user)
	. = SEND_SIGNAL(src, COMSIG_ATOM_EMAG_ACT)
	if(!locked)
		return
	boom(user)
	return TRUE

/obj/structure/closet/crate/secure/loot/togglelock(mob/user)
	if(locked)
		boom(user)
	else
		..()

/obj/structure/closet/crate/secure/loot/deconstruct(disassembled = TRUE)
	if(!locked && disassembled)
		return ..()
	boom()
