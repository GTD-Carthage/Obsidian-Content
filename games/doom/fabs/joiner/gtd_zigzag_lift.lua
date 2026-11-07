-- PREFABS.Joiner_zigzag_lift_miniature =
-- {
  -- file   = "joiner/gtd_zigzag_lift.wad",
  -- map = "MAP01",

  -- prob   = 1200,
  -- style  = "steepness",
  -- theme  = "!hell",

  -- env      = "!cave",
  -- neighbor = "!cave",

  -- where  = "seeds",
  -- shape  = "I",

  -- seed_w = 3,
  -- seed_h = 1,

  -- deep   = 16,
  -- over   = 16,

  -- x_fit  = "frame",

  -- delta_h  = 128,
  -- nearby_h = 128,
  -- can_flip = true,

-- },

PREFABS.Joiner_zigzag_lift =
{
  file   = "joiner/gtd_zigzag_lift.wad",
  map = "MAP02",

  prob   = 100,
  style  = "steepness",
  theme  = "!hell",

  env      = "!cave",
  neighbor = "!cave",

  where  = "seeds",
  shape  = "I",

  seed_w = 3,
  seed_h = 2,

  deep   = 16,
  over   = 16,

  x_fit  = "frame",
  y_fit  = "frame",

  delta_h  = 64,
  nearby_h = 128,
  can_flip = true,

  tex_COMPSTA1 =
  {
    COMPSTA1 = 1,
    COMPSTA2 = 1,
    COMPBLUE = 1,
    PIPEWAL1 = 1,
    PIPEWAL2 = 1
  }
}

PREFABS.Joiner_zigzag_lift_mirrored =
{
  template = "Joiner_zigzag_lift",
  map = "MAP04",
}
