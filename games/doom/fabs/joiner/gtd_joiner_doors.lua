PREFABS.Joiner_gtd_door_diagonal_1x2 =
{
  file = "joiner/gtd_joiner_doors.wad",
  map = "MAP01",

  kind = "joiner",
  style = "doors",

  prob = 30,

  theme = "!hell",

  where  = "seeds",
  shape  = "I",

  seed_w = 2,
  seed_h = 1,

  deep = 16,
  over = 16,

  x_fit = "frame",
  y_fit = "frame"
}

PREFABS.Joiner_gtd_door_diagonal_2x2 =
{
  template = "Joiner_gtd_door_diagonal_1x2",
  map = "MAP02",

  seed_h = 2,

  y_fit = {16,20 , 268,272}
}

PREFABS.Joiner_gtd_door_diagonal_1x2_hell =
{
  template = "Joiner_gtd_door_diagonal_1x2",
  map = "MAP01",

  seed_h = 2,

  theme = "hell",

  tex_SUPPORT2 = "SUPPORT3",
  tex_SPCDOOR3 = "SPCDOOR4",
  flat_FLOOR4_6 = "RROCK12",
  flat_FLAT1 = "CEIL5_2"
}

PREFABS.Joiner_gtd_door_diagonal_2x2_hell =
{
  template = "Joiner_gtd_door_diagonal_1x2",
  map = "MAP02",

  prob = 80 * 4,

  seed_h = 2,

  theme = "hell",

  y_fit = {16,20 , 268,272},

  tex_SUPPORT2 = "SUPPORT3",
  tex_SPCDOOR3 = "SPCDOOR4",
  flat_FLOOR4_6 = "RROCK12",
  flat_FLAT1 = "CEIL5_2"
}

--

PREFABS.Joiner_gtd_door_diagonal_1x2_flipped =
{
  template = "Joiner_gtd_door_diagonal_1x2",
  map = "MAP03"
}

PREFABS.Joiner_gtd_door_diagonal_2x2_flipped =
{
  template = "Joiner_gtd_door_diagonal_1x2",
  map = "MAP04",

  seed_h = 2,

  y_fit = {16,20 , 268,272}
}

PREFABS.Joiner_gtd_door_diagonal_1x2_hell_flipped =
{
  template = "Joiner_gtd_door_diagonal_1x2",
  map = "MAP03",

  seed_h = 2,

  theme = "hell",

  tex_SUPPORT2 = "SUPPORT3",
  tex_SPCDOOR3 = "SPCDOOR4",
  flat_FLOOR4_6 = "RROCK12",
  flat_FLAT1 = "CEIL5_2"
}

PREFABS.Joiner_gtd_door_diagonal_2x2_hell_flipped =
{
  template = "Joiner_gtd_door_diagonal_1x2",
  map = "MAP04",

  seed_h = 2,

  theme = "hell",

  y_fit = {16,20 , 268,272},

  tex_SUPPORT2 = "SUPPORT3",
  tex_SPCDOOR3 = "SPCDOOR4",
  flat_FLOOR4_6 = "RROCK12",
  flat_FLAT1 = "CEIL5_2"
}

--

PREFABS.Joiner_gtd_door_ex =
{
  template = "Joiner_gtd_door_diagonal_1x2",
  map = "MAP05",

  theme = "!hell",
  prob = 50,
}

PREFABS.Joiner_gtd_door_ex_hell =
{
  template = "Joiner_gtd_door_diagonal_1x2",
  map = "MAP05",

  theme = "hell",
  prob = 50,

  tex_BIGDOOR2 = "BIGDOOR5",
  tex_LITEBLU1 = "BFALL1",
  tex_METAL5 = "SLOPPY1"
}

--

PREFABS.Joiner_gtd_door_techno_pillar_3x =
{
  template = "Joiner_gtd_door_diagonal_1x2",
  map = "MAP06",

  theme = "!hell",
  prob = 75,

  y_fit = {40,48 , 112,128}
}

PREFABS.Joiner_gtd_door_techno_pillar_3x_hell =
{
  template = "Joiner_gtd_door_diagonal_1x2",
  map = "MAP06",

  theme = "hell",
  prob = 75,

  y_fit = {40,48 , 112,128},

  flat_FLAT20 = "FLOOR7_2",
  flat_FLAT14 = "FLAT5_3",
  flat_CEIL4_3 = "FLAT5_3",
  tex_DOORSTOP = "BROWN144",
  tex_SUPPORT2 = "BROWNHUG",
  tex_SPCDOOR2 =
  {
    SW1LION = 1,
    SW1GARG = 1,
    SW1SATYR = 1
  },
  tex_COMPBLUE = "BFALL1",
  tex_LITEBLU4 = "STEP6"
}
