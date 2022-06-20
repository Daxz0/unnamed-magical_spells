#?PUSHBACK------------------------------------------------------------
spell_pushback:
    type: task
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
    definitions: loc
    script:
    - repeat 3:
        - playeffect effect:REDSTONE at:<[loc].points_around_y[radius=<[value].div[2]>;points=<[value].mul[20]>]> offset:0 visibility:100 special_data:1|WHITE
        - wait 2t
#?DRIFT------------------------------------------------------------------
spell_drift:
    type: task
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
    definitions: entityls|effectmultiplier|casttype
    script:
    - if <[casttype]> == wand:
        - define distance <[entityls].location.distance[<player.eye_location>]>
        - playeffect effect:REDSTONE at:<player.eye_location.forward[<[distance]>].points_between[<player.eye_location.right[0.5].forward[0.5]>].distance[0.1]> offset:0 visibility:100 special_data:1|WHITE
        - playsound <[entityls].location> sound:entity_generic_explode pitch:2 volume:1a0
        - playsound <player> sound:entity_lightning_bolt_impact pitch:0.8 volume:10
        - playsound <player> sound:block_bell_use pitch:2 volume:100
    - hurt <[entityls]> <element[10].mul[<[effectmultiplier]>]> source:<player>
#?AEGIS------------------------------------------------------------------
spell_aegis:
    type: task
    definitions: casttype
    script:
    - if <player.flag[magic.mana]> >= 10:
        - if <[casttype]> == orb:
            - flag <player> magic.mana:-:10
            - flag <player> magic.defense:+:10
#?HONSUMAKI------------------------------------------------------------------
spell_honsumaki:
    type: task
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
    - hurt <[effectloc].find_entities.within[4].exclude[<player>]> 20
#?KAMU------------------------------------------------------------------
spell_kamu:
    type: task
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
    events:
        on player damaged flagged:magic.spells.kamu.noDamage:
        - determine passively cancelled
        - ratelimit <player> 10t
        - flag player magic.bypass.damageEvent expire:3s
        - flag player magic.spells.kamu.absorb:+:<context.damage.proc[md_proc]>

#?REGRESS------------------------------------------------------------------
spell_regress:
    type: task
    definitions: casttype
    script:
    - define tar <player.precise_target[15].if_null[null]>
    - if <player.is_on_ground> && <[tar]> != null:
        - adjust <player> gravity:false
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
        - look <player> <[tar].eye_location>
#?JIZU------------------------------------------------------------------
spell_jizu:
    type: task
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
    - hurt <[entityls]> <player.health.div[5].mul[4]>
#?VINDICT------------------------------------------------------------------
spell_vindict:
    type: task
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
        - hurt <[b].find_entities.within[1].exclude[<player>]> <[damage]>
        - playeffect at:<[b]> effect:redstone visibility:100 special_data:1|<color[0,255,0]> quantity:50 offset:0.3,0.3,0.3
        - playeffect at:<[b]> effect:redstone visibility:100 special_data:1|<color[150,255,150]> quantity:50 offset:0.3,0.3,0.3

spell_vindict_eventListener:
    type: world
    events:
        on player damaged flagged:magic.spells.vindict.damageTrack:
        - flag player magic.spells.vindict.damageTrack:+:<context.damage.proc[md_proc]>

#?SHEBU------------------------------------------------------------------
spell_shebu:
    type: task
    definitions: entityls|casttype
    script:
    - define circ <player.location.points_around_y[radius=6;points=36]>
    - repeat 2:
        - foreach <[circ]> as:b:
            - playeffect at:<[b]> effect:redstone special_data:1|<color[48,25,52]> quantity:50 offset:0.3,0.3,0.3
            - wait 1t
        - wait 10t
    - playeffect at:<[circ]> effect:redstone special_data:1|<color[48,25,52]> quantity:50 offset:0.3,0.3,0.3
    - foreach <[entityls]> as:m:
        - define mshell <location[0,0,0,<player.world.name>].to_ellipsoid[2,1.7,2].shell.parse[mul[0.3].add[<[m].location.xyz>]]>
        - cast slow no_ambient no_icon hide_particles duration:15s amplifier:3
        - cast weakness no_ambient no_icon hide_particles duration:15s amplifier:3
        - repeat 5:
            - playeffect at:<[mshell]> effect:redstone special_data:1|<color[48,25,52]> quantity:50 offset:0.3,0.3,0.3
            - playeffect at:<[circ]> effect:redstone special_data:1|<color[48,25,52]> quantity:50 offset:0.3,0.3,0.3
            - wait 10t