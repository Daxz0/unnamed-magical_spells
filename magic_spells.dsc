#?PUSHBACK------------------------------------------------------------
spell_pushback:
    type: task
    debug: false
    definitions: entityls|effectmultiplier
    script:
    - foreach <[entityls]> as:entity:
        - define entityloc <[entity].location>
        - define loc <player.location.points_between[<[entityloc]>].get[-2]>
        - define floc <[loc].sub[<[entityloc]>].mul[<[effectmultiplier]>]>
        - adjust <[entity]> velocity:<[floc].x.mul[-1]>,0.5,<[floc].z.mul[-1]>
        - run pushback_effect def.loc:<[entityloc]>
        - playsound <[entityloc]> sound:entity_generic_explode pitch:2
        - playsound <[entityloc]> sound:entity_experience_orb_pickup pitch:<list[0.5|1|0.75].random>

pushback_effect:
    type: task
    debug: false
    definitions: loc
    script:
    - repeat 3:
        - playeffect effect:REDSTONE at:<[loc].points_around_y[radius=<[value].div[2]>;points=<[value].mul[20]>]> offset:0 visibility:100 special_data:1|WHITE
        - wait 2t
#?DRIFT------------------------------------------------------------------
spell_drift:
    type: task
    debug: false
    script:
    - playsound <player> sound:entity_zombie_villager_converted volume:100 pitch:1.1
    - cast <player> levitation amplifier:10 d:2t
    - wait 2t
    - cast <player> levitation amplifier:255 d:110t volume:100
    - wait 10t
    - adjust <player> vision:ENDERMAN
    - repeat 50:
        - playeffect effect:redstone at:<player.location> offset:0.5,0.2,0.5 quantity:10 special_data:2|<color[45,4,92]>
        - wait 2t
    - adjust <player> vision
    - playsound <player> sound:entity_zombie_villager_converted volume:100 pitch:1
#?DECEIT------------------------------------------------------------------
spell_deceit:
    type: task
    debug: false
    definitions: entityls|effectmultiplier|casttype
    script:
    - if <[casttype]> == wand:
        - define distance <[entityls].location.distance[<player.eye_location>]>
        - playeffect effect:REDSTONE at:<player.eye_location.forward[<[distance]>].points_between[<player.eye_location.right[0.5].forward[0.5]>].distance[0.1]> offset:0 visibility:100 special_data:1|WHITE
        - playsound <[entityls].location> sound:entity_generic_explode pitch:2 volume:1a0
        - playsound <player> sound:entity_lightning_bolt_impact pitch:0.8 volume:10
        - playsound <player> sound:block_bell_use pitch:2 volume:100
    - hurt <[entityls]> <element[<proc[mm_proc].context[<player.flag[magic.mana.capacity]>|10|0|<[effectmultiplier]>]>]> source:<player>
#?AEGIS------------------------------------------------------------------
spell_aegis:
    type: task
    debug: false
    definitions: casttype
    script:
    - if <player.flag[magic.mana.value]> >= 10:
        - if <[casttype]> == orb:
            - flag <player> magic.mana.value:-:10
            - flag <player> magic.defense:+:10
            - playsound sound:entity_iron_golem_hurt pitch:0.9 <player.location>
#?HONSUMAKI------------------------------------------------------------------
spell_honsumaki:
    type: task
    debug: false
    definitions: entityls
    script:
    - define effectloc <[entityls].location.up[0.5]>
    - define circ <[effectloc].points_around_y[radius=3;points=20]>
    - playsound <player> sound:ENTITY_ZOMBIE_VILLAGER_CONVERTED pitch:0.5
    - repeat 40:
        - define val <[value]>
        - if <[val]> > 20:
            - define val <[value].sub[20]>
        - playsound sound:entity_blaze_shoot <[entityls].location> pitch:0.5 volume:0.5
        - define pos <[circ].get[<[val]>].up[<[value].div[4]>]>
        - playeffect effect:flame at:<[pos]> offset:0.1,0.1,0.1 quantity:4 visibility:100
        - adjust <[entityls]> velocity:0,0.2,0
        - wait 1t
    - playeffect effect:explosion_large at:<[entityls].location> visibility:100 offset:0
    - playsound <[entityls].location> sound:entity_generic_explode volume:0.7
    - wait 18t
    - playeffect effect:explosion_large at:<[effectloc]> visibility:100 offset:1,1,1 quantity:5
    - playsound <[entityls].location> sound:entity_generic_explode volume:1 pitch:0.5
    - hurt <[effectloc].find_entities.within[4].exclude[<player>]> <element[<proc[mm_proc].context[<player.flag[magic.mana.capacity]>|20|0|1]>]>
