flamestorm_item:
    type: item
    material: fire_charge
    display name: <&c>Flamestorm
    lore:
    - <&9>180s CD
    - <&e>400 <&6>Spark
    - <&b>
    - <&7>Summons a <&c>Flamestorm<&7> on your cursor.
    - <&8>[Right-Click] to activate

play_sound_blaze_flamestorm:
    type: task
    definitions: loc|offset
    script:
    - playsound <[loc].add[<[offset]>]> sound:entity_blaze_shoot volume:4 pitch:1.3
    - wait 1s


test_task:
    type: task
    script:
        - define offset 1,0,0
        - define offset <[offset].add[1,0,0]>
        - narrate <[offset]>

flamestorm_trigger:
    type: world
    debug: false
    events:
        on player right clicks block with:flamestorm_item:
        - determine passively cancelled
        - ratelimit <player> 180s
        - define loc <player.cursor_on[50].above[1]>
        - define circle <[loc].points_around_y[radius=8;points=40]>
        - define offset <location[1,0,0]>
        - playeffect at:<[circle]> effect:flame quantity:50 offset:0 visibility:1000
        - playeffect at:<[circle]> effect:smoke_large quantity:50 offset:0 visibility:1000
        - wait 1.5s
        - repeat 60:
            - define offset <[offset].mul[1.1].add[0,1,0].rotate_around_y[<util.pi.div[8]>]>
            - playeffect at:<[loc].add[<[offset]>]> effect:flame offset:1,1,1 quantity:250 visibility:1000
            - ~run play_sound_blaze_flamestorm def:<[loc]>|<[offset]>
            - hurt 5 <[loc].find_entities.within[4]> source:<player>
            - wait 1t
