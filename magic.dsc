example_gui:
    type: inventory
    debug: false
    gui: true
    inventory: chest
    title: <&f><&font[examplepack:gui]>-c=<white>Spell Selector
    slots:
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [stick] [] [] [] []
    - [] [stone] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []
    - [] [] [] [] [] [] [] [] []

custom_block:
    type: task
    script:
        - modifyblock <player.cursor_on> barrier
        - spawn item_frame[direction=up] <player.cursor_on> save:lel
        - adjust <entry[lel].spawned_entity> framed:wooden_sword[custom_model_data=1]
        - adjust <entry[lel].spawned_entity> fixed:true

spell_selector:
    type: task
    script:
        - definemap spell_pushback:
            level: 1
            current_xp: 0
            max_xp: 100

spell_effect:
    type: task
    script:
        - while <player.has_flag[magic.selected_spell]>:
            - playeffect <player.eye_location.forward[0.3].right[0.3].down[1]> effect:REDSTONE offset:0 visibility:3 quantity:3 special_data:0.5|WHITE
            - wait 1t

staff:
    type: item
    material: stone_shovel
    display name: <gray><bold>Staff
    flags:
        magic:
            effectmultiplier: 0.5

wand:
    type: item
    material: stick
    display name: <gray><bold>Wand
    mechanisms:
        custom_model_data: 1
    flags:
        magic:
            effectmultiplier: 1

magic_orb:
    type: item
    material: slime_ball
    display name: <gray><bold>Orb

staffevent:
    type: world
    events:
        after player left clicks block with:staff:
            - run spell_pushback def.entityls:<player.location.find_entities[!player].within[10]> def.effectmultiplier:<context.item.flag[magic.effectmultiplier]> def.casttype:staff
        after player left clicks block with:wand:
            - if <player.has_flag[magic.selected_spell]>:
                - define spell <player.flag[magic.selected_spell.script_name]>
                - define entity <player.precise_target[30]||null>
                - if <[entity]> != null:
                    - foreach <player.eye_location.right[0.5].forward[0.5].points_between[<player.eye_location.forward[<[entity].location.distance[<player.location>]>]>].distance[1]> as:pos:
                        - playeffect effect:fireworks_spark at:<[pos]> visibility:100 offset:0
                        - wait 1t
                    - run <[spell]> def.entityls:<[entity]> def.effectmultiplier:<context.item.flag[magic.effectmultiplier]> def.casttype:wand
                    - flag <player> magic.selected_spell:!
                    - inventory adjust custom_model_data:1 slot:<player.held_item_slot>
            - else:
                - narrate "<red>You dont have a spell selected!"
        after player right clicks block with:wand:
            - flag <player> magic.selected_spell:<player.flag[magic.learned_spells.HONSUMAKI]>
            - inventory adjust custom_model_data:2 slot:<player.held_item_slot>
            - playsound <player> sound:entity_experience_orb_pickup
        on player left clicks block with:magic_orb:
            - determine passively cancelled
            - if <player.has_flag[magic.selected_spell]>:
                - define spell <player.flag[magic.selected_spell.script_name]>
                - run <[spell]> casttype:orb
                - flag <player> magic.selected_spell:!
            - else:
                - narrate "<red>You dont have a spell selected!"
        on player right clicks block with:magic_orb:
            - determine passively cancelled
            - flag <player> magic.selected_spell:<player.flag[magic.learned_spells.DRIFT]>
            - playsound <player> sound:entity_experience_orb_pickup

magicdefense:
    type: world
    debug: false
    events:
        after delta time secondly:
            - repeat 2:
                - run actionbar_update
                - wait 10t
        on player damaged:
            - if <player.has_flag[magic.defense]> && <player.flag[magic.defense]> > 0:
                - define finaldmg <context.damage.sub[<context.damage.mul[<player.flag[magic.defense].mul[2.5].div[100]>]>]>
                - determine <[finaldmg]>
        after player damaged:
            - if <player.has_flag[magic.defense]> && <player.flag[magic.defense]> > 0:
                - flag <player> magic.defense:-:<context.damage.round>
                - if <player.flag[magic.defense]> < 0:
                    - flag <player> magic.defense:0

spell_book:
    type: world
    events:
        after player right clicks block:
            - if <context.item.has_flag[magic.is_book]>:
                - flag <player> magic.learned_spells.<context.item.flag[magic.spell_to_learn.name]>:<context.item.flag[magic.spell_to_learn]>

actionbar_update:
    type: task
    debug: false
    script:
    - foreach <server.online_players_flagged[magic.defense]> as:serverplayer:
        - if <[serverplayer].armor_bonus> > 0:
            - if <[serverplayer].flag[magic.defense].is_even> && <[serverplayer].flag[magic.defense]> <= 20:
                - define defelement <element[a-].repeat[<[serverplayer].flag[magic.defense].div[2]>]><element[c-].repeat[<element[10].sub[<[serverplayer].flag[magic.defense].div[2]>]>]>
            - else if <[serverplayer].flag[magic.defense]> > 20:
                - define defelement <element[a-].repeat[10]>
            - else:
                - define defelement <element[a-].repeat[<[serverplayer].flag[magic.defense].div[2].round_down>]>b-<element[c-].repeat[<element[10].sub[<[serverplayer].flag[magic.defense].div[2].round_up>]>]>
        - else:
            - if <[serverplayer].flag[magic.defense].is_even> && <[serverplayer].flag[magic.defense]> <= 20:
                - define defelement <element[d-].repeat[<[serverplayer].flag[magic.defense].div[2]>]><element[f-].repeat[<element[10].sub[<[serverplayer].flag[magic.defense].div[2]>]>]>
            - else if <[serverplayer].flag[magic.defense]> > 20:
                - define defelement <element[d-].repeat[10]>
            - else:
                - define defelement <element[d-].repeat[<[serverplayer].flag[magic.defense].div[2].round_down>]>e-<element[f-].repeat[<element[10].sub[<[serverplayer].flag[magic.defense].div[2].round_up>]>]>
        - actionbar <&font[examplepack:taskbar]>-<[defelement]><&font[examplepack:gui]>__<&font[examplepack:taskbar]>-<element[j-].repeat[10]> targets:<[serverplayer]> per_player