#?KAMU------------------------------------------------------------------
spell_kamu:
    type: task
    debug: false
    definitions: casttype
    script:
    - if <[casttype]> == orb:
        - flag player magic.spells.kamu.noDamage expire:3s
        - repeat 12:
            - playeffect at:<player.location.points_around_y[radius=1.5;points=30].parse_tag[<[parse_value].points_between[<[parse_value].up[2]>].distance[0.5]>].combine> effect:BUBBLE_POP offset:0 quantity:2
            - wait 5t
        - wait 2t
        - playeffect effect:damage_indicator at:<player.location.up[0.5]> offset:0.2,0.2,0.2 quantity:15 visibility:100
        - hurt <player.flag[magic.spells.kamu.absorb]>
        - flag player magic.spells.kamu.absorb:!
spell_kamu_eventListener:
    type: world
    debug: false
    events:
        on player damaged flagged:magic.spells.kamu.noDamage:
        - determine passively cancelled
        - ratelimit <player> 10t
        - flag player magic.bypass.damageEvent expire:3s
        - flag player magic.spells.kamu.absorb:+:<context.damage.proc[md_proc]>

#?REGRESS------------------------------------------------------------------
spell_regress:
    type: task
    debug: false
    definitions: casttype
    script:
    - define tar <player.precise_target[15].if_null[null]>
    - if <player.is_on_ground> && <[tar]> != null:
        - playsound <player> sound:entity_zombie_villager_converted volume:100 pitch:1.1
        - adjust <player> gravity:false
        - adjust <player> vision:ENDERMAN
        - playsound sound:BLOCK_PORTAL_TRIGGER <player.location> pitch:1.5
        - repeat 3:
            - playeffect effect:REDSTONE at:<location[0,0,0,<player.world.name>].to_ellipsoid[5,1.5,5].shell.parse[mul[0.3].add[<player.location.below[0.1].xyz>]]> offset:0.2,0.2,0.2 visibility:100 special_data:1|<color[45,4,92]> quantity:5
            - playeffect effect:REDSTONE at:<location[0,0,0,<player.world.name>].to_ellipsoid[5,1.5,5].shell.parse[mul[0.3].add[<player.location.below[0.1].xyz>]]> offset:0.3,0.2,0.3 visibility:100 special_data:1|<color[0,0,0]> quantity:20
            - teleport <player.location.below[0.5]>
            - wait 10t
        - teleport <[tar].location.forward[-1].below[1.5].with_yaw[-90].with_pitch[0]>
        - repeat 2:
            - playeffect effect:REDSTONE at:<location[0,0,0,<player.world.name>].to_ellipsoid[5,1.5,5].shell.parse[mul[0.3].add[<[tar].location.forward[-1].below[0.1].with_yaw[-90].with_pitch[0].xyz>]]> offset:0.2,0.2,0.2 visibility:100 special_data:1|<color[45,4,92]> quantity:5
            - playeffect effect:REDSTONE at:<location[0,0,0,<player.world.name>].to_ellipsoid[5,1.5,5].shell.parse[mul[0.3].add[<[tar].location.forward[-1].below[0.1].with_yaw[-90].with_pitch[0].xyz>]]> offset:0.3,0.2,0.3 visibility:100 special_data:1|<color[0,0,0]> quantity:20
            - teleport <player.location.above[0.5]>
            - look <player> <[tar].eye_location>
            - wait 10t
        - teleport <player.location.above[0.5]>
        - adjust <player> gravity:true
        - adjust <player> vision
        - look <player> <[tar].eye_location>
#?JIZU------------------------------------------------------------------
spell_jizu:
    type: task
    debug: false
    definitions: entityls|casttype
    script:
    - define loc <player.location.up[0.5]>
    - define circ <[loc].points_around_y[radius=1;points=25]>
    - foreach <[circ]> as:point:
        - playeffect effect:heart at:<[point].up[<[loop_index].div[25]>]> offset:0 visibility:100
        - playsound <player> sound:block_beacon_activate pitch:<[loop_index].div[25].add[1]>
        - wait 1t
    - foreach <[circ].get[last].up[1].points_between[<[entityls].eye_location>].distance[1]> as:point:
        - playeffect effect:heart at:<[point]> offset:0 visibility:100
        - wait 1t
    - hurt <player> <player.health.div[5]>
    - playeffect effect:damage_indicator at:<player.location.up[0.5]> offset:0.2,0.2,0.2 quantity:15 visibility:100
    - playeffect effect:damage_indicator at:<[entityls].location.up[0.5]> offset:0.2,0.2,0.2 quantity:15 visibility:100
    - hurt <[entityls]> <proc[mm_proc].context[<player.flag[magic.mana.capacity]>|<player.health.div[5].mul[4]>|0|1]>
