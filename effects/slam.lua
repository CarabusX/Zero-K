-- slam
-- slam_sparks_smokejets
-- slam_flash
-- slam_ray
-- slam_heat_pillar
-- slam_landcloud
-- slam_landcloud_ring
-- slam_landcloud_topcap
-- slam_landcloud_cap
-- slam_landcloud_pillar
-- slam_landcloud_topsuction
-- slam_seacloud
-- slam_seacloud_topcap
-- slam_seacloud_ring
-- slam_seacloud_cap
-- slam_seacloud_pillar
-- slam_water_droplets
-- slam_water_pillar
-- slam_trail
-- slam_muzzle
-- slam_air_scrap
-- slam_air_scrap_fragments
-- slam_air_scrap_particles


-- slam_flash from gundam_xamelimpact (heavily modified)
-- slam_sparks_smokejets from klara (maybe unmodified)
-- slam_seacloud & slam_landcloud stuff from nuke_150 (heavily modified)
-- slam_water_droplets from nuke_150 (modified) 
-- slam_trail from cruisetrail (modified)
-- slam_water_pillar from torpedo_hit_main_large (more growth)
-- slam_ray and slam_heat_pillar from galiblow.lua

return {

  ["slam"] = {
    sboom = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = [[0 i1]],
        explosiongenerator = [[custom:SLAM_SPARKS_SMOKEJETS]],
        pos                = [[0, 0,  0]],
      },
    },
    sflash = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = [[0]],
        explosiongenerator = [[custom:SLAM_FLASH]],
        pos                = [[0, 0, 0]],
      },
    },
    sray = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = [[0]],
        explosiongenerator = [[custom:SLAM_RAY]],
        pos                = [[0, 0, 0]],
        dir                = [[dir]],
      },
    },
    slandcloud = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 1,
      ground             = true,
      properties = {
        delay              = 4,
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_LANDCLOUD]],
        pos                = [[0, 0, 0]],
      },
    },

    sseacloud = {
      class              = [[CExpGenSpawner]],
      count              = 1,
      underwater         = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = 0.5,
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_SEACLOUD]],
        pos                = [[0, 0, 0]],
      },
    },
    swaterdroplets = {
      class              = [[CExpGenSpawner]],
      count              = 1,
      underwater         = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = 0,
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_WATER_DROPLETS]],
        pos                = [[0, 0, 0]],
      },
    },
    swaterpillar = {
      class              = [[CExpGenSpawner]],
      count              = 1,
      water              = true,
      underwater		 = true,
      properties = {
        delay              = 0,
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_WATER_PILLAR]],
        pos                = [[0, 0, 0]],
      },
    },

    sheatpillar = {
      class              = [[CExpGenSpawner]],
      count              = 32,
      water              = true,
      underwater		 = true,
      ground             = true,
      air                = true,
      properties = {
        delay              = [[i0.25]],
        dir                = [[-0.1 r0.2, 1 -0.1 r0.2, -0.1 r0.2]],
        explosiongenerator = [[custom:SLAM_HEAT_PILLAR]],
        pos                = [[-4 r8, 0, r32]],
      },
    },
    --~ sairrubble = {
      --~ class              = [[CExpGenSpawner]],
      --~ count              = 4,
      --~ air                = true,
      --~ --ground             = true,
      --~ properties = {
        --~ delay              = [[0]],
        --~ dir                = [[dir]],
        --~ explosiongenerator = [[custom:SLAM_AIR_RUBBLE]],
        --~ pos                = [[-3 r6, -3 r6, -3 r6]],
      --~ },
    --~ },
    sairscrap = {
      class              = [[CExpGenSpawner]],
      count              = 8,
      air                = true,
      --ground             = true,
      properties = {
        delay              = [[0]],
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_AIR_SCRAP]],
        pos                = [[-30 r60, 0, -30 r60]],
      },
    },
    --~ sairdust = {
      --~ class              = [[CExpGenSpawner]],
      --~ count              = 1,
      --~ air                = true,
      --~ --ground             = true,
      --~ properties = {
        --~ delay              = [[0]],
        --~ dir                = [[dir]],
        --~ explosiongenerator = [[custom:SLAM_AIR_DUST]],
        --~ pos                = [[0, 0, 0]],
      --~ },
    --~ },

    
  },

   ["slam_air_scrap"] = {
    usedefaultexplosions = false,
    particles = {
      air                = true,
      --ground             = true,
      class              = [[CExpGenSpawner]],
      count              = 1,
      properties = {
        delay              = [[0]],
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_AIR_SCRAP_PARTICLES]],
        pos                = [[0, 0, 0]],
      },
    },
    fragments = {
      air                = true,
      --ground             = true,
      class              = [[CExpGenSpawner]],
      count              = 1,
      properties = {
        delay              = [[0]],
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_AIR_SCRAP_FRAGMENTS]],
        pos                = [[-3 r6, -3 r6, -3 r6]],
      },
    },

  },
   ["slam_seacloud"] = {
    usedefaultexplosions = false,
    --~ cap = {
      --~ air                = true,
      --~ class              = [[CExpGenSpawner]],
      --~ count              = 1,
      --~ ground             = true,
      --~ water              = true,
      --~ underwater         = true,
	  --~ underwater		 = true,
      --~ properties = {
        --~ delay              = 1.5,
        --~ dir                = [[dir]],
        --~ explosiongenerator = [[custom:SLAM_SEACLOUD_CAP]],
        --~ pos                = [[0, 108, 0]],
      --~ },
    --~ },
    pillar = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 4,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = [[i2]],
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_SEACLOUD_PILLAR]],
        pos                = [[0, i32, 0]],
      },
    },
    ring = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        delay              = 16,
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_SEACLOUD_RING]],
        pos                = [[0, 48, 0]],
      },
    },
    topcap = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 24,
      ground             = true,
      water              = true,
      
      underwater		 = true,
      properties = {
        delay              = [[12 i0.083333]],
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_SEACLOUD_TOPCAP]],
        pos                = [[0, 96 i0.083333, 0]],
      },
    },

  },



  ["slam_landcloud"] = {
    usedefaultexplosions = false,
    cap = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 12,
      ground             = true,
      water              = true,
      properties = {
        delay              = [[i0.5]],
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_LANDCLOUD_CAP]],
        pos                = [[0, i8, 0]],
      },
    },
    pillar = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 16,
      ground             = true,
      water              = true,
      properties = {
        delay              = [[i1.5]],
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_LANDCLOUD_PILLAR]],
        pos                = [[0, i8, 0]],
      },
    },
    ring = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        delay              = 12,
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_LANDCLOUD_RING]],
        pos                = [[0, 80, 0]],
      },
    },
    topcap = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 16,
      ground             = true,
      water              = true,
      properties = {
        delay              = [[6 i0.5]],
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_LANDCLOUD_TOPCAP]],
        pos                = [[0, 96 i2, 0]],
      },
    },

    topsuction = {
      air                = true,
      class              = [[CExpGenSpawner]],
      count              = 9,
      ground             = true,
      water              = true,
      properties = {
        delay              = [[a0 r5 y0 a0 24 i1.5]],
        dir                = [[dir]],
        explosiongenerator = [[custom:SLAM_TOPSUCTION]],
        pos                = [[0, 104, 0]],
      },
    },
  },

    ["slam_landcloud_ring"] = {
    land = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.93,
        alwaysvisible      = true,
        colormap           = [[0 0 0 0  1 1 0.75 1  0.8 0.75 0.7 0.8  0.6 0.565 0.55 0.6  0 0 0 0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.05, 0]],
        numparticles       = 40,
        particlelife       = 75,
        particlelifespread = 5,
        particlesize       = 6,
        particlesizespread = 12,
        particlespeed      = 6,
        particlespeedspread = 0,
        pos                = [[0, 0, 0]],
        sizegrowth         = 9,
        sizemod            = 0.7,
        texture            = [[smokesmall]],
      },
    },
  },

  ["slam_landcloud_topcap"] = {
    land = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.93,
        alwaysvisible      = true,
        colormap           = [[0 0 0 0  1 0.75 0.5 0.5  1 0.75 0.0 0.4  0.1 0.0 0.0 0.25  0 0 0 0.01]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.2, 0]],
        numparticles       = 5,
        particlelife       = 60,
        particlelifespread = 5,
        particlesize       = 12,
        particlesizespread = 40,
        particlespeed      = 1,
        particlespeedspread = 5,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[fireball]],
      },
    },
  },

  ["slam_landcloud_cap"] = {
    land = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0 0 0 0  1 0.75 0.5 1  1 0.75 0.5 0.75  0.75 0.50 0.50 0.5  0 0 0 0.01]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.2, 0]],
        numparticles       = 4,
        particlelife       = 15,
        particlelifespread = 5,
        particlesize       = 2,
        particlesizespread = 2,
        particlespeed      = 4,
        particlespeedspread = 4,
        pos                = [[0, 0, 0]],
        sizegrowth         = 12,
        sizemod            = 0.6,
        texture            = [[fireball]],
      },
    },
  },

  ["slam_seacloud_topcap"] = {
    cloud = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater		 = true,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0 0 0 0  1.0 0.8 0.6 0.8  1.0 1.0 0.8 0.7  0.8 0.8 1 0.6  0 0 0 0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.2, 0]],
        numparticles       = 1,
        particlelife       = 50,
        particlelifespread = 10,
        particlesize       = 8,
        particlesizespread = 48,
        particlespeed      = 1,
        particlespeedspread = 4,
        pos                = [[r16 r-16, r16 r-16, r16 r-16]],
        sizegrowth         = -0.5,
        sizemod            = 1,
        texture            = [[smokesmall]],
      },
    },
  },

  ["slam_seacloud_ring"] = {
    cloud = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater		 = true,
      properties = {
        airdrag            = 0.95,
        alwaysvisible      = true,
        colormap           = [[0 0 0 0  1.0 1.0 0.8 0.1  1 1 0.8 0.08  0.8 1 1 0.04  0 0 0 0.001]],
        directional        = false,
        emitrot            = 70,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.05, 0]],
        numparticles       = 24,
        particlelife       = 50,
        particlelifespread = 10,
        particlesize       = 9,
        particlesizespread = 9,
        particlespeed      = 6,
        particlespeedspread = 1,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0.25,
        sizemod            = 1,
        texture            = [[smokesmall]],
      },
    },
  },

  ["slam_seacloud_cap"] = {
    cloud = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater		 = true,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0 0 0 0  0.8 0.8 1 0.5  0.8 0.8 1 0.4  0.8 0.8 1 0.25  0 0 0 0]],
        directional        = false,
        emitrot            = 90,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.2, 0]],
        numparticles       = 4,
        particlelife       = 15,
        particlelifespread = 5,
        particlesize       = 6,
        particlesizespread = 12,
        particlespeed      = 4,
        particlespeedspread = 4,
        pos                =  [[r16 r-16, r16 r-16, r16 r-16]],
        sizegrowth         = 12,
        sizemod            = 0.6,
        texture            = [[smokesmall]],
      },
    },
  },

  ["slam_seacloud_pillar"] = {
    cloud = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater		 = true,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0 0 0 0  1.0 1.0 0.8 0.5  0.8 0.8 1 0.4  0.8 0.8 1 0.25  0 0 0 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 90,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.2, 0]],
        numparticles       = 1,
        particlelife       = 40,
        particlelifespread = 10,
        particlesize       = 2,
        particlesizespread = 2,
        particlespeed      = 1,
        particlespeedspread = 1,
        pos                = [[0, 0, 0]],
        sizegrowth         = 6,
        sizemod            = 0.925,
        texture            = [[smokesmall]],
      },
    },
  },

  ["slam_landcloud_pillar"] = {
    land = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.9,
        alwaysvisible      = true,
        colormap           = [[0 0 0 0   1 1 1 0.04   0.75 0.6 0.45 0.02  0.1 0.1 0 0.01  0.1 0 0 0.001]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 90,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.2, 0]],
        numparticles       = 1,
        particlelife       = 45,
        particlelifespread = 10,
        particlesize       = 256,
        particlesizespread = 64,
        particlespeed      = 1,
        particlespeedspread = 1,
        pos                = [[0, 0, 0]],
        sizegrowth         = 24,
        sizemod            = 0.5,
        texture            = [[smokesmall]],
      },
    },
  },


  ["slam_topsuction"] = {
    land = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.5,
        alwaysvisible      = true,
        colormap           = [[0 0 0 0   1 1 1 0.04   0.75 0.6 0.45 0.02  0.1 0.1 0 0.01  0.1 0 0 0.001]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.2, 0]],
        numparticles       = 1,
        particlelife       = 15,
        particlelifespread = 0,
        particlesize       = 96,
        particlesizespread = 256,
        particlespeed      = 27,
        particlespeedspread = 4,
        pos                = [[r32 r-32, r16 r-16, r32 r-32]],
        sizegrowth         = 32,
        sizemod            = 0.25,
        texture            = [[smokesmall]],
      },
    },
  },


  ["slam_sparks_smokejets"] = {
    intense_center1 = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 20,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysVisible      = true,
        airdrag            = 1,
        colormap           = [[1 0.6 0 0.1    1.0 0.7 0.4 1    0.05 0.05 0.05 0.1]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 10,
        emitvector         = [[0.5, 1, 0.5]],
        gravity            = [[0.015 i-0.0015, -0.3 i+0.015,0.015 i-0.0015]],
        numparticles       = 1,
        particlelife       = [[50 i-0.5]],
        particlelifespread = 0,
        particlesize       = [[10 i0.8]],
        particlesizespread = 0,
        particlespeed      = [[5 i-0.25]],
        particlespeedspread = 2,
        pos                = [[0, 0, 0]],
        sizegrowth         = [[-0.1 i0.015]],
        sizemod            = 1.0,
        texture            = [[smokesmall]],
      },
    },
    intense_center2 = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 20,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysVisible      = true,
        airdrag            = 1,
        colormap           = [[1 0.6 0 0.1    1.0 0.7 0.4 1    0.05 0.05 0.05 0.1]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 10,
        emitvector         = [[-0.8, 1, -0.2]],
        gravity            = [[-0.024 i+0.0024, -0.3 i+0.015,-0.006 i+0.0006]],
        numparticles       = 1,
        particlelife       = [[50 i-0.5]],
        particlelifespread = 0,
        particlesize       = [[10 i0.8]],
        particlesizespread = 0,
        particlespeed      = [[5 i-0.25]],
        particlespeedspread = 2,
        pos                = [[0, 0, 0]],
        sizegrowth         = [[-0.1 i0.015]],
        sizemod            = 1.0,
        texture            = [[smokesmall]],
      },
    },
    intense_center3 = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 20,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysVisible      = true,
        airdrag            = 1,
        colormap           = [[1 0.6 0 0.1    1.0 0.7 0.4 1    0.05 0.05 0.05 0.1]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 10,
        emitvector         = [[0.2, 1, -0.8]],
        gravity            = [[0.006 i-0.0006, -0.3 i+0.015,-0.024 i+0.0024]],
        numparticles       = 1,
        particlelife       = [[50 i-0.5]],
        particlelifespread = 0,
        particlesize       = [[10 i0.8]],
        particlesizespread = 0,
        particlespeed      = [[5 i-0.25]],
        particlespeedspread = 2,
        pos                = [[0, 0, 0]],
        sizegrowth         = [[-0.1 i0.015]],
        sizemod            = 1.0,
        texture            = [[smokesmall]],
      },
    },
    star1 = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 5,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysVisible      = true,
        airdrag            = 1,
        colormap           = [[1 0.7 0.3 0.01    1 0.7 0.3 0.01    0.5 0.35 0.15 0.01    0.05 0.05 0.05 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 10,
        emitvector         = [[0.5, 1, 0.5]],
        gravity            = [[0.015 i-0.0015, -0.3 i+0.015,0.015 i-0.0015]],
        numparticles       = 2,
        particlelife       = [[50 i-0.5]],
        particlelifespread = 0,
        particlesize       = [[10 i0.8]],
        particlesizespread = 0,
        particlespeed      = [[5 i-0.25]],
        particlespeedspread = 2,
        pos                = [[0, 0, 0]],
        sizegrowth         = [[-0.1 i0.015]],
        sizemod            = 1.0,
        texture            = [[plasma]],
      },
    },
    star2 = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 5,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysVisible      = true,
        airdrag            = 1,
        colormap           = [[1 0.7 0.3 0.01    1 0.7 0.3 0.01    0.5 0.35 0.15 0.01    0.05 0.05 0.05 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 10,
        emitvector         = [[-0.8, 1, -0.2]],
        gravity            = [[-0.024 i+0.0024, -0.3 i+0.015,-0.006 i+0.0006]],
        numparticles       = 2,
        particlelife       = [[50 i-0.5]],
        particlelifespread = 0,
        particlesize       = [[10 i0.8]],
        particlesizespread = 0,
        particlespeed      = [[5 i-0.25]],
        particlespeedspread = 2,
        pos                = [[0, 0, 0]],
        sizegrowth         = [[-0.1 i0.015]],
        sizemod            = 1.0,
        texture            = [[plasma]],
      },
    },
    star3 = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 7,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysVisible      = true,
        airdrag            = 1,
        colormap           = [[1 0.7 0.3 0.01    1 0.7 0.3 0.01    0.5 0.35 0.15 0.01    0.05 0.05 0.05 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 10,
        emitvector         = [[0.2, 1, -0.8]],
        gravity            = [[0.006 i-0.0006, -0.3 i+0.015,-0.024 i+0.0024]],
        numparticles       = 2,
        particlelife       = [[50 i-0.5]],
        particlelifespread = 0,
        particlesize       = [[10 i0.8]],
        particlesizespread = 0,
        particlespeed      = [[5 i-0.25]],
        particlespeedspread = 2,
        pos                = [[0, 0, 0]],
        sizegrowth         = [[-0.1 i0.015]],
        sizemod            = 1.0,
        texture            = [[plasma]],
      },
    },
  },




  ["slam_flash"] = {
    dirtg = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        airdrag            = 0.875,
        alwaysvisible      = true,
        colormap           = [[1.0 0.75 0.0 0.0 	0.0 0.075 0.1 0.75		0.0 0.075 0.1 0.4    0.0 0.0 0.0 0.01]],
        directional        = false,
        emitrot            = 80,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0.2, 0]],
        numparticles       = 30,
        particlelife       = 10,
        particlelifespread = 6,
        particlesize       = 30,
        particlesizespread = 15,
        particlespeed      = 10,
        particlespeedspread = 6,
        pos                = [[0, 5, 0]],
        sizegrowth         = -2.5,
        sizemod            = 1,
        texture            = [[dirt]],
      },
    },
    groundflash = {
      air                = true,
      alwaysvisible      = true,
      circlealpha        = 0.0,
      circlegrowth       = 0,
      flashalpha         = 0.9,
      flashsize          = 85,
      ground             = true,
      ttl                = 13,
      water              = true,
	  underwater		 = true,
      color = {
        [1]  = 1,
        [2]  = 0.5,
        [3]  = 0,
      },
    },
    poof1 = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater		 = true,
      properties = {
        airdrag            = 0.05,
        alwaysvisible      = true,
        colormap           = [[0.9 0.8 0.7 0.03	0.9 0.2 0.2 0.01]],
        directional        = true,
        emitrot            = 0,
        emitrotspread      = 50,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, 0, 0]],
        numparticles       = 20,
        particlelife       = 4,
        particlelifespread = 4,
        particlesize       = 10,
        particlesizespread = 0,
        particlespeed      = 25,
        particlespeedspread = 75,
        pos                = [[0, 2, 0]],
        sizegrowth         = 10,
        sizemod            = 1,
        texture            = [[flashside2]],
        useairlos          = false,
      },
    },
    shock1 = {
      air                = true,
      class              = [[CSpherePartSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater		 = true,
      properties = {
        alwaysVisible      = true,
        alpha = 0.02,
        ttl = 64,
        expansionSpeed = 5,
        color = [[1, 0.75, 0]],
      },
    },
    shock2 = {
      air                = true,
      class              = [[CSpherePartSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater		 = true,
      properties = {
        alwaysVisible      = true,
        alpha = 0.02,
        ttl = 32,
        expansionSpeed = 10,
        color = [[1, 0.75, 0]],
      },
    },
        shock3 = {
      air                = true,
      class              = [[CSpherePartSpawner]],
      count              = 1,
      ground             = true,
      water              = true,
	  underwater		 = true,
      properties = {
        alwaysVisible      = true,
        alpha = 0.02,
        ttl = 16,
        expansionSpeed = 20,
        color = [[1, 0.75, 0]],
      },
    },
    pop1 = {
      air                = true,
      class              = [[heatcloud]],
      count              = 16,
      ground             = true,
      water              = true,
	  underwater		 = true,
      properties = {
        alwaysvisible      = true,
        heat               = 375,
        heatfalloff        = 10,
        maxheat            = 5000,
        pos                = [[r35 r-35, 35 r-20, r60 r-60]],
        size               = 300,
        sizegrowth         = -1,
        speed              = [[0, 0, 0]],
        texture            = [[flare]],
      },
    },
    heatglow = {
      class              = [[CSimpleGroundFlash]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysVisible      = true,
        colorMap           = [[1 0.9 0.8 1.0	1 0.4 0 0.9		0.0 0.0 0.0 0.01]],
        size               = 110,
        sizegrowth         = -0.025, 
        texture            = [[groundflash]],
        ttl                = 125,
      },

    },
  },

  ["slam_ray"] = {

      gravspike1 = {
      air                = true,
      class              = [[CExploSpikeProjectile]],
      count              = 3,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysVisible      = true,
        length 				= 250,
        width					= 50,
        alpha					= 0.375,
        alphaDecay 			= 0.012,
        dir 					= [[dir]],
        color 				= [[1, 0.4, 0]],
        pos                = [[10 r-20, 0, 10 r-20]],
      },
    },
  },

    ["slam_water_pillar"] = {
    mainhit = {
      class              = [[CBitmapMuzzleFlame]],
      count              = 4,
      water              = true,
	  underwater		 = true,
      properties = {
        alwaysVisible      = true,
        colormap           = [[0.45 0.45 0.5 0.5  0.045 0.045 0.05 0.05]],
        dir                = [[-0.1 r0.2, 1, -0.1 r0.2]],
        frontoffset        = 0,
        fronttexture       = [[splashbase]],
        length             = [[48 r32]],
        sidetexture        = [[splashside]],
        size               = [[12 r8]],
        sizegrowth         = 1.8,
        ttl                = 24,
      },
    },
  },  

  ["slam_water_droplets"] = {
      watermist = {
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      water              = true,
	  underwater		 = true,
      properties = {
        alwaysVisible      = true,
        airdrag            = 0.99,
        colormap           = [[0 0 0 0  1 1 0.8 0.1  0.8 1 1 0.075  0.8 1 1 0.025  0.8 1 1 0]],
        directional        = false,
        emitrot            = 30,
        emitrotspread      = 5,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.1, 0]],
        numparticles       = 48,
        particlelife       = 50,
        particlelifespread = 0,
        particlesize       = 5,
        particlesizespread = 15,
        particlespeed      = 6,
        particlespeedspread = 0,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[randdots]],
      },
    },
  },
  ["slam_air_scrap_particles"] = {
    scrap_particles = {
      air              = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      --ground             = true,
      properties = {
        alwaysVisible      = true,
        airdrag            = 0.989,
        colormap           = [[0.25 0.25 0.2 0.01  0.1 0.1 0.1 1  0.1 0.1 0.1 0.9  0.1 0.1 0.1 0.7  0.1 0.1 0.1 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.2, 0]],
        numparticles       = 1,
        particlelife       = 40,
        particlelifespread = 8,
        particlesize       = 16,
        particlesizespread = 0,
        particlespeed      = 0,
        particlespeedspread = 0,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[randdots]],
      },
    },
  },
  ["slam_air_scrap_fragments"] = {
    scrap_fragments = {
      air              = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      --ground             = true,
      properties = {
        alwaysVisible      = true,
        airdrag            = 0.99,
        colormap           = [[0.25 0.25 0.2 0  0.15 0.15 0.15 1  0.15 0.15 0.15 0.9  0.15 0.15 0.15 0.7  0.15 0.15 0.15 0]],
        directional        = false,
        emitrot            = 0,
        emitrotspread      = 0,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0, -0.2, 0]],
        numparticles       = 6,
        particlelife       = 50,
        particlelifespread = 10,
        particlesize       = 4,
        particlesizespread = 8,
        particlespeed      = 0,
        particlespeedspread = 0,
        pos                = [[0, 0, 0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[randdots]],
      },
    },
  },
  ["slam_trail"] = {
    alwaysvisible      = false,
    usedefaultexplosions = false,
    smoke_front = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.7,
        colormap           = [[0.6 0.5 0.25 0.4  0.3 0.3 0.25 0.6  0.0 0.0 0.0 0.01]],
        directional        = false,
        emitrot            = 7.5,
        emitrotspread      = 35,
        emitvector         = [[dir]],
        gravity            = [[0.05 r-0.1, 0.05 r-0.1, 0.05 r-0.1]],
        numparticles       = 2,
        particlelife       = 15,
        particlelifespread = 2,
        particlesize       = 7,
        particlesizespread = 8,
        particlespeed      = 1,
        particlespeedspread = 5,
        pos                = [[0, 1, 3]],
        sizegrowth         = 0.75,
        sizemod            = 1.0,
        texture            = [[smoke]],
      },
    },
  },

  ["slam_heat_pillar"] = {

      gravspike1 = {
      air                = true,
      class              = [[CExploSpikeProjectile]],
      count              = 1,
      ground             = true,
      water              = true,
      underwater         = true,
      properties = {
        alwaysVisible      = true,
        length 				= 70,
        width					= 105,
        alpha					= 0.1,
        alphaDecay 			= 0.001,
        dir 					= [[dir]],
        color 				= [[1, 0.4, 0]],
        pos                = [[0, 0, 0]],
      },
    },
  },
  ["slam_muzzle"] = {
    smoke = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      underwater         = 1,
      water              = true,
      properties = {
        airdrag            = 0.9,
        colormap           = [[0.2 0.2 0.15 0.4  0.3 0.3 0.25 0.6  0.0 0.0 0.0 0.01]],
        directional        = false,
        dir                = [[dir]],
        emitrot            = 15,
        emitrotspread      = 75,
        emitvector         = [[0, 1, 0]],
        gravity            = [[0.0, 0.01, 0.0]],
        numparticles       = 20,
        particlelife       = 25,
        particlelifespread = 10,
        particlesize       = 12,
        particlesizespread = 20,
        particlespeed      = 4,
        particlespeedspread = 0,
        pos                = [[0.0, 4, 0.0]],
        sizegrowth         = 0,
        sizemod            = 1,
        texture            = [[smoke]],
        useairlos          = true,
      },
    },
  },
}
