PREFABS.Decor_urban_mall_light_island_1 =
{
  file = "decor/gtd_decor_urban_mall_set.wad",
  map = "MAP01",

  prob = 5000,

  where = "point",

  size = 64,
  height = 96,

  group = "gtd_shopping_mall",

  bound_z1 = 0,
  bound_z2 = 96,

  thing_85 =
  {
    [85] = 2, [43] = 1, [0] = 0.5
  }
}

PREFABS.Decor_urban_mall_light_island_2 =
{
  template = "Decor_urban_mall_light_island_1",
  map = "MAP02",

  size = 80
}

PREFABS.Decor_urban_mall_island_with_seats =
{
  template = "Decor_urban_mall_light_island_1",
  map = "MAP03",

  prob = 3000,

  size = 80,

  tex_SHAWN1 = "SHAWN2"
}

PREFABS.Decor_urban_mall_island_with_seats_EPIC =
{
  template = "Decor_urban_mall_light_island_1",
  map = "MAP03",

  replaces = "Decor_urban_mall_light_island_1",

  texture_pack = "armaetus",

  prob = 3000,

  size = 80,

  tex_SHAWN1 =
  {
    SHAWN2 = 10,

    -- square ads only!
    ADVCR3 = 5,
    ADVCR5 = 5,
    ADVDE4 = 5,
    ADVDE6 = 5,

    O_BOLT = 3,
    O_RELIEF = 3,
    O_CARVE = 3
  }
}

PREFABS.Decor_urban_mall_light_fountain =
{
  template = "Decor_urban_mall_light_island_1",
  map = "MAP04",

  size = 128
}