#?VINDICT------------------------------------------------------------------
spell_vindict:
    type: task
    debug: false
    definitions: casttype
    script:
    - flag player magic.spells.vindict.damageTrack:0
    - repeat 5:
        - playeffect effect:REDSTONE at:<player.location.up[0.85].points_around_x[radius=2;points=8]> offset:0.3,0.3,0.3 visibility:100 special_data:1|<color[0,255,0]> quantity:50
        - playeffect effect:REDSTONE at:<player.location.up[0.85].points_around_x[radius=2;points=8]> offset:0.5,0.5,0.5 visibility:100 special_data:1|<color[180,255,0]> quantity:50
        - playsound sound:BLOCK_ANVIL_LAND <player.location> pitch:0.5
        - wait 1s
    - define damage <player.flag[magic.spells.vindict.damageTrack].mul[1.5]>
    - flag player magic.spells.vindict.damageTrack:!
    - define points <player.eye_location.forward[1].with_yaw[90].points_between[<player.eye_location.forward[10].with_yaw[90]>].distance[0.1]>
    - playsound sound:entity_generic_explode <player.location> volume:1
    - foreach <[points]> as:b:
        - hurt <[b].find_entities.within[1].exclude[<player>]> <element[<proc[mm_proc].context[<player.flag[magic.mana.capacity]>|<[damage]>|0|1]>]>
        - playeffect at:<[b]> effect:redstone visibility:100 special_data:1|<color[0,255,0]> quantity:50 offset:0.3,0.3,0.3
        - playeffect at:<[b]> effect:redstone visibility:100 special_data:1|<color[150,255,150]> quantity:50 offset:0.3,0.3,0.3

spell_vindict_eventListener:
    type: world
    debug: false
    events:
        on player damaged flagged:magic.spells.vindict.damageTrack:
        - flag player magic.spells.vindict.damageTrack:+:<context.damage.proc[md_proc]>

#?SHEBU------------------------------------------------------------------
spell_shebu:
    type: task
    debug: false
    definitions: entityls|casttype
    script:
    - define loc <player.location>
    - define circ <player.location.points_around_y[radius=3;points=6]>
    - repeat 3:
        - foreach <[circ]> as:b:
            - playeffect at:<[b]> effect:redstone special_data:1|<color[48,25,52]> quantity:500 offset:3,0.3,3 visibility:100
            - wait 1t
        - wait 1t
    - playeffect at:<[circ]> effect:redstone special_data:1|<color[48,25,52]> quantity:500 offset:3,0.3,3 visibility:100
    - repeat 5:
        - playeffect at:<[circ]> effect:redstone special_data:1|<color[48,25,52]> quantity:500 offset:3,0.3,3 visibility:100
        - foreach <[loc].find_entities.within[6].exclude[<player>]> as:m:
            - cast slow no_ambient no_icon hide_particles duration:15s amplifier:3
            - cast weakness no_ambient no_icon hide_particles duration:15s amplifier:3
        - wait 10t

#?KAIHI------------------------------------------------------------------
spell_kaihi:
    type: task
    definitions: casttype
    debug: false
    script:
    - playsound <player> sound:entity_zombie_villager_converted volume:100 pitch:1.1
    - adjust <player> velocity:<player.location.with_pitch[0].with_yaw[90].direction.vector.mul[-1]>
    - repeat 3:
            - playeffect effect:REDSTONE at:<location[0,0,0,<player.world.name>].to_ellipsoid[1,5,5].shell.parse[mul[0.3].add[<player.location.up[1.2].forward[-2].with_yaw[-90].xyz>]]> offset:0.2,0.2,0.2 visibility:100 special_data:1|<color[45,4,92]> quantity:5
            - playeffect effect:REDSTONE at:<location[0,0,0,<player.world.name>].to_ellipsoid[3,3,3].shell.parse[mul[0.3].add[<player.location.up[1.2].forward[-2].with_yaw[-90].xyz>]]> offset:0.3,0.2,0.3 visibility:100 special_data:1|<color[0,0,0]> quantity:20
            - wait 1t
    - wait 3t
    - adjust <player> vision:ENDERMAN
    - cast INVISIBILITY amplifier:255 duration:15t no_ambient no_icon hide_particles
    - wait 3t
    - adjust <player> velocity:0,0,0
    - teleport <player.location.backward[4].up[0.8].with_yaw[90]>
    - repeat 3:
            - playeffect effect:REDSTONE at:<location[0,0,0,<player.world.name>].to_ellipsoid[1,5,5].shell.parse[mul[0.3].add[<player.location.up[0.8].with_yaw[-90].xyz>]]> offset:0.2,0.2,0.2 visibility:100 special_data:1|<color[45,4,92]> quantity:5
            - playeffect effect:REDSTONE at:<location[0,0,0,<player.world.name>].to_ellipsoid[3,3,3].shell.parse[mul[0.3].add[<player.location.up[0.8].with_yaw[-90].xyz>]]> offset:0.3,0.2,0.3 visibility:100 special_data:1|<color[0,0,0]> quantity:20
            - wait 1t
    - adjust <player> vision
    - adjust <player> velocity:<player.location.with_pitch[0].with_yaw[90].direction.vector.mul[-0.3]>
    - playsound <player> sound:entity_zombie_villager_converted volume:100 pitch:1

