eruption_item:
    type: item
    material: fire_charge
    display name: <&c>Eruption
    lore:
    - <&9>30s CD
    - <&e>150 <&6>Spark
    - <&b>
    - <&7>Creates a fiery eruption on your cursor.
    - <&8>[Right-Click] to activate

eruption_trigger:
    type: world
    debug: false
    events:
        on player right clicks block with:eruption_item:
        - determine passively cancelled
        - ratelimit <player> 30s
        - define loc <player.cursor_on[30].above[1]>
        - define circle <[loc].points_around_y[radius=4;points=16]>
        - playeffect at:<[circle]> effect:flame quantity:50 offset:0
        - playeffect at:<[circle]> effect:smoke_large quantity:50 offset:0
        - wait 1s
        - repeat 3:
            - playeffect at:<[loc].above[2]> effect:flame offset:1.6,1.6,1.6 quantity:150
            - playeffect at:<[loc].above[2]> effect:smoke_large offset:1.6,1.6,1.6 quantity:150
            - playsound sound:entity_generic_explode <[loc]> volume:2 pitch:0.8
            - playsound sound:entity_generic_explode <[loc]> volume:2
            - hurt 15 <[loc].find_entities.within[4]> source:<player>
            - wait 0.5s