PREFABS.Decor_gtd_fireblu_wim =
{
  file = "decor/gtd_decor_industrial_factory_set.wad",
  map = "MAP01",

  prob = 5000,
  where = "point",

  group = "gtd_fireblu_where_its_made",

  height = {80 , 160},

  size = 88,

  z_fit = {82, 86},

  bound_z1 = 0,
  bound_z2 = 96,
}

PREFABS.Decor_gtd_fireblu_wim_2 =
{
  template = "Decor_gtd_fireblu_wim",
  map = "MAP02",

  height = 81,

  z_fit = nil,

  bound_z2 = 81
}

PREFABS.Decor_gtd_fireblu_wim_3_box_with_stuff =
{
  template = "Decor_gtd_fireblu_wim",
  map = "MAP03",

  prob = 2500,

  height = 128,
  size = 96,

  z_fit = "top",

  tex_CRATE3 =
  {
    CRATE3 = 2,
    CRATE2 = 2,
    CRATINY = 1
  },

  bound_z2 = 129
}

PREFABS.Decor_gtd_fireblu_wim_3_box_with_fire_stuff =
{
  template = "Decor_gtd_fireblu_wim",
  map = "MAP03",

  prob = 2500,

  height = 128,
  size = 96,

  z_fit = "top",

  flat_CEIL4_2 = "FLAT5_3",
  tex_COMPBLUE = "ROCKRED1",

  tex_CRATE3 =
  {
    CRATE3 = 2,
    CRATE2 = 2,
    CRATINY = 1
  },

  bound_z2 = 129
}

PREFABS.Decor_gtd_fireblu_wim_4 =
{
  template = "Decor_gtd_fireblu_wim",
  map = "MAP04",

  prob = 2500,

  height = 50,
  size = 72,

  z_fit = "top",

  bound_z2 = nil
}

PREFABS.Decor_gtd_fireblu_wim_4_fire =
{
  template = "Decor_gtd_fireblu_wim",
  map = "MAP04",

  prob = 2500,

  height = 50,
  size = 72,

  z_fit = "top",

  flat_CEIL4_2 = "FLAT5_3",
  tex_COMPBLUE = "ROCKRED1",

  bound_z2 = nil
}

--

PREFABS.Decor_gtd_fireblu_wim_boxes =
{
  file = "decor/crates1.wad",
  map = "MAP01",

  prob = 1500,
  where = "point",

  group = "gtd_fireblu_where_its_made",

  size = 64,
  height = 64,

  bound_z1 = 0
}

PREFABS.Decor_gtd_fireblu_wim_boxes_2 =
{
  template = "Decor_gtd_fireblu_wim_boxes",
  map = "MAP02",

  height = 128
}

PREFABS.Decor_gtd_fireblu_wim_boxes_3 =
{
  template = "Decor_gtd_fireblu_wim_boxes",
  map = "MAP03",

  size = 80
}

PREFABS.Decor_gtd_fireblu_wim_boxes_4 =
{
  template = "Decor_gtd_fireblu_wim_boxes",
  map = "MAP04",

  size = 96,
  height = 129
}
