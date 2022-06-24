lib_rotate_around:
    type: procedure
    debug: false
    definitions: center|size|percent
    script:
        - determine <[center].left[<util.tau.mul[<[percent]>].cos.mul[<[size]>]>].up[<util.tau.mul[<[percent]>].sin.mul[<[size]>]>]>