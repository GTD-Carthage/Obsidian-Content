PREFABS.Item_gtd_secret_version_of_armaetus_waterfountain =
{
  file = "item/gtd_secret_armaetus_waterfountain.wad",
  map = "MAP01",
  where = "seeds",

  liquid = true,

  prob  = 50,

  theme = "!tech",

  key = "secret",

  seed_w = 2,
  seed_h = 2,

  height = 128,

  deep = 16,

  x_fit = "frame",
  y_fit = "top"
}

PREFABS.Item_gtd_secret_version_of_armaetus_impaled_guys =
{
  template = "Item_gtd_secret_version_of_armaetus_waterfountain",
  map = "MAP02",

  theme = "hell",
  prob = 100,

  key = "secret",

  seed_w = 3,
  seed_h = 1,

  height = 136,

  deep = 16,

  x_fit = "frame",
  y_fit = "top"
}

PREFABS.Item_gtd_secret_version_of_hell_lavafalls =
{
  template = "Item_gtd_secret_version_of_armaetus_waterfountain",
  map = "MAP03",

  theme = "hell",
  prob = 15,

  key = "secret",

  seed_w = 2,
  seed_h = 1,

  height = 128,

  deep = 16,

  x_fit = "frame",
  y_fit = "top"
}
