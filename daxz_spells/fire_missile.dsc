# fire_missile_item:
#     type: item
#     material: fire_charge
#     display name: <&c>Fire Missile
#     lore:
#     - <&9>500s CD
#     - <&e>500 <&6>Spark
#     - <&b>
#     - <&7>Summons a missile on your cursor.
#     - <&8>[Right-Click] to activate

# fire_missile_trigger:
#     type: world
#     debug: false
#     events:
#         on player right clicks block with:fire_missile_item:
#         - determine passively cancelled
#         - run fire_missile

# # fire_missile:
# #     type: task
# #     debug: true
# #     speed: 0
# #     script:
# #     - define 2pi <util.pi.mul[2]>
# #     - define cast_location <player.eye_location.forward[20].with_yaw[90].with_pitch[0]>
# #     - define first_point <player.eye_location.forward[10].with_yaw[90].with_pitch[0]>
# #     - define vector <[first_point].sub[<[cast_location]>]>
# #     - define point_list <list>
# #     - repeat 10:
# #         - define point_location <[vector].forward[<[value].add[5]>]>
# #         - define point_list <[point_list].include[<[cast_location].add[<[point_location]>]>]>
# #     - repeat 2:
# #         - foreach <[point_list]>:
# #             - playeffect effect:flame at:<[value]> visibility:50 quantity:5 velocity:<[cast_location].sub[<[value]>].normalize>
# #             - hurt 30 <[value].find_entities.within[2]>
# #         - wait 5t



# Vorpal_Vacuum_Charging_Particles:
#     type: task
#     debug: true
#     speed: 0
#     script:
#     - define 2pi <util.pi.mul[2]>
#     - define cast_location <player.location.with_yaw[90].with_pitch[0]>
#     - define first_point <player.location.forward[10].up[2].with_yaw[90].with_pitch[0]>
#     - define vector <[first_point].sub[<[cast_location]>]>
#     - define point_list <list>
#     - repeat 10:
#         - define point_location <[vector].rotate_around_y[<[2pi].div[10].mul[<[value]>]>]>
#         - define point_list <[point_list].include[<[cast_location].add[<[point_location]>]>]>
#     - repeat 2:
#         - foreach <[point_list]>:
#             - playeffect effect:flame at:<[value]> visibility:50 quantity:3 velocity:<[cast_location].sub[<[value]>].normalize>
#         - wait 5t