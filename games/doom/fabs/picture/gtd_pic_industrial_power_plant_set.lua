PREFABS.Pic_gtd_power_plant =
{
  file = "picture/gtd_pic_industrial_power_plant_set.wad",
  map = "MAP01",

  prob = 50,
  group = "gtd_power_plant_set",

  where  = "seeds",
  height = 128,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 128,

  x_fit = { 100,156 },
  y_fit = "top",
  z_fit = "top",

  sector_1 =
  {
    [0] = 8,
    [12] = 1,
    [21] = 1
  }
}

--

PREFABS.Pic_gtd_power_plant_red =
{
  template = "Pic_gtd_power_plant",
  map = "MAP02",

  group = "gtd_power_plant_red_set",

  x_fit = { 20,24 , 232,236 },
  z_fit = { 58,108 }
}

PREFABS.Pic_gtd_power_plant_red_3x =
{
  template = "Pic_gtd_power_plant",
  map = "MAP03",

  seed_w = 3,

  group = "gtd_power_plant_red_set",

  x_fit = { 20,24 , 360,364 },
  z_fit = { 58,108 }
}
