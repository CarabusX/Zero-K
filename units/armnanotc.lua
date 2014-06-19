unitDef = {
  unitname                      = [[armnanotc]],
  name                          = [[Caretaker]],
  description                   = [[Nanoturret, Builds at 10 m/s]],
  acceleration                  = 0,
  brakeRate                     = 1.5,
  buildCostEnergy               = 220,
  buildCostMetal                = 220,
  buildDistance                 = 500,
  builder                       = true,
  buildingGroundDecalDecaySpeed = 30,
  buildingGroundDecalSizeX      = 5,
  buildingGroundDecalSizeY      = 5,
  buildingGroundDecalType       = [[armnanotc_aoplane.dds]],

  buildoptions                  = {
  },

  buildPic                      = [[armnanotc.png]],
  buildTime                     = 220,
  canGuard                      = true,
  canMove                       = false,
  canPatrol                     = true,
  canreclamate                  = [[1]],
  canstop                       = [[1]],
  cantBeTransported             = true,
  category                      = [[FLOAT UNARMED]],
  collisionVolumeOffsets        = [[0 0 0]],
  collisionVolumeScales         = [[48 48 48]],
  collisionVolumeTest           = 1,
  collisionVolumeType           = [[ellipsoid]],
  corpse                        = [[DEAD]],

  customParams                  = {
    description_de = [[Nanoturm, Baut mit 10 M/s]],
    description_pl = [[Wie�a Konstrukcyjna, moc 10 m/s]],
    helptext       = [[The most cost-effective source of buildpower, the Caretaker is ideal for increasing the output of factories or automatically repairing nearby defenses. It cannot start any construction projects itself, however.]],
    helptext_de    = [[Die effektivste Quelle an Baukraft: der Caretake ist ideal, um die Produktionsrate von Fabriken zu erh�hen oder nahegelegene Verteidigungsanlagen zu reparieren. Der Caretaker kann aber selbst keine neuen Bauten beginnen.]],
    helptext_pl    = [[Mimo �e Caretaker nie jest w stanie samemu porusza� si� ani rozpoczyna� nowych bud�w, �wietnie spisuje si� pomagaj�c okolicznym budowniczym i fabrykom, naprawiaj�c jednostki lub nawet zbieraj�c z�om.]],
    aimposoffset   = [[0 0 0]],
    midposoffset   = [[0 -4 0]],
    modelradius    = [[24]],
  },

  defaultmissiontype            = [[Standby]],
  energyMake                    = 0.3,
  explodeAs                     = [[NANOBOOM2]],
  floater                       = true,
  footprintX                    = 3,
  footprintZ                    = 3,
  iconType                      = [[staticbuilder]],
  idleAutoHeal                  = 5,
  idleTime                      = 1800,
  levelGround                   = false,
  maneuverleashlength           = [[380]],
  mass                          = 100000,
  maxDamage                     = 500,
  maxSlope                      = 15,
  maxVelocity                   = 0,
  metalMake                     = 0.3,
  minCloakDistance              = 150,
  movementClass                 = [[KBOT1]],
  moveState                     = 1,
  noAutoFire                    = false,
  objectName                    = [[armsenan.s3o]],
  script                        = [[armnanotc.lua]],
  seismicSignature              = 4,
  selfDestructAs                = [[NANOBOOM2]],
  showNanoSpray                 = false,
  side                          = [[ARM]],
  sightDistance                 = 380,
  smoothAnim                    = true,
  steeringmode                  = [[1]],
  TEDClass                      = [[CNSTR]],
  terraformSpeed                = 600,
  turnRate                      = 1,
  upright                       = true,
  useBuildingGroundDecal        = true,
  workerTime                    = 10,

  featureDefs                   = {

    DEAD = {
      description      = [[Wreckage - Caretaker]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 500,
      energy           = 0,
      featureDead      = [[HEAP]],
      featurereclamate = [[SMUDGE01]],
      footprintX       = 4,
      footprintZ       = 4,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 88,
      object           = [[debris4x4a.s3o]],
      reclaimable      = true,
      reclaimTime      = 88,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },


    HEAP = {
      description      = [[Debris - Caretaker]],
      blocking         = false,
      category         = [[heaps]],
      damage           = 500,
      energy           = 0,
      featurereclamate = [[SMUDGE01]],
      footprintX       = 4,
      footprintZ       = 4,
      height           = [[4]],
      hitdensity       = [[100]],
      metal            = 44,
      object           = [[debris4x4a.s3o]],
      reclaimable      = true,
      reclaimTime      = 44,
      seqnamereclamate = [[TREE1RECLAMATE]],
      world            = [[All Worlds]],
    },

  },

}

return lowerkeys({ armnanotc = unitDef })