#?SAIGO------------------------------------------------------------------
spell_saigo:
    type: task
    definitions: casttype
    debug: true
    script:
    - define loc <player.location>
    - define 2pi <util.pi.mul[2]>
    - define cast_location <player.location.with_yaw[90].with_pitch[0]>
    - define first_point <player.location.forward[10].up[2].with_yaw[90].with_pitch[0]>
    - define vector <[first_point].sub[<[cast_location]>]>
    - define point_list <list>
    - playsound <player> sound:entity_zombie_villager_converted volume:100 pitch:1.1
    - cast invisibility amplifier:255 duration:1.5s no_ambient no_icon hide_particles
    - cast speed amplifier:5 duration:2s no_ambient no_icon hide_particles
    - adjust <player> vision:ENDERMAN
    - create player <player.name> save:npc
    - spawn <entry[npc].created_npc> <[loc]> target:<player.target.if_null[<empty>]>
    - wait 1s
    - repeat 10:
        - define point_location <[vector].rotate_around_y[<[2pi].div[10].mul[<[value]>]>]>
        - define point_list <[point_list].include[<[cast_location].add[<[point_location]>]>]>
    - repeat 2:
        - foreach <[point_list]>:
            - playeffect effect:cloud at:<[value]> visibility:50 quantity:3 velocity:<[cast_location].sub[<[value]>].normalize>
        - wait 5t
    - adjust <player> vision
    - remove <entry[npc].created_npc>
    - explode <[loc]> power:5 source:<player>
    - hurt <proc[mm_proc].context[<player.flag[magic.mana.capacity]>|30|0|1]> <[loc].find_entities.within[5].exclude[<player>]>

