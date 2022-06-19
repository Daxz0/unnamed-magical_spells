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
    - playeffect effect:explosion_large at:<[effectloc]> visibility:100 offset:2,2,2 quantity:30
    - playsound <[entityls].location> sound:entity_generic_explode volume:1 pitch:0.5
    - hurt <[effectloc].find_entities.within[4].exclude[<player>]> 20
#?KAMU------------------------------------------------------------------
spell_kamu:
    type: task
    definitions: casttype
    script:
    - if <[casttype]> == orb:
        - flag player magic.spells.kamu.noDamage expire:3s
        - wait 3.1s
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
        - flag player magic.spells.regress.noDamage
        - flag player magic.bypass.damageEvent
        - repeat 3:
            - playeffect effect:REDSTONE at:<location[0,0,0,<player.world.name>].to_ellipsoid[5,1.5,5].shell.parse[mul[0.3].add[<player.location.below[0.1].xyz>]]> offset:0.2,0.2,0.2 visibility:100 special_data:1|<color[45,4,92]> quantity:5
            - playeffect effect:REDSTONE at:<location[0,0,0,<player.world.name>].to_ellipsoid[5,1.5,5].shell.parse[mul[0.3].add[<player.location.below[0.1].xyz>]]> offset:0.3,0.2,0.3 visibility:100 special_data:1|<color[0,0,0]> quantity:20
            - teleport <player.location.below[0.3]>
            - wait 10t
        - teleport <[tar].location.forward[-1].below[0.9].with_yaw[-90].with_pitch[0]>
        - repeat 3:
            - playeffect effect:REDSTONE at:<location[0,0,0,<player.world.name>].to_ellipsoid[5,1.5,5].shell.parse[mul[0.3].add[<[tar].location.forward[-1].below[0.1].with_yaw[-90].with_pitch[0].xyz>]]> offset:0.2,0.2,0.2 visibility:100 special_data:1|<color[45,4,92]> quantity:5
            - playeffect effect:REDSTONE at:<location[0,0,0,<player.world.name>].to_ellipsoid[5,1.5,5].shell.parse[mul[0.3].add[<[tar].location.forward[-1].below[0.1].with_yaw[-90].with_pitch[0].xyz>]]> offset:0.3,0.2,0.3 visibility:100 special_data:1|<color[0,0,0]> quantity:20
            - teleport <player.location.above[0.3]>
            - look <player> <[tar].eye_location>
            - wait 10t
        - teleport <player.location.above[1.1]>
        - look <player> <[tar].eye_location>
        - flag player magic.spells.regress.noDamage:!
        - flag player magic.bypass.damageEvent:!

spell_regress_eventListener:
    type: world
    events:
        on player damaged by SUFFOCATION flagged:magic.spells.regress.noDamage:
        - determine passively cancelled