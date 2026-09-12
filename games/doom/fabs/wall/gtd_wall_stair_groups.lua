PREFABS.Wall_stair_floor =
{
  file = "wall/gtd_wall_stair_groups.wad",
  map = "MAP01",

  kind = "wall",

  prob = 50,
  rank = 2,

  theme = "!tech",
  group = "wall_stair_1",

  where = "edge",
  deep = 16,
  height = 96,

  bound_z1 = 0,
  bound_z2 = 96,

  z_fit = "top"
}

PREFABS.Wall_stair_floor_tech =
{
  template = "Wall_stair_floor",

  rank = 1,

  theme = "tech",

  group = "wall_stair_2",
}

-- stair2, uses ceiling as texture source

PREFABS.Wall_stair_ceil =
{
  template = "Wall_stair_floor",

  group = "wall_stair_2",

  env = "building",

  tex__FLOOR = "_CEIL"
}

PREFABS.Wall_stair_ceil_tech =
{
  template = "Wall_stair_floor",

  rank = 1,

  theme = "tech",
  group = "wall_stair_2",

  env = "building",

  tex__FLOOR = "_CEIL"
}

-- stair2, compat version that uses floor

PREFABS.Wall_stair_ceil =
{
  template = "Wall_stair_floor",

  env = "outdoor",

  group = "wall_stair_2"
}

PREFABS.Wall_stair_ceil_tech =
{
  template = "Wall_stair_floor",

  rank = 1,

  theme = "tech",
  group = "wall_stair_2",

  env = "outdoor"
}