#?Kureiji------------------------------------------------------------------
spell_kureiji:
    type: task
    definitions: casttype
    script:
        - define rand <util.random.int[1].to[6]>
        - choose <[rand]>:
            - case 1:
                - define ability Desaisu
                - define loc <player.location.up[0.8]>
                - rotate <player> duration:10t frequency:1t yaw:20 pitch:0
                - wait 7t
                - if !<player.is_sneaking>:
                    - define damage1 <proc[mm_proc].context[<player.flag[magic.mana.capacity]>|35|0|1]>
                    - define damage <proc[mm_proc].context[<player.flag[magic.mana.capacity]>|15|0|1]>
                    - repeat 180:
                        - define angle <location[3,0.8,3].rotate_around_y[<[value].to_radians.mul[82]>]>
                        - playeffect effect:redstone at:<[loc].add[<[angle]>]> offset:0 special_data:2|<&color[#301934]>
                    - hurt <[damage1]> <[loc].find_entities.within[3].exclude[<player>]>
                    - wait 15t
                    - repeat 180:
                        - define angle <location[5,0.8,5].rotate_around_y[<[value].to_radians.mul[82]>]>
                        - playeffect effect:redstone at:<[loc].add[<[angle]>]> offset:0 special_data:5|<&color[#000000]>
                    - hurt <[damage]> <[loc].find_entities.within[5].exclude[<player>]>

                - else:
                    - define damage <proc[mm_proc].context[<player.flag[magic.mana.capacity]>|30|0|1]>
                    - repeat 180:
                        - define angle <location[5,0.8,5].rotate_around_y[<[value].to_radians.mul[82]>]>
                        - playeffect effect:redstone at:<[loc].add[<[angle]>]> offset:0 special_data:5|<&color[#301934]>
                        - hurt <[damage]> <[loc].find_entities.within[5].exclude[<player>]>
            - case 2:
                - define ability Desuika
                - define loc <player.location.above[3]>
                - define elist <[loc].find_entities.within[15]>
                - repeat 10:
                    - playeffect squid_ink at:<[loc]> offset:1,1,1 quantity:100
                    - wait 1t
                - foreach <[elist].exclude[<player>]> as:e:
                    - cast blindness duration:10s amplifier:100 hide_particles no_ambient no_icon <[e]>
                    - hurt <proc[mm_proc].context[<player.flag[magic.mana.capacity]>|10|0|1]> <[e]>
                    - repeat 100:
                        - playeffect at:<[loc]> effect:squid_ink velocity:<[loc].sub[<[e].location.above[1]>].mul[-1].normalize> offset:0.3,0.3,0.3 quantity:30
            - case 3:
                - define ability Sutonbu
                - define loc <player.location>
                - repeat 30:
                    - define angle <location[3,0.8,3].rotate_around_y[<[value].to_radians.mul[82]>]>
                    - define point:->:<[loc].add[<[angle]>]>
                - repeat 3:
                    - foreach <[point]> as:p:
                        - playeffect at:<[loc]> effect:squid_ink velocity:<[p].sub[<[loc]>].mul[1].normalize> offset:0 quantity:1
                    - define elist <[loc].find_entities.within[5].exclude[<player>]>
                    - cast blindness duration:10s amplifier:100 hide_particles no_ambient no_icon <[elist]>
                    - hurt <proc[mm_proc].context[<player.flag[magic.mana.capacity]>|20|0|1]> <[elist]>
                    - playsound sound:entity_generic_explode <player.location> volume:1.3
                    - wait 15t
            - case 4:
                - define ability Yadamaku
                - define elist <player.location.find_entities.within[10].exclude[<player>]>
                - define loc <player.eye_location>
                - foreach <[elist]> as:e:
                    - flag <player> magic.spells.kureiji.yadamaku.souls:+:1
                    - define points:->:<[e].eye_location.points_between[<[loc].above[0.8]>]>
                - foreach <[points]> as:p:
                    - playeffect at:<[p]> effect:redstone offset:0 special_data:2|#FFFF00 offset:0
                    - wait 1s
                - flag <player> magic.handler.damageModifier:<player.flag[magic.spells.kureiji.yadamaku.souls].mul[1.5]> expire:10s
                - flag <player> magic.spells.kureiji.yadamaku.souls:!
            - case 5:
                #light room
                - define ability Rakku
                - define target <player.location.find_entities.within[10].exclude[<player>].first.if_null[null]>
                - define temp <player.location.above[0.8]>
                - if <[target]> == null:
                    - stop
                - playsound sound:block_beacon_activate pitch:1.3 <player.location> volume:1.3
                - flag player magic.walk
                - wait 1.3s
                - if <[target].location.distance[<player.location>]> > 10:
                    - flag player magic.walk:!
                    - stop
                - cast invisiblity <player> amplifier:255 duration:9999999 no_ambient no_icon no_icon hide_particles
                - foreach <[temp].points_between[<[target].location.above[0.8]>].distance[0.1]> as:p:
                    - playeffect at:<[p]> effect:redstone offset:0 special_data:2|#FFFF00
                    - if <[loop_index].mod[20]> == 0:
                        - wait 1t
                - wait 1t
                - flag player magic.walk:!
                - cast remove invisibility <player>
                - teleport <player> <[target].location>
                - hurt <[target]> <proc[mm_proc].context[<player.flag[magic.mana.capacity]>|45|0|1]>
                - playsound sound:entity_generic_explode <player.location> volume:1.3
            - case 6:
                #light weaving
                - define ability Uradeba
                - define possible_points <player.location.find_blocks.within[8]>
                - define counter 0
                - while <[counter]> < 15:
                    - define point_1 <[possible_points].random>
                    - define point_2 <[possible_points].random>
                    - if <[point_1].distance[<[point_2]>]> > 10:
                        - define counter <[counter].add[1]>
                        - playeffect effect:redstone offset:0 special_data:2|#FFFF00 at:<[point_1].points_between[<[point_2]>].distance[0.1]> offset:0
                        - foreach <[point_1].points_between[<[point_2]>].distance[0.1]> as:a:
                            - hurt <[a].find_entities.within[0.5].exclude[<player>]> <proc[mm_proc].context[<player.flag[magic.mana.capacity]>|15|0|1]>

#?Mirasha------------------------------------------------------------------


