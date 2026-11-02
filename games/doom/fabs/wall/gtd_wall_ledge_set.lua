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
