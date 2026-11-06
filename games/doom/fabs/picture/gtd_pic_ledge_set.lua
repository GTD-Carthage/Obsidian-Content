PREFABS.Pic_gtd_ledge =
{
  file = "picture/gtd_pic_ledge_set.wad",
  map = "MAP01",

  prob   = 50,

  group = "gtd_ledge_set",

  where  = "seeds",
  height = 96,

  seed_w = 2,
  seed_h = 1,

  deep = 16,

  bound_z1 = 0,
  bound_z2 = 96,

  x_fit = "frame",
  y_fit = "frame"
}

PREFABS.Pic_gtd_ledge_higher =
{
  template = "Pic_gtd_ledge",
  map = "MAP02",

  group = "gtd_ledge_alt_set",

  height = 169,
  bound_z2 = 169,

  x_fit = "frame",
  y_fit = "frame"
}
