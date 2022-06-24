    # good_denizzle_going_to_heaven:
    # type: task
    # debug: false
    # script:
    #     - define halo_color <color[255,255,0]>
    #     - while <player.has_flag[good_denizzle]> && <player.is_online>:
    #         - define pitch <player.location.pitch.to_radians>
    #         - define yaw <player.location.yaw.mul[-1].to_radians>
    #         - define loc <player.eye_location.below[0.2]>
    #         - playeffect effect:redstone at:<[loc].add[<[angle]>]> offset:0 special_data:0.5|<[halo_color]>
    #         - if <[loop_index].mod[4]> == 0:
    #             - wait 1t
    #     - flag player good_denizzle:!