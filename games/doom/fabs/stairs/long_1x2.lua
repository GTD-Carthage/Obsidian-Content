--
-- long narrow stair, 2 seeds high
--

PREFABS.Stair_long_1x2 =
{
  file   = "stairs/long_1x2.wad",

  prob   = 100,
  prob_skew = 5,

  

  theme  = "!hell",
  map    = "MAP01",

  where  = "seeds",
  shape  = "I",

  seed_h = 2,

  x_fit  = "stretch",

  bound_z1 = 0,
  bound_z2 = 64,

  delta_h = 64,

  tex_STEP6 = { STEP6=50, STEP2=50, STEP3=50, STEP5=50 },
  tex_BROWN1 = { BROWN1=50, BROWNGRN=50, BROWN96=50, BROWNHUG=50 },

}

PREFABS.Stair_long_1x2_tech2 =
{
  template   = "Stair_long_1x2",

  theme  = "tech",
  map    = "MAP01",

  tex_STEP6 = { STEP6=50, STEP4=50, STEP3=50, STEP5=50 },
  tex_BROWN1 = "METAL1",
  flat_FLOOR7_1 = { FLOOR4_8=50, FLOOR5_1=50 },
}

PREFABS.Stair_long_1x2_tech3 =
{
  template   = "Stair_long_1x2",

  theme  = "tech",
  map    = "MAP01",

  tex_STEP6 = "STEP4",
  tex_BROWN1 = { STARGR1=50, STARGR2=50, STARG3=50 },
  flat_FLOOR7_1 = { FLAT20=50, FLAT23=50 },
}

PREFABS.Stair_long_1x2_general =
{
  template   = "Stair_long_1x2",

  theme  = "!hell",
  map    = "MAP01",

  tex_STEP6 = "STEP4",
  tex_BROWN1 = { STONE=50, GRAY7=50 },
  flat_FLOOR7_1 = { FLAT19=50, FLAT5_4=50 },
}

PREFABS.Stair_long_1x2_general2 =
{
  template   = "Stair_long_1x2",

  theme  = "!hell",
  map    = "MAP01",

  tex_STEP6 = "STEP4",
  tex_BROWN1 = { STONE2=50, STONE3=30 },
  flat_FLOOR7_1 = "FLAT1",
}

PREFABS.Stair_long_1x2_hell1 =
{
  template = "Stair_long_1x2",

  theme  = "hell",
  prob   = 100,
  map    = "MAP02",

  tex_STEP6 = "MARBGRAY",
  tex_MARBLE1 = "MARBGRAY",
  flat_FLOOR7_1 = "FLOOR7_2",
}

PREFABS.Stair_long_1x2_hell2 =
{
  template = "Stair_long_1x2",

  theme  = "hell",
  prob   = 100,
  map    = "MAP02",

  tex_STEP6 = "MARBLE1",
  flat_FLOOR7_1 = "DEM1_6",
}

PREFABS.Stair_long_1x2_hell3 =
{
  template = "Stair_long_1x2",

  theme  = "hell",
  prob   = 100,
  map    = "MAP02",

  tex_STEP6 = "METAL",
  tex_MARBLE1 = "METAL",
  flat_FLOOR7_1 = "CEIL5_2",
}
