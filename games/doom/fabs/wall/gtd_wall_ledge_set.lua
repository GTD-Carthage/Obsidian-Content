PREFABS.Wall_gtd_ledge_1 =
{
  file = "wall/gtd_wall_ledge_set.wad",
  map = "MAP01",

  prob = 16,

  group = "gtd_ledge_set",

  where = "edge",
  height = 96,
  deep = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_gtd_ledge_diag =
{
  template = "Wall_gtd_ledge_1",
  map = "MAP02",

  where = "diagonal"
}

PREFABS.Wall_gtd_ledge_alt =
{
  template = "Wall_gtd_ledge_1",
  map = "MAP03",

  rank = 1,
  group = "gtd_ledge_alt_set",

  height = 169,
  bound_z2 = 169
}

PREFABS.Wall_gtd_ledge_alt_diag =
{
  template = "Wall_gtd_ledge_1",
  map = "MAP04",

  rank = 1,
  group = "gtd_ledge_alt_set",

  where = "diagonal",

  height = 169,
  bound_z2 = 169
}

PREFABS.Wall_gtd_ledge_alt_low =
{
  template = "Wall_gtd_ledge_1",
  map = "MAP05",

  group = "gtd_ledge_alt_set",

  height = {88 , 168},
  bound_z2 = 88,

  z_fit = "bottom"
}

PREFABS.Wall_gtd_ledge_alt_low_diag =
{
  template = "Wall_gtd_ledge_1",
  map = "MAP05",

  where = "diagonal",

  group = "gtd_ledge_alt_set",

  height = {88 , 168},
  bound_z2 = 88,

  z_fit = "bottom"
}
