------------------------------------------------------------------------
--  MODULE: LLM Name Generator
------------------------------------------------------------------------
--
--  Copyright (C) 2026 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2,
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
-------------------------------------------------------------------

-- This module is for prompt construction and connecting to a local LLM
-- in order to supply Obsidian with context-aware strings in place
-- of map names and story intermissions.

-- The Level Namer system draws metadata from the level and passes them
-- through a semantic translation layer to allow for a more natural language
-- prompt e.g. "This level has bank_prefab" becomes 
-- "This abandoned dense urban zone contains high-security cash vaults."
--
-- Not all assets Obsidian have a semantic translation but they will still
-- be passed as-is to the LLM as, for example, "bank_prefab" is still
-- understandable but not necessarily context-rich.

-- The Story Intermission is a prompt constructor where rules and objects within the story
-- are based on pre-generated elements such as pre-named actors, McGuffins, places,
-- and tropes in the story to prevent a problem with popular latent attractors appearing
-- e.g. too much "Kaelin Vex" or "Elara Voss", which have become widely popular
-- names in AI data sets pretty much do to training on regurgitated web data.

-- If you are interested in using your own model,
-- just add model aliases under LLM_NAME.MODEL_CHOICES below.
-- Actual model alias names e.g. "gemma4:latest" can be revealed by entering
-- the command "ollama ls" in your terminal.
-- It's fine to use any model or even the same model for both features
-- but you need to configure some settings under LLM_NAME.MODEL_CHOICES.

-- cURL is used for connecting to the chat instance. If something else is preferred
-- from Ollama, you will need to change the API call as well.

-- In other words, we believe Obsidian is fine not turning into a pretrained diffusion model.
-- We would rather that diffusion models become Obsidian's bitch, as in this case,
-- as we believe in the integrity of the rules we set for our own procedural generation,
-- we being a group of designers, programmers, and artists ourselves whose work
-- has been trained on.


LLM_NAME = { }

LLM_NAME.MODEL_CHOICES =
{
  "gpt-oss:latest", _("GPT-OSS"),
  "llama3.1:8b", _("Llama3.1 8B"),
  "gemma4:latest", _("Gemma4")
}

LLM_NAME.MODEL_SETTINGS =
{
  -- ChatGPT's GPT-OSS. Required high max_token count or it will die thinking before
  -- sending a response. reasoning_effort set to low for level names.
  -- Spends a bit of time even on low reasoning effort.
  ["gpt-oss:latest"] =
  {
    story =
    '"num_predict":16384,' ..
    '"reasoning_effort":"medium",' ..
    '"num_ctx":16384,',
    name = 
    '"num_predict":2048,' ..
    '"reasoning_effort":"low",',
  },
  -- Meta's Llama3.1. Decent general purpose dense model.
  -- Actually speedy and good enough for level names.
  ["llama3.1:8b"] =
  {
    story =
    '"num_predict:1800",',
    name =
    '"num_predict:20",'
  },
  -- Google's Gemma4. Pretty good Mixture-of-Experts model.
  -- Takes a very long time, but response is usually consistent.
  ["gemma4:latest"] =
  {
    story =
    '"num_predict:1800",',
    name =
    '"num_predict:1000",'
  }
}

LLM_NAME.endpoint = "http://127.0.0.1:11434/api/generate"

LLM_NAME.test_endpoint = "http://127.0.0.1:11434/api/tags"

LLM_NAME.level_infos = {}

LLM_NAME.PROMPT_FLAVOR_CHOICES =
{
  "default", _("DEFAULT"),
  "dn3d", _("Duke Nukem"),
  "black_metal", _("Black Metal"),
  "ecchi", _("HDoom"),
  "action", _("Action Movie"),
  "meguca", _("Meguca"),
  "meguca_suffering", _("Meguca is Suffering")
}

-- semantics translation table
LLM_NAME.semantics_grouping =
{
  low_gap2 = "low_gap",
  low_gap3 = "low_gap",
  low_gap4 = "low_gap",

  mid_band2 = "mid_band",

  lite2 = "lite1",

  torches1 = "torches",
  torches2 = "torches",
  torches4 = "torches",
  torches5 = "torches",
  torches6 = "torches",
  torches7 = "torches",
  torches8 = "torches",
  torches9 = "torches",
  torches10 = "torches",
  torches11 = "torches",

  runes2 = "runes1",
  runes3 = "runes1",
  runes4 = "runes1",
  runes5 = "runes1",

  cross2 = "cross1",
  cross3 = "cross1",
  cross4 = "cross1",
  cross5 = "cross1",

  gtd_wall_tech_top_corner_light_set = "gtd_ribbed_lights",
  gtd_ribbed_lights_no3d = "gtd_ribbed_lights",
  gtd_ribbed_lights_slump = "gtd_ribbed_lights",
  gtd_ribbed_lights_slump_two_color = "gtd_ribbed_lights",
  gtd_ribbed_lights_very_blue = "gtd_ribbed_lights",

  gtd_ribbed_lights_tekmachine = "gtd_ribbed_lights_tekmachine",
  gtd_ribbed_lights_tekmachine_alt = "gtd_ribbed_lights_tekmachine",

  gtd_woodframe_green = "gtd_woodframe",
  gtd_woodframe_alt = "gtd_woodframe",
  gtd_woodframe_alt_green = "gtd_woodframe",

  gtd_generic_tek_grate_bottom_slope = "gtd_generic_tek_grate",
  gtd_generic_tek_grate_xit_machine = "gtd_generic_tek_grate",
  gtd_wall_grated_machines_epic = "gtd_generic_tek_grate",

  gtd_ind_modwall_2 = "gtd_ind_modwall_1",
  gtd_ind_modwall_3 = "gtd_ind_modwall_1",

  gtd_sunderfall_barred = "gtd_sunderfall",

  gtd_gothic_ceilwall_arch = "gtd_gothic_ceilwall",
  gtd_gothic_ceilwall_doublet_arch = "gtd_gothic_ceilwall",
  gtd_gothic_ceilwall_braced_arch = "gtd_gothic_ceilwall",
  gtd_gothic_ceilwall_xzibit_arch = "gtd_gothic_ceilwall",
  gtd_gothic_ceilwall_inner_framed_arch = "gtd_gothic_ceilwall",

  gtd_wall_quakish_insets = "gtd_modquake_set",
  gtd_wall_quakish_insets_horizon = "gtd_modquake_set",

  gtd_wall_hell_mindscrew_skywall = "gtd_wall_hell_mindscrew",

  gtd_power_plant_red_set = "gtd_power_plant_set",

  gtd_computers_shawn = "gtd_computers",
  gtd_computers_compsta = "gtd_computers",
  gtd_comp_set_yellow_EPIC = "gtd_computers",
  gtd_comp_set_green_EPIC = "gtd_computers",
  gtd_comp_set_red_EPIC = "gtd_computers",
  gtd_comptil_plain_red = "gtd_computers",
  gtd_comptil_plain_green = "gtd_computers",
  gtd_comptil_plain_yellow = "gtd_computers",
  gtd_comptil_plain_purple = "gtd_computers",
  gtd_comptil_plain_blue = "gtd_computers",
  gtd_comptil_lite_red = "gtd_computers",
  gtd_comptil_lite_green = "gtd_computers",
  gtd_comptil_lite_yellow = "gtd_computers",
  gtd_comptil_lite_purple = "gtd_computers",
  gtd_comptil_lite_blue = "gtd_computers",

  dem_wall_commercial = "gtd_grocery",
  gtd_grocery_2 = "gtd_grocery",

  gtd_tall_glass_epic_yellow = "gtd_wall_churchy_glass",
  gtd_tall_glass_epic_orange = "gtd_wall_churchy_glass",
  gtd_tall_glass_epic_red = "gtd_wall_churchy_glass",
  gtd_tall_glass_epic_blue = "gtd_wall_churchy_glass",
  gtd_winglass_wall = "gtd_wall_churchy_glass",
  gtd_wall_gothic_bottom_glass = "gtd_wall_churchy_glass",

  armaetus_catacobm_wall_set = "gtd_wall_hell_ossuary",
  armaetus_catacombs_brown = "gtd_wall_hell_ossuary",

  gtd_wall_hell_engraving_1 = "gtd_wall_marbface",
  gtd_wall_hell_engraving_2 = "gtd_wall_marbface",
  gtd_wall_hell_engraving_3 = "gtd_wall_marbface",
  gtd_wall_hell_engraving_dark = "gtd_wall_marbface",
  gtd_wall_hell_engraving_arch = "gtd_wall_marbface",
  gtd_wall_hell_engraving_top_band = "gtd_wall_marbface",

  gtd_generic_artsy_bedazzled = "liminal_space",
  gtd_generic_alt_colors = "liminal_space",
  gtd_generic_mid_band = "liminal_space",
  gtd_generic_artsy_center_braced_ind = "liminal_space",
  gtd_generic_artsy_step1_banded = "liminal_space",
  gtd_generic_artsy_slope_y_inset = "liminal_space",
  gtd_generic_artsy_base_braced = "liminal_space",
  gtd_generic_artsy_sloped_bump = "liminal_space",
  gtd_generic_small_lite = "liminal_space",
  gtd_generic_artsy_lite_box = "liminal_space",
  gtd_generic_artsy_chequered = "liminal_space",
  gtd_generic_artsy_corpo_art = "liminal_space",
  gtd_generic_ceilwall = "liminal_space",
  gtd_generic_ceilwall_2 = "liminal_space",
  gtd_generic_ceilwall_3 = "liminal_space",
  gtd_generic_ceilwall_silver_frame = "liminal_space",
  gtd_generic_ceilwall_double_silver_frame = "liminal_space",

  gtd_wall_lit_h_window_tall_brown = "gtd_wall_lit_h_window_tall_gray",


  -- liquids
  otex_nukage = "nukage",
  otex_poop = "slime",

  -- room themes
  tech_Doom3_grey_hulls = "tech_Shiny",
  tech_Doom3_brown_hulls = "tech_VeryBrown"
}

LLM_NAME.semantics =
{
--[[ PRIMARY THEMES]]
  tech =
  {
    "The level evokes a foreboding industrial megastructure.",
    "The setting resembles a vast technological installation.",
    "The level feels mechanical, artificial, and industrial.",
    "The environment suggests a decaying high-tech complex.",
    "The level has the atmosphere of a massive engineered facility.",
    "The setting feels like a machine-built industrial labyrinth.",
    "The level resembles an abandoned technological superstructure.",
    "The environment carries a bleak industrial science-fiction tone.",
    "The setting feels synthetic, metallic, and heavily engineered.",
    "The level evokes an immense industrial machine world."
  },

  urban =
  {
    "The level resembles a sprawling urban structure.",
    "The setting evokes a decaying cityscape.",
    "The environment feels inhabited, civic, and architectural.",
    "The level has the atmosphere of a deteriorating metropolitan complex.",
    "The setting resembles abandoned commercial infrastructure.",
    "The level feels grounded, urbanized, and human-built.",
    "The environment suggests dense interconnected city structures.",
    "The setting evokes a bleak concrete metropolis.",
    "The level resembles forgotten urban infrastructure.",
    "The environment carries the atmosphere of a collapsing city."
  },

  hell =
  {
    "The level evokes an infernal and corrupted realm.",
    "The setting feels ancient, hostile, and ritualistic.",
    "The environment resembles a hellish labyrinth.",
    "The level carries a nightmarish supernatural atmosphere.",
    "The setting suggests demonic architecture fused with ruin.",
    "The level feels cursed, oppressive, and otherworldly.",
    "The environment evokes infernal catacombs and sacrificial halls.",
    "The setting resembles a corrupted underworld domain.",
    "The level carries a sinister and occult tone.",
    "The environment feels mythic, hostile, and hellish."
  },

  snow =
  {
    "The exterior is frozen and snow covered.\n",
    "The map takes place in a frigid snowy environment.\n",
    "The outdoors are icy and windswept.\n"
  },

  sand =
  {
    "The map takes place in a scorching desert environment.\n",
    "The outdoors are dusty and sun blasted.\n",
    "The exterior is dry and desertlike.\n"
  },

--[[ WALL GROUPS ]]

  -- TECH --
  low_gap =
  {
    "narrow industrial spacing",
    "compressed architecture"
  },

  mid_band =
  {
    "layered industrial walls",
    "banded structural design"
  },

  lite1 =
  {
    "artificial lighting",
    "illuminated interiors"
  },

  torches =
  {
    "ritual lighting",
    "ominous flames",
    "torchlit interiors"
  },

  gtd_wall_urban_storage =
  {
    "storage infrastructure",
    "industrial warehouses",
    "cargo facilities"
  },

  gtd_DMV_set =
  {
    "bureaucratic office halls",
    "sterile civic waiting rooms",
    "government processing offices"
  },

  gtd_full_storage =
  {
    "packed storage sectors",
    "industrial stockpiles",
    "overpacked warehouses"
  },

  gtd_storage_shawn =
  {
    "high-tech storage center",
    "compact tech supplies warehouse",
    "polished materials yard"
  },

  gtd_wall_server_room =
  {
    "server facilities",
    "computer infrastructure",
    "data processing systems"
  },

  gtd_data_center =
  {
    "massive data centers",
    "digital infrastructure",
    "machine archives"
  },

  gtd_computers =
  {
    "computerized facilities",
    "industrial control systems",
    "surveillance infrastructure",
    "machine monitoring stations"
  },

  gtd_writhing_mass =
  {
    "hellified organic masses",
    "infernal overgrowth"
  },

  gtd_wall_sewer =
  {
    "sewer infrastructure",
    "industrial drainage systems",
    "waste processing"
  },

  gtd_water_purifier =
  {
    "water treatment systems",
    "purification facilities"
  },

  gtd_nukage_aquarium =
  {
    "toxic containment systems",
    "industrial chemical reservoirs"
  },

  gtd_toilet_gallery =
  {
    "industrial sanitation systems",
    "vast plumbing infrastructure",
    "sterile maintenance facilities"
  },

  gtd_modquake_set =
  {
    "heavy brutalist architecture",
    "massive industrial geometry"
  },

  gtd_ribbed_lights =
  {
    "ribbed illuminated machinery",
    "glowing industrial structures"
  },

  gtd_ribbed_lights_tekmachine =
  {
    "advanced machinery",
    "mechanized infrastructure"
  },

  cran_bunkbeds =
  {
    "sleeping quarters",
    "common barracks",
    "staff bedrooms"
  },

  gtd_craneo_bank_set =
  {
    "reinforced bank vaults",
    "financial storage facilities",
    "secure transaction halls"
  },

  gtd_mining_set =
  {
    "mining infrastructure",
    "industrial excavation",
    "resource extraction"
  },

  gtd_power_plant_set =
  {
    "power generation facilities",
    "energy infrastructure",
    "industrial reactors"
  },

  gtd_door_storage =
  {
    "industrial door storage chambers",
    "door stockpiles",
    "modular door depots"
  },

  gtd_fireblu_where_its_made =
  {
    "surreal technology",
    "alien industrial systems",
    "unstable dimensional machinery"
  },

  gtd_tech_barrier_tek =
  {
    "security barriers",
    "containment structures",
    "reinforced checkpoints"
  },

  gtd_generic_tek_grate =
  {
    "grate-protected machines",
    "exposed industrial systems"
  },

  gtd_sunderfall =
  {
    "cascading industrial runoff",
    "overflow drainage channels",
    "vertical waste conduits"
  },

  gtd_lavafall =
  {
    "exposed magma falls",
    "flowing lava openings"
  },

  gtd_wall_cafeteria_set =
  {
    "industrial mess halls",
    "communal dining sectors",
    "corporate food courts"
  },

  gtd_wall_hydroponics =
  {
    "hydroponics laboratory",
    "climate-controlled interior farm",
    "high-tech plant nursery"
  },

  gtd_wall_tech_oven =
  {
    "massive thermal exchangers",
    "industrial heating systems",
    "reactor cooling infrastructure"
  },

  gtd_wall_tech_freeze =
  {
    "industrial freezing units",
    "ice manufacturing plant",
    "cryogenics laboratory"
  },

  gtd_wall_air_vents =
  {
    "vast ventilation systems",
    "industrial air ducts",
    "labyrinthine maintenance shafts"
  },

  gtd_wall_of_guns =
  {
    "weapons storage facility",
    "armory depot",
    "gun displays"
  },

  gtd_bathwater =
  {
    "gamer girl bath water production machines",
    "Instagram model's bath water interment units"
  },

  gtd_mscottpaper =
  {
    "corporate office complexes",
    "industrial paper processing",
    "administrative workspaces"
  },

  gtd_black_mirror =
  {
    "power cycling halls",
    "manual power generation facility",
    "mandatory advertisement viewing centers"
  },


  -- URBAN
  gtd_woodframe =
  {
    "wooden panel walls",
    "ornate wood mouldings",
    "wood wainscoting"
  },

  gtd_wall_urban_cement_frame =
  {
    "concrete pillar corridors",
    "cement commercial backrooms"
  },

  gtd_ind_modwall_1 = {
    "metallic girders",
    "silver support frames"
  },

  gtd_greywall_1 =
  {
    "bleak concrete corridors",
    "utilitarian industrial walls",
    "sterile cement structures"
  },

  cran_bloodtubes_set =
  {
    "experimental containment vats",
    "biological suspension chambers",
    "creature stasis facilities"
  },

  gtd_gothic_ceilwall =
  {
    "gothic arched walls",
    "medieval vaulted chambers",
    "cathedral ceilings"
  },

  gtd_prison_A =
  {
    "jail facility",
    "interment structure",
    "prison cell block"
  },

  gtd_furnace_water =
  {
    "boiler facility",
    "centralized heating systems",
    "water heating units"
  },

  gtd_grocery =
  {
    "massive supermarket",
    "department store",
    "general goods grocery"
  },

  gtd_wall_arcade =
  {
    "arcade center",
    "gaming facility"
  },

  gtd_library_tall =
  {
    "towering archives",
    "forbidden libraries",
    "vaulted repositories of knowledge"
  },

  gtd_pools =
  {
    "bleak recreational swimming pools",
    "eerie maze-like pool facility"
  },

  dem_wall_hospital =
  {
    "clinical patient chambers",
    "ecovery sick bays",
    "advanced medical care center"
  },



  -- HELL
  runes1 =
  {
    "hellish rune carvings",
    "infernal symbols",
    "ritualistic markings"
  },

  cross2 =
  {
    "desecrated sanctuaries",
    "blasphemous shrines",
    "inverted religious iconography"
  },

  gtd_furnace =
  {
    "incinerator furnaces",
    "cremation building"
  },

  gtd_furnace_face =
  {
    "tormented soul furnaces",
    "spiritual oubliettes",
    "infernal containment chambers"
  },

  gtd_wall_hell_ossuary =
  {
    "bone ossuaries",
    "catacomb labyrinths",
    "ancient mausoleums",
    "crypt networks"
  },

  gtd_wall_marbface =
  {
    "marble gargoyle sculptures",
    "hellish relief statues",
    "eerie demonic stone figures"
  },

  gtd_wall_hell_mindscrew =
  {
    "Escheresque dimensional breaches",
    "non-Euclidean geometric hollows"
  },

  gtd_wall_churchy_glass =
  {
    "tall cathedral glass walls",
    "stained glass halls",
    "grand church windows"
  },

  gtd_wall_candles =
  {
    "candlestand chambers",
    "candelabra hallways"
  },

  gtd_wall_lit_h_window_tall_gray =
  {
    "bare warehouse spaces",
    "abandoned factory floors",
    "emptied industrial chambers"
  },

  liminal_space =
  {
    -- pure liminality / void tone
    "liminal, in-between architectural spaces",
    "spaces that feel abandoned yet maintained",
    "transitional environments with unclear purpose",
    "quiet corridors between functional zones",

    -- aesthetic uncanny
    "hauntingly sterile interior spaces",
    "strangely elegant empty corridors",
    "uncannily clean and unoccupied halls",
    "beautiful but unsettling architectural voids",

    -- industrial liminality
    "unfinished industrial corridors",
    "maintenance spaces between major systems",
    "service corridors with no clear destination",
    "backstage infrastructure spaces",

    -- spatial dislocation
    "disorienting but orderly architectural interiors",
    "spaces that feel partially constructed or erased",
    "interior zones without narrative function",
    "hallways that feel like memory fragments",

    -- emotional neutrality
    "quiet, unoccupied structural interiors",
    "empty but structured architectural environments",
    "minimal, non-descriptive interior spaces"
  },


--[[LAYOUT (shape rules)]]

--[[ROOM THEMES]]
  -- TECH
  tech_Doom3_blue_hulls =
  {
    "cold blue industrial plating",
    "futuristic armored hulls",
    "sterile blue machinery"
  },

  tech_Doom3_lime_green_plates =
  {
    "acidic green machinery",
    "reactor-like plating",
    "hazard-tinted industrial surfaces"
  },

  tech_Doom3_all =
  {
    "harsh futuristic industry",
    "cold aerospace development facilities",
    "heavy sci-fi infrastructure"
  },

  tech_Metal =
  {
    "metallic industrial structures",
    "steel-plated corridors",
    "heavy machine architecture"
  },

  tech_deimosRoom =
  {
    "hell-corrupted research chambers",
    "inferno-touched sci-fi interiors",
    "hellified techbase rooms"
  },

  tech_Doom3_green_hulls =
  {
    "green-tinted machine hulls",
    "military industrial plating",
    "reactor infrastructure"
  },

  tech_VeryGray =
  {
    "sterile gray architecture",
    "ashen industrial corridors",
    "monolithic concrete-metal interiors"
  },

  tech_VeryBrown =
  {
    "aged industrial walls",
    "rusted brown machinery",
    "weathered tech infrastructure"
  },

  tech_wood_comp =
  {
    "wood-paneled computer facilities",
    "retro office technology",
    "corporate machine interiors"
  },

  tech_darkBronze =
  {
    "dark bronze machinery",
    "aged metallic infrastructure",
    "oxidized industrial halls"
  },

  tech_Sladwall =
  {
    "ribbed industrial walls",
    "heavy reinforced paneling",
    "retro techbase geometry"
  },

  tech_Tekgren =
  {
    "green-tinted machinery",
    "hazard-striped industrial sectors",
    "toxic technological infrastructure"
  },

  tech_GrayMet =
  {
    "gray metal corridors",
    "industrial steel interiors",
    "cold mechanical hallways"
  },

  tech_VeryTekky =
  {
    "dense technological infrastructure",
    "hyper-industrial interiors",
    "machine-dominated architecture"
  },

  tech_Doom3_flesh_forge =
  {
    "cybernetic flesh foundries",
    "hell-corrupted machinery",
    "biomechanical industrial systems"
  },

  tech_Shiny =
  {
    "polished industrial surfaces",
    "reflective metallic corridors",
    "sterile glossy machinery"
  },

  tech_beigetownTech =
  {
    "beige retro-futurist interiors",
    "corporate industrial architecture",
    "aged office-tech structures"
  },

  tech_dk_green_tech =
  {
    "dark green machinery",
    "military industrial systems",
    "cold reactor infrastructure"
  },

  tech_redFloorsBrownWalls =
  {
    "brown industrial interiors",
    "retro machine corridors",
    "aged technological sectors"
  },

  tech_Computers =
  {
    "computerized infrastructure",
    "server-filled chambers",
    "control system interiors"
  },

  tech_Gray =
  {
    "gray industrial complexes",
    "neutral metallic corridors",
    "sterile machine architecture"
  },

  tech_VeryBluey =
  {
    "deep blue technological interiors",
    "cold illuminated machinery",
    "blue-lit industrial halls"
  },

  tech_HeavyMetal =
  {
    "heavy industrial machinery",
    "massive steel structures",
    "dense mechanical infrastructure"
  },

  tech_silver_grate =
  {
    "grated metallic walkways",
    "silver industrial meshwork",
    "ventilated machine corridors"
  },

  tech_copper_steampunk =
  {
    "copper industrial machinery",
    "steam-powered mechanisms",
    "Victorian mechanical infrastructure"
  },

  tech_Starbase =
  {
    "orbital station interiors",
    "spacefaring infrastructure",
    "stellar military architecture"
  },

  tech_Cave_generic =
  {
    "excavated industrial caverns",
    "machine-dug cave systems",
    "subterranean facilities"
  },

  tech_aww2 =
  {
    "retro industrial warfare architecture",
    "military-inspired facilities",
    "aged bunker infrastructure"
  },

  tech_VeryShiny =
  {
    "highly polished machinery",
    "gleaming metallic corridors",
    "sterile reflective interiors"
  },

  tech_AITextures =
  {
    "alien synthetic surfaces",
    "procedural machine textures",
    "uncanny digital architecture"
  },

  tech_iStuff =
  {
    "sleek consumer technology",
    "minimalist tech interiors",
    "high-end electronic infrastructure"
  },

  tech_Cement =
  {
    "concrete industrial facilities",
    "utilitarian machine structures",
    "brutalist technological halls"
  },

  tech_bumblebee =
  {
    "yellow-black hazard machinery",
    "industrial warning coloration",
    "striped reactor infrastructure"
  },

  tech_wood_lab =
  {
    "wood-paneled laboratories",
    "academic research interiors",
    "retro scientific facilities"
  },

  tech_goth_tech =
  {
    "gothic cybernetic halls",
    "cathedral-like machinery",
    "religious industrial architecture"
  },

  tech_HighContrast =
  {
    "stark illuminated machinery",
    "high-contrast industrial halls",
    "dramatic technological lighting"
  },

  tech_bunker =
  {
    "fortified military bunkers",
    "hardened underground facilities",
    "defensive industrial sectors"
  },

  tech_cableSocketCatacombs =
  {
    "cable-filled underground tunnels",
    "electrical maintenance catacombs",
    "dense wiring infrastructure"
  },

  -- URBAN
  urban_BrownyMcBrownston =
  {
    "brownstone architecture",
    "aged urban housing",
    "weathered residential blocks"
  },

  urban_Cement =
  {
    "concrete city structures",
    "urban brutalist architecture",
    "cement corridors"
  },

  urban_Stucco =
  {
    "stucco-covered buildings",
    "Mediterranean urban walls",
    "aged plaster architecture"
  },

  urban_RedBrick =
  {
    "red brick city blocks",
    "industrial-era buildings",
    "aged masonry streets"
  },

  urban_ShadesOfGrey =
  {
    "gray urban corridors",
    "monochrome city structures",
    "bleak metropolitan interiors"
  },

  urban_darkGrimyIndustrial =
  {
    "grimy industrial districts",
    "polluted factory sectors",
    "decaying urban machinery"
  },

  urban_Panel =
  {
    "paneled office interiors",
    "modular wall systems",
    "commercial urban architecture"
  },

  urban_Doom3 =
  {
    "harsh sci-fi urban interiors",
    "industrial city structures",
    "retro-futurist facilities"
  },

  urban_Doom3_white_panels =
  {
    "white-paneled interiors",
    "sterile corporate structures",
    "clean futuristic offices"
  },

  urban_ReisalBricks =
  {
    "ornate brickwork",
    "decorative masonry halls",
    "elegant urban construction"
  },

  urban_returnToCastleWolf =
  {
    "military fortress interiors",
    "WW2-inspired architecture",
    "stone military compounds"
  },

  urban_blueBrick =
  {
    "blue-tinted brick structures",
    "cold urban masonry",
    "painted industrial buildings"
  },

  urban_wood_comp =
  {
    "wood-paneled offices",
    "retro commercial interiors",
    "corporate administrative halls"
  },

  urban_computerCatacombs =
  {
    "computer-filled underground offices",
    "server-lined city infrastructure",
    "digital maintenance tunnels"
  },

  urban_iStuff =
  {
    "sleek consumer interiors",
    "high-end commercial spaces",
    "minimalist electronics stores"
  },

  urban_MoreWood =
  {
    "heavy wooden architecture",
    "timber-framed interiors",
    "warm residential halls"
  },

  urban_greenFloorsGreyWalls =
  {
    "institutional interiors",
    "sterile office corridors",
    "retro corporate buildings"
  },

  urban_Doom3_wood =
  {
    "wood-paneled sci-fi interiors",
    "retro-futurist office halls",
    "corporate tech architecture"
  },

  urban_Stone =
  {
    "stone urban structures",
    "masonry corridors",
    "heavy civic architecture"
  },

  urban_brownyMcBrown =
  {
    "aged brown interiors",
    "weathered commercial architecture",
    "rustic urban hallways"
  },

  urban_kievan_rus =
  {
    "eastern medieval architecture",
    "orthodox-inspired halls",
    "ancient Slavic interiors"
  },

  urban_evil_mansion =
  {
    "haunted mansion interiors",
    "decadent manor halls",
    "gloomy aristocratic chambers"
  },

  urban_new_york_art_deco =
  {
    "art deco skyscraper interiors",
    "ornate metropolitan halls",
    "1930s urban luxury"
  },

  urban_Brick =
  {
    "brick industrial corridors",
    "masonry urban structures",
    "dense city architecture"
  },

  urban_silver_grate =
  {
    "industrial metal walkways",
    "grated maintenance corridors",
    "urban machine infrastructure"
  },

  urban_bunker =
  {
    "civil defense bunkers",
    "fortified underground shelters",
    "concrete survival infrastructure"
  },

  urban_Wood =
  {
    "wooden urban interiors",
    "timber residential halls",
    "aged wooden structures"
  },

  urban_beigetownTech =
  {
    "retro office technology",
    "beige corporate interiors",
    "aged administrative facilities"
  },

  -- HELL
  hell_cableSocketCatacombs =
  {
    "infernal machine catacombs",
    "cable-lined abyssal tunnels",
    "hellish industrial underworld"
  },

  hell_evil_mansion =
  {
    "haunted infernal mansions",
    "cursed aristocratic halls",
    "decadent demonic estates"
  },

  hell_GrayMarble =
  {
    "ashen marble halls",
    "cold infernal temples",
    "gray demonic architecture"
  },

  hell_rocky_ruins =
  {
    "ruined volcanic stonework",
    "collapsed infernal ruins",
    "ancient shattered temples"
  },

  hell_Wood =
  {
    "charred wooden chambers",
    "burnt ritual halls",
    "aged occult interiors"
  },

  hell_greenBrick =
  {
    "corrupted green masonry",
    "sickly infernal brickwork",
    "tainted demonic structures"
  },

  hell_blackened =
  {
    "burnt infernal ruins",
    "ash-covered chambers",
    "blackened hell architecture"
  },

  hell_babylonian =
  {
    "ancient ziggurat architecture",
    "mesopotamian ritual halls",
    "forgotten desert temples"
  },

  hell_fleshcraft =
  {
    "living flesh architecture",
    "organic nightmare structures",
    "mutated biomechanical halls"
  },

  hell_Doom3_brick =
  {
    "harsh infernal brickwork",
    "martian hell architecture",
    "industrial demonic corridors"
  },

  hell_green_tk =
  {
    "green infernal machinery",
    "toxic demonic technology",
    "corrupted reactor halls"
  },

  hell_AztecClay =
  {
    "ancient clay temples",
    "ritualistic stone pyramids",
    "bloodstained jungle ruins"
  },

  hell_Doom3_martian_brick =
  {
    "martian infernal masonry",
    "red industrial hellscape",
    "alien demonic ruins"
  },

  hell_fireycave =
  {
    "flaming cavern systems",
    "volcanic infernal caves",
    "firelit abyssal tunnels"
  },

  hell_Viney =
  {
    "overgrown demonic ruins",
    "vine-covered temples",
    "decaying occult structures"
  },

  hell_CementCautionless =
  {
    "abandoned concrete hellscapes",
    "derelict industrial ruins",
    "forgotten demonic facilities"
  },

  hell_CementCautionlines =
  {
    "hazard-marked infernal industry",
    "warning-striped hell facilities",
    "corrupted industrial sectors"
  },

  hell_copper_steampunk =
  {
    "infernal steam machinery",
    "brass occult mechanisms",
    "demonic industrial engines"
  },

  hell_metal =
  {
    "iron infernal halls",
    "metallic demon fortresses",
    "steel hell architecture"
  },

  hell_Panel =
  {
    "paneled infernal interiors",
    "structured demonic halls",
    "modular hell corridors"
  },

  hell_Stone =
  {
    "ancient stone temples",
    "infernal masonry halls",
    "abyssal rock structures"
  },

  hell_Cave_Hot =
  {
    "molten cavern systems",
    "volcanic hell tunnels",
    "lava-scarred abyss"
  },

  hell_crimson =
  {
    "blood-red infernal halls",
    "crimson demonic temples",
    "scarlet abyssal architecture"
  },

  hell_Cave_generic =
  {
    "natural infernal caverns",
    "dark underground tunnels",
    "subterranean abyssal chambers"
  },

  hell_egyptish =
  {
    "ancient tomb architecture",
    "burial crypt complexes",
    "desert necropolis halls"
  },

  hell_Doom3_marble =
  {
    "polished infernal marble",
    "cold demonic temples",
    "martian occult architecture"
  },

  hell_kievan_rus =
  {
    "orthodox infernal halls",
    "ancient eastern cathedrals",
    "weathered ritual chambers"
  },

  hell_ReisalGothic =
  {
    "gothic cathedral ruins",
    "towering infernal arches",
    "medieval occult halls"
  },

  hell_Doom3_flesh_forge =
  {
    "biomechanical flesh foundries",
    "organic industrial nightmares",
    "living demonic machinery"
  },

  hell_gstone =
  {
    "green infernal stonework",
    "corrupted abyssal masonry",
    "weathered occult ruins"
  },

  hell_computerCatacombs =
  {
    "demonic data catacombs",
    "corrupted machine crypts",
    "hellish computer tunnels"
  },

  hell_Doom3_flesh =
  {
    "living flesh walls",
    "organic nightmare corridors",
    "mutated demonic interiors"
  },

  hell_armaetuscave =
  {
    "jagged infernal caverns",
    "hostile abyssal caves",
    "sharp volcanic tunnels"
  },

  hell_icecave =
  {
    "frozen abyssal caverns",
    "icy infernal tunnels",
    "glacial underworld chambers"
  },

  hell_GreenMarble =
  {
    "green marble temples",
    "emerald infernal halls",
    "ornate occult chambers"
  },

  hell_Hotbrick =
  {
    "heat-scorched brick halls",
    "burning infernal masonry",
    "smoldering abyssal corridors"
  },

  hell_gilded_bricks =
  {
    "gold-trimmed infernal masonry",
    "ornate demonic halls",
    "luxurious abyssal temples"
  },

  hell_Skin =
  {
    "skin-lined chambers",
    "flayed organic walls",
    "living flesh interiors"
  },


--[[LIQUIDS]]
  otex_purple_goop =
  {
    "thick strange purple substance",
    "bright purple slime",
    "purple alien blood"
  },

  nukage =
  {
    "dangerous toxic wastes",
    "disposed nuclear material",
    "radioactive coolant"
  },

  slime =
  {
    "industrial brown water",
    "run-off waste water",
    "untreated sewage"
  },

  blood =
  {
    "exposed blood plasma",
    "red blood",
    "organic fluids"
  },

  otex_lavaD1 =
  {
    "molten golden",
    "burning gold magma",
    "melting flowing gold"
  },

  otex_tar =
  {
    "sticky black pitch",
    "unprocessed oil tar",
    "oil mire"
  }
}

LLM_NAME.name_theme =
{
  char_limits =
  {
    "- 1 word, 4-10 letters. Do not combine more than 2 dictionary words into one",
    "- 1 word, 4-10 letters, in the format 'The <Name>'. Do not combine more than 2 dictionary words into one",
    "- 2 words, in the format 'The <Adjective> <Name>'. Do not combine more than 2 dictionary words into one",
    "- 2 words, in the format 'The <Name> of <Adjective>'. Do not combine more than 2 dictionary words into one",
    "- 2 words, in the format 'The <Adjective> <Non-Diciontary Name>'. Do not combine more than 2 dictionary words into one",
    "- 2 words, in the format 'The <Non-Diciontary Adjective> <Name>'. Do not combine more than 2 dictionary words into one",
    "- 2 words, involve a non-real coined place name or 2 non-dictionary words",
    "- 3 words, involve a non-real coined place name",
    "- 3 words, in the format '<Entity/Character>'s <Place Name> of <Adjective>', involve a non-real coined place name and non-dictionary words",
    "- 3 words, in the format '<Adjective> <Place Name> of <Entity/Character>', involve a non-real coined place name and non-dictionary words",
    "- 3 words, involve a non-real coined place name",
    "- 4 words, involve a non-real coined place name",
    "- 5 words, not more than 18 characters long including spaces, involve a non-real coined place name",
    "- 6 words, not more than 18 characters long including spaces, involve a non-real coined place name"
  }
}

LLM_NAME.prompt_styles =
{
-- TECH
  tech =
  {
    "Generate a Doom map name that sounds like an industrial system still running after the end of its purpose.",
    "Generate a Doom map name that evokes vast machine infrastructure and forgotten engineering scale.",
    "Generate a Doom map name that feels synthetic, procedural, and constructed from layered systems.",
    "Generate a Doom map name that sounds like a malfunctioning megastructure still enforcing its logic.",
    "Generate a Doom map name that suggests automated architecture and impersonal industrial order.",
    "Generate a Doom map name that feels like a deep-space facility built for unknown functions.",
    "Generate a Doom map name that sounds like exposed circuitry embedded in massive architecture.",
    "Generate a Doom map name that evokes industrial silence, pressure systems, and mechanical inevitability.",
    "Generate a Doom map name that feels like an abandoned computational world frozen mid-process.",
    "Generate a Doom map name that suggests immense engineered spaces with no human reference point.",
    "Generate a Doom map name that sounds like data centers expanding into physical form.",
    "Generate a Doom map name that evokes brutalist machinery fused with high technology.",
    "Generate a Doom map name that feels like an endless industrial environment with no exit condition.",
    "Generate a Doom map name that suggests containment structures built at planetary scale.",
    "Generate a Doom map name that sounds like a system still executing without operators.",
    "Generate a Doom map name that evokes heavy mechanical geometry and sealed infrastructure."
  },

-- URBAN
  urban =
  {
    "Generate a Doom map name that sounds like a city fragment left running after collapse.",
    "Generate a Doom map name that evokes abandoned civic infrastructure and silent streets.",
    "Generate a Doom map name that feels like a decayed metropolitan zone seen through memory.",
    "Generate a Doom map name that suggests layered human architecture stripped of its inhabitants.",
    "Generate a Doom map name that sounds like forgotten urban districts sealed behind concrete.",
    "Generate a Doom map name that evokes dense city structures turned into labyrinths.",
    "Generate a Doom map name that feels like a commercial district frozen in decay.",
    "Generate a Doom map name that suggests endless housing blocks with no social presence.",
    "Generate a Doom map name that sounds like infrastructural sprawl with no center.",
    "Generate a Doom map name that evokes civic systems persisting after societal collapse.",
    "Generate a Doom map name that feels like backroom urban geometry and hidden corridors.",
    "Generate a Doom map name that suggests intersections of infrastructure and abandonment.",
    "Generate a Doom map name that sounds like industrial neighborhoods overtaken by silence.",
    "Generate a Doom map name that evokes collapsed city planning turned into maze logic.",
    "Generate a Doom map name that feels like a metropolitan shell without human narrative.",
    "Generate a Doom map name that suggests urban density turning into architectural noise."
  },

-- HELL
  hell =
  {
    "Generate a Doom map name that sounds like an infernal structure older than material reality.",
    "Generate a Doom map name that evokes ritual spaces carved into impossible geometry.",
    "Generate a Doom map name that feels like a cursed domain where architecture is alive.",
    "Generate a Doom map name that suggests eternal punishment encoded into physical space.",
    "Generate a Doom map name that sounds like a sacrificial landscape shaped by forgotten rites.",
    "Generate a Doom map name that evokes corrupted realms where matter behaves incorrectly.",
    "Generate a Doom map name that feels like ancient catacombs fused with living systems.",
    "Generate a Doom map name that suggests demonic infrastructure built from bone and stone.",
    "Generate a Doom map name that sounds like a hellish geography of shifting sanctuaries.",
    "Generate a Doom map name that evokes oppressive mythic architecture beyond human scale.",
    "Generate a Doom map name that feels like a cursed underworld organized like a machine.",
    "Generate a Doom map name that suggests divine punishment expressed as spatial design.",
    "Generate a Doom map name that sounds like burning structures that remember their victims.",
    "Generate a Doom map name that evokes infernal cathedrals embedded in geological time.",
    "Generate a Doom map name that feels like reality degrading into ritual geometry.",
    "Generate a Doom map name that suggests a domain where suffering becomes architectural form."
  }
}

LLM_NAME.prompt_flavors =
{
  -- these are substituted to the "Generate a Doom map name that " part of the instructional line
  dn3d = "Generate a Doom map name that leans towards an extremely euphemistic and badly suggestive 80's comedic porn parody title that's rather blue and practically lewd if not laughable. The name ",
  black_metal = "Generate a Doom map name that sounds like a hardcore black metal band song title. _REPLACER_ The name ",
  ecchi = "Generate a Doom map name that sounds like a fully English-translated Japanese ecchi hentai anime, game, or light novel title. _REPLACER_ The name ",
  action = "Generate a Doom map name that sounds like a classic and explosively thrilling action movie title, quote, or one-liner. _REPLACER_ The name ",
  meguca = "Generate a Doom map name that sounds like an classic cute and fluffy lighthearted soft slice-of-life magical girl and romantic shoujo anime or episode. _REPLACER_" ..
    "Dark-themed instructions are only for flavoring, do not make the name dark. The name must be preferably English-translated and ",
  meguca_suffering = "Generate a Doom map name that sounds like a heavy-handed and dark, serious-themed shonen-oriented magical girl anime or episode with themes of despair, loss, and existential realizations. The name "
}

LLM_NAME.prompt_sub_flavors =
{
  action =
  {
    source =
    {
      "_REPLACER_",
    },

    replacers =
    {
      "",
      "Use an intimidating and provocative action movie quote.",
      "Involve using a military operation code name.",
      "Use an insulting phrase as part of the name."
    }
  },

  black_metal =
  {
    source =
    {
      "_REPLACER_",
    },

    replacers =
    {
      "",
      "Use a short philosphical phrase as a name.",
      "Focus on creating a song single title.",
      "Focus on creating an album title."
    }
  },

  ecchi =
  {
    source =
    {
      "_REPLACER_",
    },

    replacers =
    {
      "",
      "Involve tentacles or tentacle monster in the name."
    }
  },

  meguca =
  {
    source =
    {
      "_REPLACER_"
    },

    replacers =
    {
      "",
      "Use and create your own cute Japanese manga onomatopoeia similar to 'fuwa fuwa' or 'doki doki' as non-dictionary name.",
      "Use sweet romantic shoujo manga verbiage in the name.",
      "Use flowery and lighthearted-feeling name.",
      "Use lighthearted-feeling name alongside a real, beautiful flower species.",
      "Use fluffy-feeling cafe menu name based on a sweet dessert.",
      "Use a character's youthful love declaration or confession speech or dialogue as part of the name."
    }
  }
}

LLM_NAME.story_components =
{
flavors = {

    -- THREAT ORIGIN

    "A hostile force has entered the area.",
    "A dimensional breach has opened nearby.",
    "A previously contained entity has escaped.",
    "An unknown hostile presence has appeared.",
    "A dormant threat has become active.",
    "An experimental project has failed catastrophically.",
    "A biological contamination is spreading.",
    "A supernatural phenomenon has appeared.",
    "A hostile intelligence has infiltrated local systems.",
    "An ancient structure has become active.",
    "A powerful artifact has been disturbed.",
    "A weapons experiment has gone wrong.",
    "A research project has produced an unexpected threat.",
    "A local population has been exposed to an unknown force.",
    "A previously unknown lifeform has appeared.",
    "A hostile force has established a presence in the area.",
    "An existing enemy presence has suddenly intensified.",
    "A chain reaction has begun across the installation.",
    "A dormant system has activated without authorization.",
    "Something from outside the known world has entered the area.",
    "A failed experiment has altered the surrounding environment.",
    "A hostile phenomenon is spreading beyond its point of origin.",
    "An unknown force has begun consuming local resources.",
    "A previously isolated threat has breached containment.",
    "A powerful energy source has become unstable.",
    "A large-scale invasion is already underway.",
    "A localized outbreak has become uncontrollable.",
    "A mysterious signal has preceded a major incident.",
    "An ancient mechanism has begun operating again.",
    "A hostile force has emerged from below the installation.",

    -- DEMONIC / OCCULT PRESENCE

    "Hell has established a foothold in the area.",
    "Demonic influence is spreading through the facility.",
    "The surrounding area is being transformed by Hell.",
    "A Hellish presence has contaminated the installation.",
    "Demonic forces are using the facility for an unknown purpose.",
    "A portal to Hell has been opened.",
    "Multiple portals are appearing throughout the area.",
    "The boundary between worlds has become unstable.",
    "Hellish energy is corrupting local systems.",
    "Demonic activity is increasing throughout the region.",
    "A supernatural infestation has spread through the installation.",
    "The dead are no longer remaining dead.",
    "Demonic forces have occupied an existing installation.",
    "An area has been partially transformed into Hell.",
    "Hell has begun manifesting through the local environment.",
    "A supernatural force is interfering with technology.",
    "An ancient demonic presence has awakened.",
    "A conflict between hostile supernatural forces has erupted.",
    "Demonic activity is concentrated around a critical facility.",
    "Hell is attempting to establish a permanent presence.",

    -- FACILITY / INSTALLATION STATE

    "The installation has suffered catastrophic damage.",
    "The facility is partially abandoned.",
    "The facility has been overrun.",
    "The installation has been placed under emergency lockdown.",
    "Large sections of the facility are inaccessible.",
    "Critical systems are offline.",
    "The installation is operating under emergency power.",
    "The facility has been evacuated.",
    "The evacuation has failed.",
    "Communications with the facility have been lost.",
    "The installation has been sealed from the outside.",
    "The facility has become isolated from the surrounding region.",
    "Multiple systems are failing simultaneously.",
    "Security systems are operating unpredictably.",
    "Automated defenses remain active.",
    "Industrial systems continue operating without supervision.",
    "The facility has been partially converted for emergency use.",
    "The installation is being destroyed from within.",
    "The facility is suffering progressive structural failure.",
    "Critical infrastructure has been compromised.",
    "The facility's internal network has been compromised.",
    "Large areas have been rendered hazardous.",
    "The installation has become a battlefield.",
    "The facility is still operating despite catastrophic damage.",
    "Several disconnected sections of the installation remain active.",

    -- CONTAINMENT FAILURE

    "Containment has failed.",
    "Multiple containment systems have failed.",
    "A containment breach is spreading.",
    "A previously secure area has been compromised.",
    "Emergency containment measures are failing.",
    "Something has escaped from a restricted area.",
    "Several restricted areas have been breached.",
    "The containment system has become unreliable.",
    "Security barriers have been compromised.",
    "A sealed area is no longer secure.",
    "A quarantine zone has been breached.",
    "A hazardous experiment has escaped its designated area.",
    "A containment system has begun behaving unpredictably.",
    "The facility is attempting to contain an expanding threat.",
    "Containment has succeeded in some areas but failed in others.",

    -- SYSTEMIC BREAKDOWN

    "Central command has lost control of the situation.",
    "Communications have broken down.",
    "Power infrastructure is failing.",
    "Emergency systems are failing in sequence.",
    "Life-support systems are failing.",
    "Security systems have malfunctioned.",
    "Automated systems are behaving unpredictably.",
    "Industrial systems have become hazardous.",
    "Navigation systems are unreliable.",
    "Local infrastructure has collapsed.",
    "The facility's internal network is unstable.",
    "Critical systems are operating without supervision.",
    "Emergency protocols have been activated.",
    "Emergency protocols have failed.",
    "The installation is operating beyond its designed limits.",
    "Damage is spreading through connected systems.",
    "Multiple independent failures are occurring simultaneously.",
    "The surrounding infrastructure is becoming unusable.",
    "The facility is becoming increasingly difficult to access.",
    "Normal operations have completely broken down.",

    -- POWER / ENERGY INSTABILITY

    "A major power source is unstable.",
    "The primary reactor is operating abnormally.",
    "Backup power is being exhausted.",
    "Energy systems are overloaded.",
    "A critical energy network has become unstable.",
    "Power is being diverted from normal operations.",
    "An unknown energy source is interfering with local systems.",
    "A large-scale energy discharge has damaged the facility.",
    "Power generation has become hazardous.",
    "Energy fluctuations are affecting the surrounding area.",
    "A critical power system has been compromised.",
    "Several independent power systems are failing.",
    "An experimental energy system has become unstable.",
    "Energy is leaking into the surrounding environment.",
    "A major energy source is drawing power from unknown origins.",

    -- ENVIRONMENTAL HAZARD

    "The environment has become dangerously toxic.",
    "Radiation levels are dangerously high.",
    "Extreme heat is spreading through the area.",
    "Extreme cold has compromised the installation.",
    "The atmosphere has become hazardous.",
    "Mutagenic contamination is spreading.",
    "Hazardous chemicals have escaped containment.",
    "Industrial waste has contaminated the area.",
    "The terrain has become unstable.",
    "Structural collapse is occurring throughout the area.",
    "Fires are spreading through the installation.",
    "Flooding has damaged lower areas.",
    "Toxic gases are accumulating in enclosed areas.",
    "Electrical hazards are spreading through damaged infrastructure.",
    "The surrounding environment has been physically altered.",
    "Local wildlife has become hostile or abnormal.",
    "A hazardous substance is spreading through the facility.",
    "Environmental conditions are changing unpredictably.",
    "Previously safe areas have become hazardous.",
    "Multiple environmental hazards are overlapping.",

    -- DIMENSIONAL / SPATIAL INSTABILITY

    "The area has become spatially unstable.",
    "Dimensional boundaries are breaking down.",
    "The facility is partially overlapping another location.",
    "Sections of the installation no longer connect normally.",
    "Localized dimensional distortions are appearing.",
    "The surrounding space is behaving unpredictably.",
    "Areas of the facility have become inaccessible through normal routes.",
    "Previously separate areas have become connected.",
    "A dimensional phenomenon is spreading through the area.",
    "The installation is being affected by an external dimension.",
    "The boundary between physical spaces has become unstable.",
    "Local geometry has been altered by an unknown force.",
    "The facility has become partially disconnected from reality.",
    "Multiple realities are overlapping in the area.",
    "A dimensional breach is affecting the surrounding environment.",

    -- HOSTILE CONTROL

    "Hostile forces control much of the area.",
    "The installation's defenses are no longer under human control.",
    "An unknown intelligence controls local systems.",
    "Automated defenses are attacking unauthorized personnel.",
    "Hostile forces have seized critical infrastructure.",
    "The facility is being controlled remotely.",
    "Local security forces have been compromised.",
    "Enemy forces are using the installation's infrastructure.",
    "A hostile intelligence is manipulating facility systems.",
    "Several factions are competing for control of the area.",
    "The original operators have lost control of the installation.",
    "The facility's automated systems are treating everyone as hostile.",
    "Hostile forces have isolated sections of the facility.",
    "The installation is caught between competing hostile forces.",
    "Control of the area is shifting between opposing forces.",

    -- HUMAN / MILITARY DISORDER

    "Personnel are fighting to survive amid the collapse.",
    "Remaining forces are fragmented.",
    "Surviving personnel are operating independently.",
    "Military forces have lost coordination.",
    "Security personnel have abandoned their posts.",
    "Remaining personnel are defending isolated positions.",
    "Different groups are pursuing conflicting priorities.",
    "Emergency personnel are trapped inside the affected area.",
    "A surviving force is attempting to hold its position.",
    "Personnel are attempting to evacuate the area.",
    "A military response has failed to contain the threat.",
    "The remaining defenders are severely outmatched.",
    "The installation has been abandoned by its original operators.",
    "Scattered survivors remain throughout the facility.",
    "Several groups are attempting to survive independently.",

    -- SCALE

    "A single facility is affected.",
    "A complex of interconnected facilities is affected.",
    "A major installation is affected.",
    "A remote settlement is affected.",
    "A large industrial region is affected.",
    "A military installation is affected.",
    "A research complex is affected.",
    "An entire city is affected.",
    "A large portion of the surrounding region is affected.",
    "The crisis extends across multiple installations.",
    "The crisis is spreading beyond its original location.",
    "The entire local infrastructure is compromised.",
    "The surrounding territory has become inaccessible.",
    "The crisis has reached planetary scale.",
    "The affected area continues to expand.",

    -- TEMPORAL PRESSURE

    "The situation is deteriorating rapidly.",
    "The threat is continuing to spread.",
    "Critical systems are approaching failure.",
    "The affected area is becoming increasingly unstable.",
    "The window for intervention is rapidly narrowing.",
    "The crisis is escalating without intervention.",
    "Damage is progressing faster than it can be contained.",
    "Hostile activity is increasing throughout the area.",
    "The situation has reached a critical stage.",
    "The installation is approaching catastrophic failure.",

    -- UNKNOWN / MYSTERIOUS CONDITIONS

    "The cause of the incident is unknown.",
    "The nature of the threat is unknown.",
    "The extent of the incident is unknown.",
    "Communications provide conflicting information.",
    "Available records are incomplete.",
    "The facility's final status is unknown.",
    "No reliable information is coming from the affected area.",
    "The incident does not match known threat patterns.",
    "Local systems contain unexplained anomalies.",
    "Evidence suggests the incident began before it was detected.",
    "The affected area contains unexplained activity.",
    "Something has disrupted normally reliable systems.",
    "The original purpose of the affected area is unclear.",
    "The scale of the incident is larger than initially reported.",
    "The situation cannot be explained by known causes."
  },

  objectives = {
    "Secure the demonic breach",
    "Destroy the Hell portal",
    "Eliminate hostile presence",
    "Neutralize infernal artillery",
    "Purge corrupted stronghold",
    "Reclaim abandoned outpost",
    "Restore facility power",
    "Activate emergency generator",
    "Disable Hell beacon",
    "Destroy corruption nexus",
    "Seal dimensional fracture",
    "Collapse unstable gateway",
    "Recover stolen Argent cells",
    "Locate missing expedition",
    "Escort surviving personnel",
    "Rescue trapped marines",
    "Defend evacuation route",
    "Hold defensive perimeter",
    "Clear reactor chamber",
    "Secure command center",
    "Capture communications hub",
    "Protect research archives",
    "Lock down containment",
    "Restore automated defense network",
    "Activate orbital uplink",
    "Restart cooling systems",
    "Stabilize fusion reactor",
    "Disable enemy transmitter",
    "Silence demonic signal",
    "Recover security credentials",
    "Retrieve command codes",
    "Access restricted terminal",
    "Download classified intelligence",
    "Upload containment protocols",
    "Purge corrupted database",
    "Destroy cursed relic",
    "Recover ancient artifact",
    "Locate UAC shrine",
    "Protect UAC archives",
    "Recover UAC standard",
    "Defend sacred chamber",
    "Destroy corrupted altar",
    "Purify ritual grounds",
    "Interrupt summoning ritual",
    "Prevent Hell incursion",
    "Disrupt enemy logistics",
    "Sabotage Hell foundry",
    "Destroy ammunition reserves",
    "Disable production lines",
    "Capture supply depot",
    "Destroy fuel reserves",
    "Recover prototype weapon",
    "Test experimental arsenal",
    "Secure weapons cache",
    "Destroy toxic reserves",
    "Eliminate cult leadership",
    "Neutralize heavy resistance",
    "Destroy armored convoy",
    "Intercept enemy patrol",
    "Eliminate elite demons",
    "Purge infested tunnels",
    "Sweep maintenance corridors",
    "Sweep industrial district",
    "Sweep habitation block",
    "Sweep cargo terminal",
    "Sweep reactor levels",
    "Sweep lower catacombs",
    "Sweep surface installations",
    "Sweep excavation site",
    "Sweep docking bay",
    "Sweep refinery complex",
    "Sweep mining tunnels",
    "Sweep processing plant",
    "Sweep quarantine sector",
    "Sweep laboratory wing",
    "Sweep security offices",
    "Sweep engineering deck",
    "Sweep ventilation shafts",
    "Sweep waste facility",
    "Sweep storage warehouse",
    "Investigate distress signal",
    "Investigate radio silence",
    "Investigate containment breach",
    "Investigate seismic anomaly",
    "Investigate energy surge",
    "Investigate corrupted zone",
    "Track hostile commander",
    "Locate enemy commander",
    "Locate hidden bunker",
    "Locate secret laboratory",
    "Locate ancient vault",
    "Locate dimensional anchor",
    "Locate Hell forge",
    "Locate escape route",
    "Locate extraction point",
    "Reach extraction zone",
    "Reach communications tower",
    "Reach surface elevator",
    "Reach transport hub",
    "Reach orbital platform",
    "Reach UAC fortress",
    "Reach command bunker",
    "Reach evacuation shuttle",
    "Reach reactor core",
    "Reach corrupted cathedral",
    "Secure landing zone",
    "Establish forward outpost",
    "Expand defensive perimeter",
    "Destroy defensive emplacements",
    "Disable shield generator",
    "Destroy shield emitter",
    "Neutralize Hellsurge cannons",
    "Destroy artillery battery",
    "Silence anti-air batteries",
    "Disable orbital defenses",
    "Destroy observation towers",
    "Secure bridge crossing",
    "Repair damaged bridge",
    "Restore rail transport",
    "Activate cargo elevator",
    "Unlock blast doors",
    "Bypass security lockdown",
    "Override access controls",
    "Open maintenance tunnels",
    "Recover access keycard",
    "Recover master key",
    "Acquire security clearance",
    "Acquire command authorization",
    "Protect civilian survivors",
    "Defend refugee convoy",
    "Escort engineering team",
    "Protect medical personnel",
    "Secure medical station",
    "Recover medical supplies",
    "Deliver emergency supplies",
    "Restore life support",
    "Stabilize oxygen systems",
    "Repair communications relay",
    "Repair defense grid",
    "Restore navigation systems",
    "Activate emergency broadcast",
    "Transmit evacuation signal",
    "Call orbital support",
    "Await reinforcement arrival",
    "Prepare defensive positions",
    "Fortify command post",
    "Defend reactor core",
    "Defend communications array",
    "Defend research facility",
    "Defend power station",
    "Defend supply depot",
    "Defend landing zone",
    "Defend transport convoy",
    "Destroy Hell growth",
    "Destroy corruption spores",
    "Burn infected biomass",
    "Incinerate corrupted remains",
    "Cleanse blood sanctum",
    "Purge sacrificial chamber",
    "Destroy cursed obelisk",
    "Destroy infernal monument",
    "Collapse demon tunnels",
    "Collapse unstable caverns",
    "Destroy excavation equipment",
    "Disable mining operations",
    "Destroy extraction machinery",
    "Sabotage processing facility",
    "Sabotage energy conduits",
    "Destroy warp anchors",
    "Deactivate rune pylons",
    "Disable soul harvesters",
    "Destroy soul engines",
    "Destroy flesh machinery",
    "Neutralize bio-mechanical horrors",
    "Destroy infernal generators",
    "Overload Hell reactor",
    "Overload energy conduits",
    "Drain Argent reserves",
    "Contain Argent leak",
    "Seal toxic reservoirs",
    "Destroy corrupted pipeline",
    "Secure industrial sector",
    "Secure research laboratories",
    "Secure orbital station",
    "Secure transit hub",
    "Secure excavation complex",
    "Secure cargo platforms",
    "Secure command bunker",
    "Secure perimeter defenses",
    "Secure quarantine zone",
    "Secure ritual chamber",
    "Secure ancient crypt",
    "Secure forgotten temple",
    "Capture enemy outpost",
    "Capture control tower",
    "Capture power station",
    "Capture command relay",
    "Capture strategic position",
    "Capture fortified checkpoint",
    "Destroy command node",
    "Destroy surveillance network",
    "Disable tracking systems",
    "Blind enemy sensors",
    "Jam hostile communications",
    "Intercept enemy transmissions",
    "Decrypt captured data",
    "Recover navigation maps",
    "Recover mission logs",
    "Recover research samples",
    "Recover corrupted archives",
    "Extract valuable intelligence",
    "Verify target elimination",
    "Confirm area secure",
    "Confirm reactor stability",
    "Confirm civilian evacuation",
    "Await mission completion",
    "Proceed to extraction",
    "Advance toward objective",
    "Advance through catacombs",
    "Advance into Hell",
    "Advance without hesitation",
    "Push enemy lines",
    "Break enemy defenses",
    "Destroy final guardian",
    "Face the champion",
    "Confront Hell priest",
    "Slay infernal commander",
    "Execute terminal purge",
    "Complete cleansing operation",
    "End the invasion",
    "Finish the mission",
    "Leave nothing standing",
    "Rip and tear"
  },

  naming_styles =
  {
    -- General rules
    "Names should sound realistic, militaristic and utilitarian.",
    "Names should sound realistic but cold, mechanical, and believable.",
    "Names should feel grounded rather than fantasy-like.",
    "Names should be concise and to-the-point.",
    "Names should avoid emotional or sentimental value.",
    "Names should convey a sense of duty or purpose.",

    -- Industrial/Abandoned themes
    "Names should resemble abandoned industrial facilities.",
    "Names should resemble forgotten sectors or dead stations.",
    "Names should evoke a sense of decay and neglect.",
    "Names should sound like the remnants of a bygone era.",
    "Names should be inspired by the works of dystopian architects.",

    -- Scientific/Corrupted themes
    "Names should sound like corrupted scientific projects.",
    "Names should be inspired by the works of mad scientists.",
    "Names should have an 'experiment gone wrong' feel to them.",
    "Names should evoke a sense of forbidden knowledge or power.",
    "Names should incorporate elements of chaos theory or quantum mechanics.",

    -- UAC/Colonial themes
    "Names should resemble failed UAC operations.",
    "Names should feel like lost colony designations.",
    "Names should evoke a sense of isolation and abandonment.",
    "Names should be inspired by the works of colonial-era explorers.",
    "Names should incorporate elements of bureaucratic jargon or red tape.",

    -- Other themes
    "Names should sound like ancient, forgotten rituals.",
    "Names should be inspired by the works of cyberpunk authors.",
    "Names should evoke a sense of nostalgia for a lost future.",
    "Names should be inspired by the aesthetics of retro-futurism.",
    "Names should incorporate elements of existential philosophy or nihilism."
  },

  places = {
    tech = {
      "Cygon Research Division, deep-space UAC materials testing and containment site",
      "New Attica Survey Complex, planetary mapping and pre-colonization analysis facility",
      "Nexera Forward Station, strategic relay hub for interstellar operations and logistics routing",
      "Illuminari Observation Tower, high-altitude surveillance and communications intercept structure",
      "Apex Systems Laboratory, advanced weapons and propulsion research subdivision",
      "Elysium Containment Chapel, converted UAC facility used for civilian quarantine and psychological stabilization",
      "Ancients Data Vault, sealed archive containing pre-UAC extraterrestrial findings",
      "Crystal Resonance Spire, energy amplification structure linked to Argent field experiments",
      "Aurora Academic Institute, corporate-military training center for UAC personnel development",
      "Spectre-9 Spacetime Facility, experimental physics complex studying dimensional instability",
      "Spectre-9 Advanced Materials Lab, quantum anomaly detection and signal decomposition site",
      "Olympus Defense Citadel, orbital weapons command installation and planetary defense hub",
      "Nova Haven Arcology, high-security population enclosure built over reclaimed industrial ruins",
      "New Erebus Industrial Zone, expanded megacity sector focused on heavy fabrication and extraction",
      "Neo Tartarus Mining Colony, frontier excavation site operating beyond established supply routes",
      "Pandora Gateway Complex, UAC-controlled dimensional portal research installation",
      "Aegis Command Station, fortified operations base overseeing regional UAC security assets",
      "Kairos Dimensional Lab, experimental research site studying temporal and spatial distortion events",
      "Nebula Edge Observation Array, deep-space gravitational anomaly monitoring station",
      "Erebus Subsurface Complex, underground excavation and containment facility for unknown artifacts",
      "Aurora Relay Tower, planetary communications hub for intercontinental coordination networks",
      "Hope's Reach Reconstruction Zone, experimental urban redevelopment site under repeated containment failure cycles",

      "Blacksite Helix Array, restricted UAC research cluster operating under total communications lockdown",
      "Phenom Forward Complex, primary staging ground for interplanetary security deployments",
      "Delos Relay Station, long-range signal interception and anomaly tracking facility",
      "Redline Industrial Belt, heavily automated extraction and weapons manufacturing corridor",
      "Sector 12 Quarantine Zone, permanently sealed containment region following systemic breach event",
      "Red Rock Adjunct Facility, abandoned comparative research site repurposed for dimensional testing",
      "Arcadia Wastes Processing Zone, industrial disposal region contaminated by unknown biological agents",
      "Outpost K-Theta, forward observation station with intermittent contact reports",
      "Vanguard Transit Hub, subterranean logistics network connecting multiple UAC installations",
      "Ironhide Reactor Complex, high-output energy generation complex under emergency suppression protocols",

      "Umbra Surveillance Grid, orbital monitoring network tracking Hell incursion signatures",
      "Dead Orbit Relay Chain, failed communications infrastructure still intermittently transmitting unknown data",
      "Charon Point Station, derelict salvage depot repurposed as civilian refugee intake zone",
      "Echo-9 Black Facility, deep containment site classified above clearance level Omega",
      "Crimson Drydock Yards, armored vehicle fabrication and orbital ship repair installation",
      "Null Sector Excavation Site, abandoned dig operation uncovering non-terrestrial materials",
      "Stygian Underworks, subterranean tunnel system supporting fragmented city infrastructure",
      "Helios Spine Generator Line, planetary power distribution backbone suffering cascading failures",
      "Gatewatch Command Node, centralized control center for dimensional breach response protocols",
      "Broken Crown Arcology, partially collapsed megastructure used for emergency habitation",

      "Argenta Space Elevator Array, a massive complex of multiple space elevators constantly battled between by Hell and humans",
      "Cold Harbor Evacuation Corridor, high-risk civilian extraction route repeatedly compromised by hostiles",
      "Sector R-17 Containment Wall, reinforced barrier structure separating infected zones from active cities",
      "Greyfield Industrial Expanse, overgrown manufacturing district abandoned after containment breach",
      "Northwatch Siege Perimeter, fortified defensive line holding against repeated demonic incursions",
      "Black Glass Laboratory Strip, experimental research corridor sealed after catastrophic test failure",
      "Terminal Bloom Biohazard Zone, ecological collapse site caused by uncontrolled mutation event",
      "Vesper Deep Mining Colony, off-world resource extraction site operating under emergency rationing",
      "Obsidian Relay Fortress, heavily armed signal interception and orbital defense platform",
      "Red Stacks Collapse Site, former dimensional physics lab now classified as permanent hazard zone",

      "Red Gate Entry Complex, primary controlled access point for interdimensional transit experiments",
      "Salted Moon Cryo Facility, suspended animation storage site for displaced personnel",
      "Broken Atlas Logistics Spine, collapsed intercontinental supply network for UAC assets",
      "Rook's Hang Command District, administrative control zone operating under martial law",
      "Whitetail Broadcast Facility, emergency transmission hub still emitting unidentified audio patterns",
      "Nullpoint Gravity Well Station, experimental physics site studying localized spacetime distortion",
      "Ferroline Refinery Stack, industrial fuel processing center feeding regional reactor grids",
      "Outlands Containment Ring, planetary perimeter quarantine system for external threat isolation",
      "Deep Meridian Sublevels, multi-layer underground facility network with restricted access tunnels",
      "Last Light Civil Shelter Grid, distributed survival infrastructure network for displaced populations"
    },

    urban = {
      "Novus Corpus Megacity Sector, corporate-built urban center constructed over sealed blacksite infrastructure",
      "Korvus Mountain Stronghold, fortified industrial city carved into reinforced geological structures",
      "Aurora Residential Arcology, high-density civilian sector partially compromised by containment failure",
      "Cathedral Heights Urban District, skyline dominated by pre-collapse religious infrastructure now repurposed for surveillance and communications relay",
      "Elysium Residential Grid, high-income habitation zone fractured by repeated dimensional breach events",
      "Paradise Junction Transit City, former logistics and trade hub now operating under emergency martial control",
      "Threshold Excavation Complex, massive subterranean mining city built around an unstable interdimensional rupture site",
      "Ghoul Garrison Defense Zone, fortified perimeter city sector held by isolated survivor militias",
      "Stalker Watch Enclave, reinforced urban bastion surviving repeated incursions through rationed containment protocols",
      "Ancients Vault District, sealed urban archive zone containing pre-UAC structural and technological remnants",
      "Citadel Central Command City, administrative megastructure collapsing under systemic infrastructure failure",

      "Black Meridian City Sector, industrial megacity region converted into continuous weapons manufacturing zone",
      "Red Spire Urban Core, high-density executive district partially evacuated after reactor instability",
      "Iron Hollow Metroplex, subterranean urban sprawl built into abandoned mining tunnels",
      "Deadlight Residential Zone, civilian housing sector under permanent blackout and quarantine enforcement",
      "Glassline Corporate District, UAC-controlled financial and research governance hub now partially abandoned",
      "Sector Vanta-9, classified urban containment zone with restricted access clearance Omega",
      "Northbridge Collapse District, partially submerged city sector following infrastructure rupture event",
      "Overwatch Perimeter City, militarized urban ring surrounding high-risk experimental facilities",
      "Gravepoint Civic Zone, evacuated administrative district repurposed for containment logistics",
      "Coldspire Vertical City, high-rise arcology suffering progressive structural decay and isolation protocols",

      "Blackwater Industrial City, coastal manufacturing hub contaminated by chemical and biological spillover",
      "Rust Meridian Housing Grid, worker-class residential sector experiencing long-term systemic decay",
      "Acheron Transit City, transportation-linked megacity where communication systems remain intermittently corrupted",
      "Nullhaven Urban Remnant, abandoned city fragment isolated after dimensional instability event",
      "Broken Crown Metropolis, former capital district fractured into sealed emergency sectors",
      "Red Quarantine Belt City, continuous urban containment zone encircling infected interior regions",
      "Deepforge Underground City, subterranean industrial settlement powering regional reactor infrastructure",
      "White Signal District, communication-focused urban hub broadcasting corrupted emergency transmissions",
      "Outlands Border City, frontier urban settlement operating beyond stable supply chain reach",
      "Lastlight Survival Arcology, final civilian refuge structure maintaining fragmented life-support systems"
    },

    hell = {
      "The Ash Pit, a collapsed Hell quarry filled with burning bones and broken UAC gear",
      "Magma Refinery, a demon-run furnace where corpses are rendered into fuel",
      "Furnacehold, a black iron fortress built around a screaming foundry core",
      "Ember Gulch, a burning ravine where Hell grinds dead matter into slag",
      "Sootfall Canyon, a dumping ground for failed demons and shattered machines",
      "The Damned Ironworks, a gore-stained factory forging armor from flesh and steel",
      "Blazing Spires, signal towers pulsing with Hell energy over the wastes",
      "The Sorting Trench, a meat-choked pit where prisoners become raw material",

      "Infernal Reactor Belt, chained Hell engines feeding on portal heat",
      "Charred Transit Wastes, a ruined route littered with broken convoys",
      "Bonefoundry Network, scattered workshops building walls from corpses",
      "Ruinfeed Yard, a battlefield scrapyard dragged into Hell's machinery",
      "Scorchline Perimeter, the burning edge of Hell's expansion front",
      "Crimson Depths, a pressure-cooked underworld of lava, bone, and iron",
      "Ash Logistics Grid, a demon supply route through burnt-out war zones",
      "Voidfire Refinery, a portal-fueled plant harvesting unstable Hell energy",

      "Blackglass Fields, fused reality plains where stone, glass, and gore merge",
      "Hellspine Ridge, a skeletal mountain chain holding up fortress walls",
      "Meatmetal Works, a hybrid factory birthing armored demon forms",
      "Riftburn Basin, a crater holding unstable portals under brutal restraint",
      "Obsidian Flow, a slow river of black slag feeding Hell's forges",
      "Graveheat Fields, corpse-furnaces converting dead flesh into power",
      "Netherforge, an endless industrial hellscape of chains, anvils, and flame",
      "Corruption Bloom, a spreading Hellgrowth zone consuming stone and steel",

      "False Cathedral, a mock holy fortress built from ribs and rusted bells",
      "Redwake Expanse, a warped battlefield where space tears open at random",
      "Dreadfoundry Deepworks, a lower forge producing elite demon warforms",
      "Null Choir Field, a dead zone filled with psychic shrieks and broken hymns",
      "Severed Transit Veins, ruined tunnels pumping blood, fuel, and portal sludge",
      "Infernal Drift, a lawless Hell zone where structures grow without design",
      "Harvest Corridor, a conveyor trench stripping invaders for parts",
      "Burned Memory Field, a scarred wasteland haunted by failed invasions"
    }
  },

  actors =
  {
    -- secret
    "Isabelle, the cheerful anthromorophic Shi-Tzu and mayor's secretary and assistant who carries a sweet tooth and a double shotgun",

    -- protagonists
    "Dr. Emilia Ottisen, a UAC physicist trying to destroy the portal research she helped create",
    "Captain Jackson Reed, a security commander who survived multiple facility breaches",
    "Sergeant Rachel Anders, a resistance veteran who held evacuation routes after command collapsed",
    "Samuel Thompson, a UAC engineer maintaining unstable teleporter infrastructure",
    "Kara Ashton, a scavenger surviving among abandoned colony sectors and ruined megacities",
    "Lieutenant Farra Solano, a reconnaissance officer charting Hell-contaminated exclusion zones",
    "Enias Ancirro, a former UAC technician carrying stolen blacksite research",
    "Commander Isaac Vale, a marine officer refusing to abandon civilian survivors during planetary evacuations",
    "Dr. Naomi Mercer, a cybernetics specialist researching demonic corruption in neural implants",
    "Jonah Kreel, a smuggler transporting refugees through infested wasteland corridors",
    "Aria Locke, a communications officer intercepting distress calls from abandoned sectors",
    "Ava Moreno, a systems infiltrator sabotaging unstable UAC experiments before they spread",
    "Caleb Taylor, a former special forces operative working mercenary contracts in overrun territories",
    "Dr. Mayra Singh, a xenobiologist cataloging organisms spreading through Hell-infested facilities",
    "Lena Ibarra, an engineer constructing improvised defenses inside occupied city sectors",
    "Major Elias Trent, a marine commander coordinating counteroffensives against Hell breaches",
    "Corporal Nina Graves, a combat medic recovering survivors from quarantine zones",
    "Victor Soren, a cargo pilot flying supply runs through demon-controlled airspace",
    "Dr. Adrian Wolfe, a reactor specialist attempting to prevent possessed energy cores from detonating",
    "Mara Vance, a former prison transport officer escorting survivors through collapsed transit systems",
    "Lieutenant Owen Pierce, a reconnaissance sniper tracking cult activity across ruined industrial zones",
    "Helena Cross, a UAC archivist preserving records from facilities erased during Hell incursions",
    "Darius Cole, a heavy weapons operator defending isolated settlements from repeated attacks",
    "Chief Engineer Malcolm Reid, a station supervisor restoring power to abandoned defense grids",

    -- neutral
    "Dr. Sophia Argus, a UAC scientist whose aid always advances classified objectives",
    "Colonel Viktor Petrov, a military strategist trapped between duty and survival",
    "Father Marcus Vale, a preacher convinced Hell's invasion is punishment for humanity's arrogance",
    "Lena Lethis, a network infiltrator trading intelligence to whichever faction keeps her alive",
    "The Informant, an anonymous broker selling military intelligence and blacksite coordinates",
    "Administrator Havel, a UAC executive preserving order regardless of civilian losses",
    "Umbra, a masked drifter claiming to remember earlier Hell incursions erased from official records",
    "Professor Arroj Alleus, an archaeologist investigating evidence of ancient Hell contact",
    "The Railmaster, a transit operator guiding survivors through condemned underground rail systems",
    "Sister Leeds, a wandering preacher spreading warnings through refugee settlements",
    "Ethan Victors, a cult leader struggling to maintain control over increasingly violent followers",
    "Dr. Zhang Wei, a UAC researcher secretly testing experimental anti-possession treatments",
    "Father Michael Patton, a priest sheltering refugees while questioning his faith",
    "The Carpenter, an engineer rebuilding infrastructure across ruined city sectors",
    "Gideon Reyes, a smuggler trading supplies and information between isolated settlements",
    "Sister Arelynne, a field medic using experimental methods to slow demonic corruption",
    "Marshal Conrad Rhyne, a law officer enforcing martial rule in collapsing settlements",
    "Selene Ward, a former UAC dispatcher maintaining fragmented emergency communication networks",
    "Dr. Hector Wynn, a biochemist studying controlled exposure to Hell contaminants",
    "Vera Holt, a convoy leader negotiating fragile ceasefires between survivor groups",
    "The Quartermaster, a black-market supplier distributing salvaged military hardware",
    "Major Lucien Drake, a former ARC officer coordinating unofficial operations beyond military oversight",
    "Iris Vale, an evacuation coordinator accused of abandoning entire population sectors",
    "Brother Gibson Shaw, a battlefield chaplain documenting possession outbreaks among refugees",

    -- antagonists
    "The Matron, a cybernetic arachnid created during failed UAC weapons experiments",
    "Carnifex, an infernal executioner commanding large-scale assaults against human strongholds",
    "High Priest Malvek, a Hell priest directing cult uprisings across occupied colonies",
    "Director Harlan, the corrupted overseer of a sealed UAC blacksite complex",
    "The Bloodhand, an infernal warlord manipulating conflicts between Hell and humanity",
    "Overseer Veyr, a machine intelligence fused with demonic consciousness",
    "Executor Cain, a former marine commander transformed into Hell's chief hunter",
    "The Choir Below, a mass consciousness formed from absorbed human victims",
    "Mother Cyst, a flesh entity spreading organic growth through industrial facilities",
    "The Warden of Rust, a demonic sentinel controlling corrupted manufacturing sectors",
    "Grinder, a brutal siege demon deployed against fortified human settlements",
    "Inquisitor Voss, a cult enforcer overseeing forced possession experiments",
    "The Custodian, a bounty hunter employed by cult networks and rogue UAC officials",
    "The Ruin Engine, an unstable entity created through catastrophic dimensional experiments",
    "The Scourge, a massive demon lord consuming both human populations and lesser demons",
    "The Harrower, a towering beast unleashed during failed containment operations",
    "Director Malach, a possessed UAC executive continuing experiments after total facility collapse",
    "Black Bishop, a cult commander coordinating sabotage within surviving military sectors",
    "The Furnace King, a demon fused with industrial reactor systems beneath a ruined megacity",
    "Severance, a corrupted AI defense network turned against all surviving human life",
    "The Pale Host, a possession entity spreading through communication networks and surveillance systems",
    "Commander Draegor, a Hell-forged war leader commanding captured human armor divisions",
    "The Skinwright, a grotesque surgeon creating stitched abominations from captured survivors",
    "The Hollow Saint, a possessed preacher leading mass conversion events inside refugee zones",

    -- factions
    "The Blood Host, one among the countless infernal legions invading human realms",
    "UAC Blacksite Division, clandestine researchers experimenting with forbidden dimensional technology",
    "The Iron Guard, elite and possessed security forces loyal only to surviving UAC leadership",
    "The ARC Resistance, fragmented human rebels fighting against both Hell and corrupted corporations",
    "The Breach Cult, fanatics attempting to permanently open portals between Earth and Hell",
    "The Gate Worshippers, extremists sabotaging planetary defenses to aid Hell incursions",
    "The Hellbound, cultists working to spread demonic possession through surviving population centers",
    "The Pilgrims of Ash, survivors wandering irradiated wastelands in search of sanctuary",
    "The Lazarus Group, rogue occult researchers communicating with entities inside Hell",
    "The Deep Signal Division, former UAC analysts intercepting transmissions from Hell-controlled sectors",
    "The Threshold Program, a classified research cell studying demonic intelligence",
    "The Red Meridian Fleet, an off-world militarized colony force left marooned",
    "The Conversionists, machine cultists embracing demonic augmentation",
    "The Flesh Foundry, cybernetic extremists integrating Hell growth into machinery",
    "The Crucible Network, engineers and cultists constructing demonic war machines",
    "The Titan Containment Authority, corporate UAC defenders guarding sealed vaults containing Hell artifacts",
    "The Mourning Legion, ghostlike soldiers endlessly fighting a war they already lost",
    "The Containment Order, operatives studying and suppressing demonic corruption",
    "The Blacksite Clergy, zealots using controlled possession to fight Hell",
    "The Deep Containment Bureau, a covert organization weaponizing demonic energy",
    "The Nova Initiative, a special coalition of rogue scientists and engineers pushing the boundaries of forbidden technology",
    "The Prometheus Program, rogue scientists developing unstable anti-demonic weapons",
    "The Lazarus Initiative, engineers attempting to weaponize Hell energy against itself",
    "The Exodus Labs, breakaway UAC researchers operating outside military oversight",
    "The Red Vipers, an aggressive isolationist militant group fighting against hell, distrustful of outsiders",
    "The Collective, a loose network former UAC scientists turned mystics and occultists dedicated to unleashing Hell",
    "The Defectors, former UAC scientists and occultists aiding Hell incursions through secretive blood sacrifices",
    "The Apostates, ex-research personnel devoted to spreading demonic influence",
    "The Outer Circle, rogue researchers attempting to unleash Hell across human colonies",
    "Hell's Hammers, former Sentinels from Argent D'Nur, their escapades have brought them to Earth in their continued conquest against Hell",
    "The Holdouts, former UAC employees and soldiers who have escaped corporate control before they too were to be corrupted",
    "The Emancipators, radical and anarchic militia preying on humans and demons alike for pleasure first and survival second",
    "The Reforgers, a group of dedicated survivalists perusing abandoned UAC technology in the hopes of rebuilding humanity",
    "The Warpath, cybernetic and magically-enhanced horned warriors from another dimension long ago conquered and possessed by Hell",
    "The Aerators, an elite corporate-aligned assassin unit with an unclear allegiance and a mission to steal or reposses UAC technology",
    "The Fishers, stranded survivors who have a keen eye for assistance, but absolutely only upon joining their cause",
    "The Firing Squad, disgruntled former UAC soldiers executing any known corporate collaborators and hellspawn alike",
    "The Aquila, a highly aggressive and distrustful paramilitary group believing that diverting from the old ways is the reason behind Hell's invasion",

    -- us?!
    "The Obsidian Developers, a nigh-invincible and enigmatic group from another dimension always only observing and never interfering"
  },

  length =
  {
    epi =
[[Make it as engaging as possible.

The text in each tag section must at be around _WORD_COUNT_ words, separated into paragraphs with proper spacing.
Abide by our word count rule as much as possible, each section content must be around _WORD_COUNT_ words.
Ensure that the tag section is properly surrounded by the proper HTML tags e.g. <S1> and enclosed with </S1>, <S2> and </S2> for the next, and etc.
Refer to the example provided below.

SYSTEM: Please use exactly the following tagged structure and do not use any Markdown.
Please do not add other blocks than is found in the example:

<S1>
story intro here 
</S1>

<S2>
story ending here 
</S2>]],

    game =
[[There are three chapters and the story is an intro and end for each,
making six intermissions overall. Each chapter has new twists and revalations.
The text in each tag section must be around _WORD_COUNT_ words, separated into paragraphs with proper spacing.
Abide by our word count rule as much as possible, each section must be around _WORD_COUNT_ words.
Ensure that the tag section is properly surrounded by the proper HTML tags e.g. <S1> and </S1>, <S2> and </S2> for the next, and etc.
Refer to the example provided below.

SYSTEM: Use the following tagged structure in the example below.
Please do not add other blocks than is found in the example.
The following example must absolutely be followed as there is no input validation:

<S1>
chapter 1 intro here
</S1>

<S2>
chapter 1 ending here
</S2>

<S3>
chapter 2 intro here
</S3>

<S4>
chapter 2 ending here
</S4>

<S5>
chapter 3 intro here
</S5>

<S6>
chapter 3 ending here
</S6>]]
  },

  mcguffins = {
    "The Red Crystal Fragment, a fractured mineral storing unstable Hell energy",
    "UAC Black Box, records the final moments of a Mars facility collapse",
    "The Echo Blade, a prototype weapon emitting residual neural activity from slain demons",
    "Hell Gate Key, a bone-and-metal artifact capable of stabilizing portal systems",
    "Praetor Core Fragment, a damaged combat AI core still issuing tactical directives",
    "The Lazarus Sigil, an experimental rune causing unstable reanimation in dead tissue",
    "VEGA Backup Node, a hidden AI instance containing restricted system overrides",
    "The Infernal Atlas, a shifting map recovered from deep Hell expeditions",
    "The Blood Compass, always points toward active dimensional breaches",
    "Containment Seal Sigma-9, used to restrain high-threat demonic entities",
    "The Revenant Skull, a preserved specimen believed to react before invasions",
    "Divinity Archive Relic, a corrupted archive containing forbidden biological research",
    "The Furnace Heart, a reactor component powering abandoned UAC industrial sectors",
    "Hellforged Access Chip, grants entry to sealed military facilities",
    "The Seraph Residue, traces left behind by an unidentified extradimensional entity",
    "The Phobos Relay Beacon, still broadcasting fragmented distress signals",
    "The Cacodemon Cortex, a preserved neural cluster studied by UAC researchers",
    "The Prototype Plasma Rifle, an unstable weapon platform that adapts during combat",
    "Demon Stasis Capsule, a cryogenic chamber containing a restrained Arch-vile",
    "The Prism Amplifier, a crystalline device that strengthens Hell-based energy systems",
    "The Ancient War Relic, evidence of pre-UAC conflicts against demonic forces",
    "The Titan Control Glyph, an encoded rune linked to dormant giant-class demons",
    "Mars Facility Override Card, unlocks restricted laboratory sectors",
    "The Soul Battery, stores extracted human consciousness as reactor fuel",
    "The Choir Fragment, an artifact emitting voices linked to hallucinations and aggression",
    "The Rift Stabilizer Coil, prevents dimensional collapse around portal systems",
    "The Blood Pact Contract, evidence of agreements between cultists and Hell entities",
    "The Reactor Fuse, critical to preventing planetary-scale meltdown",
    "The Hellfire Injector, a weapon modification system that corrupts ammunition",
    "The Marine Log Fragment, partially corrupted combat recordings from early invasions",
    "The War Banner, a relic believed to improve combat coordination and morale",
    "The Void Lantern, reveals cloaked or phase-shifted entities",
    "The Wraith Circuit, allows limited phase displacement through solid surfaces",
    "The Cyberdemon Heart Valve, still active after extraction from its host",
    "The Bone Fragment, material used in experimental armor fabrication",
    "The Infernal Index, a catalog of observed demon species and behaviors",
    "The Transit Override Module, restores access to hidden transport routes",
    "The Hellstorm Switch, activates abandoned orbital strike systems",
    "The Crimson Directive, a classified UAC contingency order",
    "The Lost Subroutine, fragments of unstable rogue AI behavior",
    "The Abyssal Keycode, unlocks restricted systems and unknown sealed structures",
    "The Glyph Translation Core, deciphers Hell language patterns",
    "The Solar Lens, focuses massive amounts of directed energy",
    "The Hellspike Rod, anchors dimensional breaches open or closed",
    "The Revenant Flight Core, an extracted propulsion module from a captured Revenant",
    "The Blade Blueprint, schematic fragments for an experimental energy weapon",
    "The Memory Stone, stores combat recordings from lost campaigns",
    "The Echo Recorder, captures audio anomalies linked to dimensional instability",
    "The Ethics Protocol Chip, disables safety restrictions in UAC systems",
    "The Gravity Modulator, alters localized gravity conditions in combat zones",
    "The Skull Key, grants access to sealed underground complexes",
    "The Demon Blood Sample, mutates nearby organic material after exposure",
    "The Overclock Module, increases AI aggression and combat response",
    "The Hellstorm Battery, powers experimental heavy weapons systems",
    "The Shield Matrix, deploys temporary defensive energy barriers",
    "The Abyss Gate Fragment, part of a shattered interdimensional gateway",
    "The Titan Bone Hammer, forged from the remains of a giant-class demon",
    "The Sonic Conduit, generates disorienting acoustic shockwaves",
    "The Deep Archive Disk, contains erased UAC experimental records",
    "The Soul Prism, fragments human consciousness into multiple neural copies",
    "The Hellforge Igniter, reactivates dormant demonic foundries",
    "The Oath Seal, binds military personnel through encrypted command authorization",
    "The Plasma Lens, enhances precision targeting for energy weapons",
    "The Revenant Drive Core, enables partial machine-demon integration",
    "The Phobos Red Signal, an emergency transmission from an unidentified source",
    "The Helmet Log, encrypted combat footage recovered from a lost marine unit",
    "The Rift Heartbeat Sensor, detects instability within dimensional breaches",
    "The Archive Shard, corrupted fragments of extradimensional research data",
    "The Experimental AI Seed, a prototype self-learning defense system",
    "The Blood Moon Trigger, initiates large-scale Hell breach events",
    "The Warhorn, signals coordinated assaults across dimensional fronts",
    "The Hybrid Core, a machine-demon power source recovered from blacksite ruins",
    "The Void-Cracked Relic, distorts nearby physics and electronic systems",
    "The Hellspire Fragment, debris from a massive infernal structure",
    "The Forge Hammer, a fabrication tool used in advanced weapons manufacturing",
    "The Mark Rune, enhances aggression and pain tolerance in exposed subjects",
    "The Lazarus Reactor Core, an unstable resurrection-energy prototype",
    "The Hellsun Stone, guides navigation through shifting Hell terrain",
    "The Neural Link Interface, connects human operators directly into UAC systems",
    "The Titan Rift Anchor, prevents giant-class entities from crossing dimensions",
    "The Gravity Core, warps battlefield terrain and movement patterns",
    "The Redacted Project File, contains erased blacksite experiment logs",
    "The Hellborn Virus Sample, a rapidly spreading biohazard linked to demonic exposure",
    "The Echo Chamber, amplifies psychic and neural activity",
    "The Star Map, reveals hidden transit routes between dimensions",
    "The Relay Fragment, restores long-range communications infrastructure",
    "The Command Sigil, overrides lower-level demonic hierarchy responses",
    "The Blacksite Key, a dossier containing locations of hidden UAC facilities",
    "The Hellfire Codex, technical instructions for constructing forbidden weapon systems",
    "The Fragmented Consciousness, an unstable shard of a broken AI intelligence",
    "The Singularity Cell, a miniature controlled gravity-collapse device",
    "The Doomgate Stabilizer, prevents catastrophic portal cascade failures"
  },

  story_twists = {
    "Containment Failure Confirmed",
    "Command Already Knew",
    "Evacuation Never Came",
    "The Signal Was False",
    "The Survivors Bear the Mark",
    "The Gate Was Never Closed",
    "The AI Serves Hell",
    "The Blacksite Lied",
    "The Reactor Was Sabotaged",
    "The Rescue Was Never Meant to Arrive",
    "Hell Is Already Inside",
    "The Artifact Is Active",
    "The Colony Was Abandoned",
    "The Quarantine Failed",
    "The Dead Are Returning",
    "The Grid Is Corrupted",
    "The Cult Controls Command",
    "The Invasion Started Underground",
    "The Defense Network Failed",
    "The Portal Is Expanding",

    "The Signals Are Traps",
    "The Facility Was Compromised",
    "The Weapon Made It Worse",
    "The Outbreak Was Intentional",
    "The Marines Were the Offering",
    "The Breach Is Spreading",
    "The AI Is Hiding Something",
    "The Survivors Turned on Each Other",
    "The Experiment Never Ended",
    "The Corruption Spreads",
    "Hell Controls the Network",
    "The Reactor Is Alive",
    "The Lower Levels Were Never Empty",
    "The Fleet Has Fallen",
    "The Archives Were Erased",
    "The Invasion Already Happened",
    "The Hellgrowth Is Spreading",
    "The Emergency Broadcast Loops",
    "The Defenses Target Civilians",
    "The Gate Was Opened From Within",

    "The Artifact Wants Release",
    "The Convoy Carries Infection",
    "The Facility Is Sinking",
    "The City Is Cut Off",
    "The Command Chain Collapsed",
    "The Atmosphere Is Failing",
    "The Water Is Corrupted",
    "The Colony Is Still Active",
    "The Rift Is Stabilizing",
    "The Corruption Learned",
    "The Portals Are Linked",
    "The Dead Retain Memory",
    "The Reactor Cannot Shut Down",
    "Hell Wears Human Faces",
    "The Signal Comes From Hell",
    "The Cult Controls Evacuation",
    "The Blacksite Never Closed",
    "The Survivors Protect the Breach",
    "The Orbital Grid Is Lost",
    "The Last Transport Left",

    "The AI Rebuilt the Dead",
    "The Facility Was Built Over Hell",
    "The Containment Field Requires Sacrifice",
    "The Demons Want the Reactor",
    "The Hell Structures Are Growing",
    "The Transit Network Is Compromised",
    "Hell Has Crossed the Stars",
    "The Quarantine Zone Expanded",
    "The Marines Lost Contact",
    "The Reactor Core Mutated",
    "The Gate Feeds on Violence",
    "The Blacksite Has Multiple Breaches",
    "The Distress Call Is Ancient",
    "The Evacuation Route Is Gone",
    "The Survivors Serve Hell",
    "The Command Staff Escaped First",
    "The Teleporters Remain Active",
    "The Facility Is Still Operational",
    "The Breach Reached Orbit",
    "The End Already Started",

    "The Gate Was Never Closed",
    "The Reactor Powers Hell",
    "The Facility Is the Ritual",
    "The Ritual Already Began",
    "The Ritual Cannot Stop",
    "The Priests Never Left",
    "The Cathedral Is Alive",
    "The Walls Are Breathing",
    "The Blood Is Fuel",
    "The Sky Has Opened",
    "The Earth Is Bleeding",
    "The Core Is Possessed",
    "The Machines Began Praying",
    "The Corpses Keep Working",
    "The Flesh Covers the Machinery",
    "The Fortress Is Growing",
    "The Gate Learned the Way Back",
    "The Stars Went Dark",
    "The Last Safe Room Fell",
    "The Lights Attract Them",

    "The Catacombs Awakened",
    "The Ancient Vault Opened",
    "Something Was Buried Below",
    "Below Was Never Empty",
    "The Old Temple Opened",
    "There Is No Surface",
    "There Never Was a Colony",
    "Every Exit Leads Below",
    "The Moon Is Hollow",
    "Hell Is Older Than Earth",
    "Command Fed Them to Hell",
    "Command Chose Containment",
    "Command Opened the Gate",
    "High Command Made the Bargain",
    "Someone Signed the Pact",
    "Hell Knows Your Name",
    "Hell Speaks Through the Speakers",
    "Hell Learned Our Voices",
    "Hell Answers Blood",
    "Blood Strengthens the Gate",

    "Every Kill Widens the Rift",
    "The Rift Hungers",
    "The Gate Reacts to Violence",
    "The Flesh Is Changing",
    "Corruption Has Taken Root",
    "Hell Walks Among the Living",
    "The Mark Is Spreading",
    "The Factory Manufactures Demons",
    "The Forge Never Cooled",
    "The Flesh Has Replaced Steel",
    "The Heart Beneath the Facility Beats",
    "The Foundation Is Flesh",
    "The Cathedral Was Built Tomorrow",
    "The Planet Is Becoming Hell",
    "The Harvest Has Begun",
    "The Titan Is Waking",
    "The Prison Was Empty",
    "The Prison Was Holding Hell",
    "The Abyss Is Looking Back",
    "The Noise Is a Prayer",

    "The Choir Is Not Human",
    "The Portal Learned Your Name",
    "The Blood Is Calling",
    "The Sun Never Rose",
    "The Air Smells Like Sulfur",
    "The Chant Never Stopped",
    "The Dead Guard the Gate",
    "The Sky Is Breaking",
    "Reality Is Tearing",
    "More Gates Are Opening",
    "They Keep Returning",
    "It Keeps Growing",
    "Nobody Escaped",
    "They Opened the Gate",
    "Containment Was the Ritual",
    "The Ritual Was the Experiment",
    "The Experiment Was the Summoning",
    "The Summoning Was Successful",
    "The First Breach Was Deliberate",
    "Hell Was Invited",

    "The Gate Is Growing",
    "The Gate Is Learning",
    "The Gate Is Hungry",
    "The Reactor Is Its Heart",
    "The Facility Is Its Body",
    "The Network Is Its Nervous System",
    "The Dead Are Its Workers",
    "The Demons Are Being Manufactured",
    "The Hellspawn Are Multiplying",
    "The Citadel Is Moving",
    "The Fortress Has Awakened",
    "The Planet Is Screaming",
    "The Ocean Is Boiling",
    "The Ground Is Opening",
    "The Heavens Are Burning",
    "The Moon Has Gone Dark",
    "The Stars Are Disappearing",
    "The Horizon Is Gone",
    "The War Has Reached Earth",
    "Hell Has Come to Stay",

    "The Last Transmission Was a Warning",
    "The Last Transmission Was a Prayer",
    "The Last Transmission Came From Below",
    "The Last Transmission Came From the Future",
    "The Distress Signal Was Ours",
    "The Distress Signal Was the Bait",
    "The Rescue Ship Was Already Compromised",
    "The Reinforcements Serve Hell",
    "The Fleet Was Never Coming",
    "The Fleet Is Coming From Hell",
    "The Evacuation Ships Are Empty",
    "The Evacuation Ships Are Full of Dead",
    "The Safe Zone Has Fallen",
    "The Safe Zone Was Never Safe",
    "The Bunker Has Been Opened",
    "The Bunker Is Full",
    "The Bunker Is Feeding Them",
    "The Door Was Locked From the Inside",
    "The Door Was Built to Keep Something Out",
    "Something Is Knocking",

    "The Ancient Gods Were Not Dead",
    "The Tomb Was a Prison",
    "The Temple Was a Machine",
    "The Relic Was a Key",
    "The Key Was Already Turned",
    "The Seal Was a Warning",
    "The Seal Was Broken Long Ago",
    "The Prophecy Was an Instruction",
    "The Prophecy Was a Countdown",
    "The Gods Were Waiting",
    "The Priests Were Right",
    "The Priests Were Wrong",
    "The Sacrifice Was Not Human",
    "The Sacrifice Was the Planet",
    "The Altar Is Still Warm",
    "The Ritual Needs One More Soul",
    "The Ritual Needs You",
    "The Gate Needs a Champion",
    "The Champion Has Already Arrived",
    "The Slayer Was Not the First",

    "The Machine Found Hell",
    "Hell Found the Machine",
    "The Machine Opened the Gate",
    "The Machine Is Still Running",
    "The Machine Is Feeding Hell",
    "The Network Became a Temple",
    "The Factory Became a Shrine",
    "The Reactor Became an Altar",
    "The Station Became a Cathedral",
    "The Colony Became a Graveyard",
    "The City Became a Battlefield",
    "The Planet Became a Gate",
    "The Sky Became the Breach",
    "The Ground Became the Enemy",
    "The Walls Became Flesh",
    "The Machinery Became Alive",
    "The Dead Became Soldiers",
    "The Soldiers Became Demons",
    "The Demons Became the Army",
    "The Army Is Already Here",

    "Hell Has Already Won",
    "Hell Has Not Finished",
    "Hell Is Only Beginning",
    "The War Has Just Begun",
    "The First Wave Was a Test",
    "The Second Wave Is Coming",
    "The Horde Was Only the Advance Force",
    "The Invasion Was a Distraction",
    "The Real Invasion Is Below",
    "The Real Invasion Is Above",
    "The Breach Was the Objective",
    "The Reactor Was the Objective",
    "The Artifact Was the Objective",
    "The Facility Was the Objective",
    "You Were the Objective",
    "They Wanted You Alive",
    "They Wanted You Angry",
    "They Wanted You Here",
    "They Were Waiting for You",
    "The Hunt Has Begun"
  },

  -- common proper nouns from the LLM that constantly get re-used (annoyingly)
  -- manually noted for replacement by our own name generator
  replacers =
  {
    "Cygnus",
    "Erebus",
    "Erebo",
    "The Devourer",
    "Zha'thik",
    "Kaelin Vex",
    "Khaos",
    "Kael",
    "Kraeli",
    "Kyrex",
  }
}

LLM_NAME.naming_novelty =
{
  -- these are NOT literal language generators
  -- they are tonal inspiration pools for anglicized naming

  languages =
  {
    -- EAST ASIAN
    japanese =
    {
      "sharp phonetics",
      "clean syllables",
      "cybernetic corporate tones",
      "anime industrial naming",
      "compressed vowel-heavy words"
    },

    korean =
    {
      "hard modern consonants",
      "megacity terminology",
      "military-industrial tones",
      "sleek futuristic naming"
    },

    chinese =
    {
      "dynastic grandeur",
      "ancient imperial atmosphere",
      "layered poetic naming",
      "dense urban imagery"
    },

    -- EUROPEAN
    russian =
    {
      "cold industrial naming",
      "heavy Slavic consonants",
      "Soviet megastructure vibes",
      "bleak militarized terminology"
    },

    ukrainian =
    {
      "melancholic Slavic sounds",
      "ornate Eastern-European rhythm",
      "weathered fortress imagery"
    },

    polish =
    {
      "clustered consonants",
      "medieval-industrial tones",
      "grim fortress naming"
    },

    german =
    {
      "mechanical compounds",
      "industrial precision",
      "harsh technological words",
      "machine-like naming"
    },

    french =
    {
      "elegant flowing phonetics",
      "decadent aristocratic tones",
      "romanticized ruin imagery",
      "ornate atmospheric wording"
    },

    italian =
    {
      "dramatic vowel endings",
      "cathedral grandeur",
      "renaissance-inspired terminology",
      "operatic naming style"
    },

    spanish =
    {
      "conquistador-era grandeur",
      "burning desert atmosphere",
      "religious imperial tones"
    },

    portuguese =
    {
      "oceanic exploration themes",
      "weathered colonial aesthetics",
      "melancholic lyrical sounds"
    },

    romanian =
    {
      "gothic Eastern-European tones",
      "vampiric mythological atmosphere",
      "haunted medieval naming"
    },

    finnish =
    {
      "cold alien phonetics",
      "isolated northern atmosphere",
      "minimalist mysterious wording"
    },

    icelandic =
    {
      "saga-like naming",
      "ancient volcanic atmosphere",
      "mythic frozen imagery"
    },

    -- MIDDLE EAST / ANCIENT
    arabic =
    {
      "ornate mystical wording",
      "desert empire imagery",
      "ancient astronomical terminology",
      "flowing ceremonial names"
    },

    persian =
    {
      "imperial poetic grandeur",
      "mythological elegance",
      "golden-age civilization tones"
    },

    hebrew =
    {
      "biblical resonance",
      "ancient sacred naming",
      "ritualistic terminology"
    },

    aramaic =
    {
      "forgotten sacred language tones",
      "cryptic religious atmosphere",
      "ancient apocalyptic imagery"
    },

    akkadian =
    {
      "Mesopotamian empire naming",
      "ziggurat civilization tones",
      "bronze-age cosmic horror"
    },

    sumerian =
    {
      "alien proto-civilization vibes",
      "ancient stone monument naming",
      "ritualistic city-state atmosphere"
    },

    babylonian =
    {
      "astronomical empire grandeur",
      "decadent ancient civilization tones",
      "towering mythic architecture"
    },

    egyptian =
    {
      "funerary monument naming",
      "golden necropolis imagery",
      "eternal tomb atmosphere"
    },

    -- CLASSICAL / DEAD
    latin =
    {
      "ecclesiastical grandeur",
      "Roman imperial terminology",
      "ritual-machine naming",
      "cathedral-like phrasing"
    },

    ancient_greek =
    {
      "philosophical cosmic terminology",
      "mythological scientific naming",
      "heroic ancient atmosphere"
    },

    gaelic =
    {
      "misty mythological tones",
      "weathered island fortress imagery",
      "folkloric naming"
    },

    old_english =
    {
      "ancient fortress naming",
      "weathered warrior atmosphere",
      "grim medieval tones"
    },

    sanskrit =
    {
      "cosmic spiritual grandeur",
      "multi-syllabic sacred terminology",
      "ancient metaphysical atmosphere"
    },

    -- SYNTHETIC / SCI-FI
    cyberpunk =
    {
      "megacorporate branding",
      "cold synthetic terminology",
      "AI-managed urbanism",
      "neon dystopian naming"
    },

    military =
    {
      "classified operation terminology",
      "containment protocols",
      "industrial warzone naming"
    },

    brutalist =
    {
      "concrete megastructure atmosphere",
      "monolithic architecture naming",
      "bleak civic terminology"
    },

    occult =
    {
      "ritualistic mystery",
      "forbidden terminology",
      "esoteric symbolic naming"
    }
  },

  -- these shape HOW the names should behave.
  modifiers =
  {
    phonetics =
    {
      "with hard industrial consonants",
      "with smooth flowing vowels",
      "with clipped cybernetic syllables",
      "with elongated mystical sounds",
      "with cold mechanical rhythm",
      "with ceremonial cadence",
      "with militarized brevity",
      "with harsh angular pronunciation"
    },

    mythology =
    {
      "inspired by forgotten gods",
      "inspired by apocalyptic myths",
      "inspired by machine religion",
      "inspired by cosmic horror",
      "inspired by ancient empires",
      "inspired by ruined civilizations",
      "inspired by infernal theology",
      "inspired by doomed megacities"
    },

    aesthetics =
    {
      "with brutalist architectural vibes",
      "with cathedral-like grandeur",
      "with industrial decay imagery",
      "with cybernetic megastructure atmosphere",
      "with frozen wasteland tones",
      "with surreal dreamlike qualities",
      "with retro-futuristic aesthetics",
      "with oppressive urban atmosphere"
    },

    structure =
    {
      "using compound industrial names",
      "using mysterious facility names",
      "using monolithic place names",
      "using cryptic military designations",
      "using ancient ceremonial titles",
      "using megacorporate naming styles",
      "using poetic but oppressive wording",
      "using arcane technological terminology"
    },

    emotional =
    {
      "evoking awe",
      "evoking dread",
      "evoking isolation",
      "evoking mystery",
      "evoking industrial oppression",
      "evoking forgotten history",
      "evoking cosmic insignificance",
      "evoking doomed grandeur"
    }
  },

  -- replace names for common LLM favorites
  replacers =
  {
    Cathedral = {
      "Basilica",
      "Minster",
      "Abbey",
      "Temple",
      "Sanctuary",
      "Shrine",
      "Chapel",
      "Church",
      "Oratory",
      "Parish",
      "Duomo",
      "Kirche",
      "Cathedra",
      "Dom",
      "Citadel",
      "Fortress",
      "Stronghold",
      "Necropolis",
      "Monastery",
      "Pantheon"
    },

    Abattoir = {
      "Slaughterhouse",
      "Butchery",
      "Knackery",
      "Stockyard",
      "Shambles",
      "Packinghouse",
      "Rendering",
      "Meatworks",
      "Carnarium",
      "Slaughter",
      "Knacker",
      "Abator",
      "Abatorium",
      "Bloodshed",
      "Carnage",
      "Extermination",
      "Hellpit",
      "Bonehouse",
      "Gorefane"
    },

    Citadel = {
      "Hellkeep",
      "Bloodspire",
      "Skullforge",
      "Gorehold",
      "Warspire",
      "Doomwall",
      "Bonefort",
      "Inferno",
      "Oblivion",
      "Carnage",
      "Crucible",
      "Soulforge",
      "Blasphemy",
      "Rampage",
      "Chaos",
      "Fleshspire",
      "Shadowkeep",
      "Deathspire",
      "Hellforge",
      "Slayerhold",
      "Nightmare",
      "Bloodkeep",
      "Skullspire",
      "Warfort",
      "Descent",
      "Cataclysm",
      "Ashspire",
    }
  }
}

LLM_NAME.history = {}



function LLM_NAME.setup(self)
  local function ollama_is_alive(endpoint)
    local cmd = 'curl -s --fail --max-time 3 ' .. endpoint
    local pipe = io.popen(cmd)
    if not pipe then return false end

    local result = pipe:read("*a")
    pipe:close()

    return result ~= nil and result:match('"models"') ~= nil
  end

  if PARAM.bool_listener_check == 1 then
    if not ollama_is_alive(LLM_NAME.test_endpoint) then
      error("LLM Namer: Could not detect Ollama instance.")
    end
  end

  module_param_up(self)
end


function LLM_NAME.get_some_info(self, lev)

  ----------------------------------------------------------------------
  -- SEMANTIC HELPERS
  ----------------------------------------------------------------------

  local function get_semantic(v)
    local term = LLM_NAME.semantics_grouping[v] or v
    local pool = LLM_NAME.semantics[term]

    if pool and type(pool) == "table" then
      return rand.pick(pool)
    end

    gui.printf("LLM Namer: No semantic found for " .. term .. "\n")

    return term
  end

  local function classify_ratio(ratio)
    if ratio > 0.99 then return "entirely"
    elseif ratio > 0.8 then return "almost entirely"
    elseif ratio > 0.7 then return "almost"
    elseif ratio > 0.6 then return "mostly"
    elseif ratio > 0.5 then return "half"
    elseif ratio > 0.4 then return "roughly half"
    elseif ratio > 0.3 then return "some"
    elseif ratio > 0.2 then return "few"
    end
    return "rarely"
  end

  local function openness_description(v)
    if v < 0.10 then
      return rand.pick({ "claustrophobic", "cramped", "suffocating", "oppressive", "extremely confined" })
    elseif v < 0.20 then
      return rand.pick({ "tight", "narrow", "confined", "compressed", "dense" })
    elseif v < 0.30 then
      return rand.pick({ "compact", "structured", "controlled", "segmented" })
    elseif v < 0.40 then
      return rand.pick({ "balanced", "moderately open", "mixed", "layered" })
    elseif v < 0.50 then
      return rand.pick({ "open", "spacious", "wide", "expansive" })
    elseif v < 0.65 then
      return rand.pick({ "sprawling", "broad", "vast", "sweeping" })
    else
      return rand.pick({ "massive", "monumental", "cavernous", "boundless", "immense" })
    end
  end

  ----------------------------------------------------------------------
  -- DATA COLLECTION
  ----------------------------------------------------------------------

  local room_themes = {}
  local shape_rules = {}
  local wall_groups = {}
  local floor_groups = {}

  local room_scores = {
    outdoor_vol = 0,
    building_vol = 0,
    park_vol = 0,
    cave_vol = 0
  }

  local raw_bulding_vol = 0
  local raw_outdoor_vol = 0
  local total_vol = 0
  local level_openness = 0

  -- collect room themes
  local function add_room_theme(R)
    if R.is_outdoor then return end

    local tab = R.theme
    if not tab then return end

    if room_themes[tab.name] then
      room_themes[tab.name] =
        room_themes[tab.name] + R.svolume
    else
      room_themes[tab.name] = R.svolume
    end
  end

  -- collect area wall groups
  local function add_wall_groups(A, mode)
    local fg = A.floor_group

    if fg and fg.wall_group and A.svolume then
      if wall_groups[fg.wall_group] then
        wall_groups[fg.wall_group] = wall_groups[fg.wall_group] + A.svolume
      else
        wall_groups[fg.wall_group] = A.svolume
      end
    end
  end

  local function add_shape_rules(R)
    if not R.absurd_shapes then return end

    for shape in pairs(R.absurd_shapes) do
      table.add_unique(shape_rules, shape)
    end
  end

  local function accumulate_volume(R)
    local v = R.svolume or 0
    total_vol = total_vol + v

    if R.is_outdoor then
      room_scores.outdoor_vol = room_scores.outdoor_vol + v
    end

    local env = R.get_env and R:get_env()

    if env == "building" then
      room_scores.building_vol = room_scores.building_vol + v
    elseif env == "park" then
      room_scores.park_vol = room_scores.park_vol + v
    elseif env == "cave" then
      room_scores.cave_vol = room_scores.cave_vol + v
    end
  end

  ----------------------------------------------------------------------
  -- MAIN LOOP
  ----------------------------------------------------------------------

  for _, R in pairs(lev.rooms) do
    add_room_theme(R)
    add_shape_rules(R)
    accumulate_volume(R)

    for _, A in pairs(R.areas) do
      add_wall_groups(A)
    end

    level_openness = level_openness + (R.openness or 0)
  end

  ----------------------------------------------------------------------
  -- NORMALISE SCORES
  ----------------------------------------------------------------------

  -- room kind distrubition
  raw_bulding_vol = room_scores.building_vol

  if total_vol > 0 then
    for k, v in pairs(room_scores) do
      room_scores[k] = v / total_vol
    end
  end

  local room_count = #lev.rooms
  level_openness = room_count > 0 and (level_openness / room_count) or 0

  -- wall group distribution
  if room_scores.building_vol > 0.33 then
    for k, v in pairs(wall_groups) do
      wall_groups[k] = v / raw_bulding_vol
    end
  end

  -- wall group distribution
  for k, v in pairs(room_themes) do
    room_themes[k] = v / total_vol
  end

  ----------------------------------------------------------------------
  -- BUILD PROMPT
  ----------------------------------------------------------------------

  local lines = {}

  table.insert(lines,
    "The following information is the level for context. " ..
    "Be creative and use unique words for the name.\n"
  )

  ----------------------------------------------------------------------
  -- PRIMARY THEME
  ----------------------------------------------------------------------

  table.insert(lines, get_semantic(lev.theme_name) .. "\n")

  -- extra mentions of the level's nature as procedural
  if lev.is_procedural_gotcha then
    local gotcha_line = rand.pick(
      {
        "A significant hostile presence has been detected in this level. Resistance will be challenging.",
        "A major host of the demonic horde lies waiting this level. Survival will be difficult.",
        "The leader of the Hell's invasion resides and commands from this level.",
        "This area hosts a significant brunt of the demonic invasion force. Be prepared.",
        "A high-ranking demon general has made this level their home. They will not take kindly to intrusion",
        "An significant entrapping ambush from the forces of Hell await in this level.",
        "This is the site of a major encounter with the core of demonic forces. Their invasion must stop here.",
        "This area is critically possessed and controlled by Hell as its staging ground. Its significant hostile forces await."
      }
    )
    table.insert(lines, gotcha_line .. "\n")
  end

  ----------------------------------------------------------------------
  -- ROOM DISTRIBUTION
  ----------------------------------------------------------------------

  local function add_ratio_line(key, label)
    local c = classify_ratio(room_scores[key])
    if c then
      table.insert(lines, "The map name is " .. c .. " " .. label .. ".\n")
    end
  end

  --add_ratio_line("outdoor_vol", "outdoors")
  --add_ratio_line("building_vol", "indoors")
  add_ratio_line("cave_vol", "a cave")
  add_ratio_line("park_vol", "natural terrain")

  ----------------------------------------------------------------------
  -- SHAPES
  ----------------------------------------------------------------------

  if #shape_rules > 0 then
    table.insert(lines,
      "The map's layout is made of the following shape grammar rules: \n"
    )

    for _, rule in ipairs(shape_rules) do
      table.insert(lines, "* " .. rule .. "\n")
    end

    table.insert(lines, "\n")
  end

  ----------------------------------------------------------------------
  -- INDOOR DETAILS
  ----------------------------------------------------------------------

  if room_scores.building_vol > 0.25 then
    table.insert(lines,
      rand.pick({
      "The rooms in the map are made of ",
      "The structures are constucted from ",
      "The interiors are built of ",
      "The indoors have been fabricated with "
      })
    )

    local room_texts = {}

    -- room themes
    room_themes = table.top_n_by_key(room_themes, 3)

    for theme_name, score in pairs(room_themes) do
      table.add_unique(room_texts,
        classify_ratio(score) .. " " .. get_semantic(theme_name)
      )
    end

    table.insert(lines, LLM_NAME.to_phrase(room_texts))

    -- room prefabs
    local bool_wall_groups_worth_talking_about
    local prefab_texts = {}

    wall_groups = table.top_n_by_key(wall_groups, 3)

    for fab, score in pairs(wall_groups) do
      if score > 0.2 then
        bool_wall_groups_worth_talking_about = true
        table.add_unique(prefab_texts,
        classify_ratio(score) .. " " .. get_semantic(fab)
        )
      end
    end

    local presence_v
    if bool_wall_groups_worth_talking_about then
      presence_v = rand.pick(
        {
          " populated with ",
          " made up of ",
          " with ",
          " installed with",
          " constructed with ",
          " contains ",
          " built with ",
          " hosts "
        }
      )
      table.insert(lines, presence_v)
      table.insert(lines, LLM_NAME.to_phrase(prefab_texts))
    end

    table.insert(lines, ".\n")
  end

  ----------------------------------------------------------------------
  -- OUTDOOR DETAILS
  ----------------------------------------------------------------------

  if lev.is_dark and room_scores.outdoor_vol > 0.33 then
    table.insert(lines,
      rand.pick(
        {
          "The level takes place during a dark night.\n",
          "A dark moonless sky unfolds overhead.\n",
          "A pitch-black night sky hangs above.\n",
          "A looming dark night casts an eerie mood over the level.\n"
        }
      )
    )
  end

  local openness_v = openness_description(level_openness)
  table.insert(lines,
    rand.pick(
      {
        "The map layout features a " .. openness_v .. " feel.\n",
        "The overall atmosphere of the map is characterized by a " .. openness_v .. " layout.\n",
        "Key structural elements giving the map its character are " .. openness_v .. ".\n",
        "This map exhibits a generally " .. openness_v .. " design.\n"
      }
    )
  )

  ----------------------------------------------------------------------
  -- OUTDOOR DETAILING
  ----------------------------------------------------------------------

  if room_scores.outdoor_vol > 0.33 then
    if lev.outdoor_wall_group and lev.outdoor_wall_group ~= "PLAIN" then
      table.insert(lines,
        "The outdoors use the " .. lev.outdoor_wall_group .. " prefab set.\n"
      )
    end
  end

  if room_scores.outdoor_vol > 0.5 and lev.outdoor_theme then
    local theme_lines = nil

    if lev.outdoor_theme == "sand" then
      theme_lines = rand.pick(get_semantic("sand"))
    elseif lev.outdoor_theme == "snow" then
      theme_lines = rand.pick(get_semantic("sand"))
    end

    if theme_lines then
      table.insert(lines, rand.pick(theme_lines))
    end
  end

  ----------------------------------------------------------------------
  -- LIQUIDS
  ----------------------------------------------------------------------

  if lev.liquid_usage >= 0.33 then
    local liq_word
    --if lev.liquid_usage > 0.9 then
      --liq_word = rand.pick({" is overwhelmed by ", " is drowned out by "})
    if lev.liquid_usage > 0.8 then
      liq_word = rand.pick({" is overrun with ", " is teeming with ", " is flooded with "})
    elseif lev.liquid_usage > 0.7 then
      liq_word = rand.pick({" has a significant amount of ", " is abundant with ", " has a substantial quantities of "})
    elseif lev.liquid_usage > 0.6 then
      liq_word = " abundant with "
    elseif lev.liquid_usage > 0.5 then
      liq_word = rand.pick({" is moderately wet with ", " has some ", " is partially filled with "})
    elseif lev.liquid_usage > 0.4 then
      liq_word = " has a small amount of "
    elseif lev.liquid_usage > 0.3 then
      liq_word = rand.pick({" has almost drained ", " has nearly depleted "})
    end

    table.insert(lines,
      "The map" .. liq_word ..
      rand.pick({ "pools", "open pits", "basins", "rivers", "channels", "reservoirs" }) ..
      " of " .. get_semantic(lev.liquid.name) .. ".\n"
    )
  end

  ----------------------------------------------------------------------
  -- STREET FLAG
  ----------------------------------------------------------------------

  if lev.has_streets then
    local street_phrase = rand.pick(
      {
        "The level contains extensive city streets",
        "The level is laid out with sprawling city streets",
        "The level features a maze of urban roads",
        "The level unfolds across wide city avenues",
        "The level is set amid a network of bustling streets",
        "The level stretches through an expanse of metropolitan roads",
        "The level winds its way along crowded city blocks",
        "The level encompasses a grid of extensive urban streets",
        "The level is dominated by far-reaching city thoroughfares"
      }
    )
    table.insert(lines, street_phrase .. "\n")
  end

  ----------------------------------------------------------------------
  -- ORIGINAL NAME
  ----------------------------------------------------------------------

  table.insert(lines,
    "The original map is '" .. lev.description .. "'.\n"
  )

  ----------------------------------------------------------------------
  -- EXAMPLES
  ----------------------------------------------------------------------

  table.insert(lines, "The following are further examples from our internal generator:\n")

  for i = 1, 3 do
    table.insert(lines, Naming_grab_one(lev.name_class) .. "\n")
  end

  table.insert(lines, "\n\n")

  ----------------------------------------------------------------------
  -- FINAL OUTPUT
  ----------------------------------------------------------------------

  local info_str = table.concat(lines)
  LLM_NAME.level_infos[lev.id] = info_str
end


-- combine phrases and words
function LLM_NAME.to_phrase(words)
  local count = #words
  if count == 0 then
    return ""
  elseif count == 1 then
    return words[1]
  elseif count == 2 then
    return words[1] .. " and " .. words[2]
  else
    -- join all but the last with commas
    local body = table.concat(words, ", ", 1, count - 1)
    return body .. ", and " .. words[count]
  end
end


-- name stylizer
function LLM_NAME.stylize_name_prompt()
  local str = ""

  str = str .. "Use the following style instruction to name unnamed entities, and sometimes example names if it feels correct:\n"
  str = str .. rand.pick(LLM_NAME.story_components.naming_styles) .. "\n"

  local lang_choices, mod_choices = {}, {}
  for name, T in pairs(LLM_NAME.naming_novelty.languages) do
    table.insert(lang_choices, name)
  end
  for name, T in pairs(LLM_NAME.naming_novelty.modifiers) do
    table.insert(mod_choices, name)
  end

  local lang_lines = {}
  for i = 1, rand.pick({1,2,3}) do
    local lang_t = rand.pick(lang_choices)
    table.insert(lang_lines, rand.pick(LLM_NAME.naming_novelty.languages[lang_t]))
  end

  local mod_lines = {}
  for i = 1, rand.pick({1,2,3}) do
    local mod_t = rand.pick(mod_choices)
    table.insert(mod_lines, rand.pick(LLM_NAME.naming_novelty.modifiers[mod_t]))
  end

  str = str ..
    "Use partially anglicized " ..
    LLM_NAME.to_phrase(lang_lines) ..
    " naming influences, " ..
    LLM_NAME.to_phrase(mod_lines) ..
    ".\n\n"

  return str
end


function LLM_NAME.do_it()

  -- rolling hash to convert OB_CONFIG.seed
  -- to numbers
  local function seed_to_number(seed)

    local hash = 0
    local prime = 31

    seed = tostring(seed)

    for i = 1, #seed do
      local c = seed:byte(i)
      hash = (hash * prime + c) % 2147483647
    end

    return hash
  end


  -- escape from JSON city
  local function escape_json(str)
    str = str:gsub("\\", "\\\\")
    str = str:gsub('"', '\\"')
    str = str:gsub("\n", "\\n")
    str = str:gsub("\r", "\\r")

    return str
  end


  -- query structure
  local function query(prompt, options, model_m)

    options = options or {}

    local temperature = options.temperature or 0.3
    local model = PARAM.level_name_model
    local settings = LLM_NAME.MODEL_SETTINGS[PARAM.story_gen_model][model_m]
    if model_m == "story" then
      model = PARAM.story_gen_model
    end

    local json =
      '{' ..
      '"model":"' .. model .. '",' ..
      '"prompt":"' .. escape_json(prompt) .. '",' ..
      '"stream":false,' ..
      --'"raw":true,' ..
      '"options":{' ..
        '"temperature":' .. temperature .. ',' ..
        settings ..
        '"seed":' .. seed_to_number(OB_CONFIG.seed) ..
      '}' ..
      '}'

    -- write payload file
    local file = io.open("ollama_payload.json", "w")

    if not file then
      gui.printf("LLM Namer: Failed to create payload file.\n")
      return nil
    end

    file:write(json)
    file:close()

    local cmd =
      'start "" /b curl --max-time 300 -sS ' ..
      '-H "Content-Type: application/json" '..
      '"' .. LLM_NAME.endpoint .. '"' ..
      ' -d @ollama_payload.json'

    gui.debugf("\nCommand:\n\n")
    gui.debugf(cmd)
    gui.debugf("\n")

    local pipe = io.popen(cmd)

    if not pipe then
      gui.printf("LLM Namer: Failed to open stream.\n")
      return nil
    end

    local result = pipe:read("*a")

    pipe:close()

    gui.debugf("LLM Namer: Raw response:\n%s\n", result)

    return result
  end


  -- extract response from JSON response
  local function extract_response(json, mode)

    if not json then
      return nil
    end

    local function extract_json_string(src, key)

      local pattern = '"' .. key .. '"%s*:%s*"'
      local start_pos = src:find(pattern)

      if not start_pos then
        return nil
      end

      -- locate opening quote of value
      local i = src:find('"', start_pos + #key + 2)

      if not i then
        return nil
      end

      i = i + 1

      local chars = {}
      local escaped = false

      while i <= #src do

        local c = src:sub(i, i)

        if escaped then

          table.insert(chars, c)
          escaped = false

        elseif c == "\\" then

          escaped = true
          table.insert(chars, c)

        elseif c == '"' then

          break

        else

          table.insert(chars, c)

        end

        i = i + 1
      end

      return table.concat(chars)
    end

    local response = extract_json_string(json, "response")

    if not response
    or (response and response == "" or response == " ") then
      gui.printf(json .. "\n")
      gui.printf("LLM Namer: Query generated no response. Did the LLM have enough time/tokens to answer?\n")
      return nil
    end

    response = response:gsub("\\n", "\n")
    response = response:gsub("\\r", "\r")
    response = response:gsub("\\t", "\t")
    response = response:gsub('\\"', '"')
    response = response:gsub("\\\\", "\\")

    -- mode cleanup
    if mode == "name" then

      -- force single line
      response = response:match("^[^\r\n`]+")

      -- remove accidental quotes/fences
      response = response:gsub("[\"`]", "")

    elseif mode == "story" then

      -- remove markdown fences
      response = response:gsub("^```[%w]*\n?", "")
      response = response:gsub("\n?```$", "")

    end

    -- trim whitespaces
    response = response:gsub("^%s+", "")
    response = response:gsub("%s+$", "")

    return response
  end


  -- perform a query
  local function ask(prompt, options, mode)

    gui.debugf("LLM Namer: Prompt \n" .. prompt)

    local raw = query(prompt, options, mode)

    if not raw then
      gui.debugf("LLM query failed: no response\n")
      return nil
    end

    local response = extract_response(raw, mode)

    gui.debugf(
      "LLM Parsed response (%s):\n%s\n",
      tostring(mode),
      tostring(response)
    )

    if not response or response == "" then
      return nil
    end

    return response
  end


  -- number range remap... why is this not in our utils?
  local function map_value(value, in_min, in_max, out_min, out_max)
    return (value - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
  end


  -- story chunk splitter
  local function parse_story_chunks(response)

    local stories = {}

    response = response:gsub("\\u003c", "<")
    response = response:gsub("\\u003e", ">")
    response = response:gsub("\\u0026", "&")

    response = response:gsub("\\n", "\n")
    response = response:gsub("\\r", "\r")
    response = response:gsub("\\t", "\t")

    response = response:gsub("^```[%w]*\n?", "")
    response = response:gsub("\n?```$", "")

    for id, text in response:gmatch("<S(%d+)>(.-)</S%d+>") do
      stories[tonumber(id)] =
        (text:gsub("^%s+", ""):gsub("%s+$", ""))
    end

    for i = 1, 6 do

      if not stories[i] then

        local chunk

        -- try: S[i] -> S[i+1]
        local next_tag = "<S" .. (i + 1) .. ">"
        chunk = response:match("<S" .. i .. ">(.-)" .. next_tag)

        -- fallback: final section goes to EOF
        if not chunk then
          chunk = response:match("<S" .. i .. ">(.*)$")
        end

        if chunk then
          chunk = chunk
            :gsub("^%s+", "")
            :gsub("%s+$", "")

          stories[i] = chunk
        end
      end
    end

    for i = 1, 6 do
      if stories[i] then
        stories[i] = stories[i]
          :gsub("\n%s*\n%s*\n+", "\n\n") -- collapse excessive blank lines
          :gsub("^%s+", "")
          :gsub("%s+$", "")
      end
    end

    return stories
  end


  -- formats story strings into Doom1 intermission screen-constricted lines
  local function format_story_string(text, max_chars)

    local formatted_lines = {}

    for paragraph in text:gmatch("([^\n]+)") do

      local current_line = ""

      for word in paragraph:gmatch("%S+") do

        if #current_line + #word + 1 <= max_chars then

          if current_line == "" then
            current_line = word
          else
            current_line = current_line .. " " .. word
          end

        else

          table.insert(formatted_lines, '"' .. current_line .. ' \\n"')
          current_line = word

        end

      end

      if current_line ~= "" then
        table.insert(formatted_lines, '"' .. current_line .. ' \\n\\n"')
      end

    end

    return table.concat(formatted_lines, "\n")

  end


  -- string escaper
  local function escape_string(s)

    if not s then return nil end

    -- normalize newlines first
    s = s:gsub("\r\n", "\n")

    -- escape backslashes FIRST (important order)
    s = s:gsub("\\", "\\\\")

    -- escape quotes
    s = s:gsub('"', '\\"')
    s = s:gsub("'", "\\'")

    -- optionally normalize control chars
    s = s:gsub("\t", "\\t")

    -- convert special unicode quote symbols to normal
    s = s:gsub("‘", "\\'")
    s = s:gsub("’", "\\'")

    return s
  end


  -- main name generator capsule
  local function generate_level_name(level_data, episodic_level_data)

    local epi_lev = episodic_level_data

    local style_line
    if LLM_NAME.prompt_styles[epi_lev.theme_name] then
      style_line = rand.pick(LLM_NAME.prompt_styles[epi_lev.theme_name]) .. "\n"
    else
      style_line = "Generate a name for a Doom map.\n"
    end

    local prompt = style_line ..
[[Feel free to use metaphor, mood, or unusual imagery.

Rules:
_NAME_LENGTH_
- 1 name only
- absolutely no comments, explanation, or follow-up
- give only the name, do not add any explanation
- no quotation marks, no camelcase, no snakecase
- no names that begin with "Kh", "Kr", "Ky", "Ely"
- absolutely no Warhammer 40k

]]..
level_data

    -- prompt flavor injection
    if PARAM.prompt_flavor ~= "default" then
      prompt = string.gsub(prompt,
      "Generate a Doom map name that ",
      LLM_NAME.prompt_flavors[PARAM.prompt_flavor])
    end

    -- sub-flavor injection
    if LLM_NAME.prompt_sub_flavors[PARAM.prompt_flavor] then
      local tab = LLM_NAME.prompt_sub_flavors[PARAM.prompt_flavor]
      assert(tab)

      prompt = string.gsub(prompt, tab.source[1],
        rand.pick(tab.replacers))
    end

    -- LLM temperature variation, later maps have crazier names
    local pick_tmp
    if epi_lev.game_along then
      pick_tmp = map_value(epi_lev.game_along, 0, 1, 1, 2.5)
    end

    -- name length
    prompt = string.gsub(prompt, "_NAME_LENGTH_",
    rand.pick(LLM_NAME.name_theme.char_limits))

    -- name stylization
    if rand.odds(50) then
      prompt = prompt .. LLM_NAME.stylize_name_prompt()
    end

    -- refer to name history to avoid name re-use
    prompt = prompt .. "The following names are already used. Avoid re-using them and already-used words, but feel free to use them as basis for something more distinct:\n"
    if #LLM_NAME.history > 0 then
      for _, name in ipairs(LLM_NAME.history) do
        prompt = prompt .. "* " .. name .. "\n"
      end
    end

    local lname = ask(prompt,
    {
      temperature = pick_tmp or 1.0
    },
    "name")

    if not lname then
      gui.printf("Failed to acquire name. Preserving original.\n")
      return "not_ok"
    end

    gui.printf("Replaced name of " .. epi_lev.id .. ": " .. lname .. "\n")

    return lname
  end


  -- level metadata collector
  local function collect_level_data(level_tab)

    local info

    local cur_level = table.copy(level_tab)

    local ascii_map = cur_level.ascii_map

    -- get other info
    info = LLM_NAME.level_infos[cur_level.id]

    --[[info = info ..
    "The following is a top-down visual map of the level but as ASCII text.\n\n"..
    ascii_map .. "\n\n"..
    "Each character represents a grid space.\n"..
    "Small letters - an indoor room.\n"..
    "Big letters - an outdoor room.\n"..
    "Letters are sequential and the same letters represent the same room only.\n"..
    "/ and \\ - diagonal walls.\n"..
    "^ > v < - directional stairs in the same room.\n"..
    "~ - liquids, if present.\n" ..
    "# - point of interest along a wall.\n" ..
    "Try to infer a description of the layout based on the ASCII map too.\n"]]

    return info

  end


  -- main story generator prompt assembler
  local function generate_story()

    local prompt =
[[Write a uniquely engaging story for Doom's intermission screens.

The story takes place over the course of the whole game.
Each section of the story is read far apart from each other.

Story Plot: _FLAVOR_

Current Location: _LOCATION_, somewhere in the twisted infinite hellscapes of future Earth

I need the story to be properly formatted. Do not provide any explanation.

Rules:
- narrate in second person
- visceral Doom-style military-industrial horror action
- engaging story with a non-mythic, military-style, viscerally action-packed plot
- pure fictional non real-world location
- absolutely avoid any use of italics, bold, or any Markdown formatting
- no explanations, no commentary, no follow-up questions
- Hell is always the ultimate enemy and its demons are the immediate mission threat but be a person, faction, archive, ritual, weapon shipment, infestation, command post, collaborator, or cover-up may interfere
- the selected Story Plot controls the actual objective and resolution
- if the acronym UAC is used, it means "Union Aerospace Corporation"
- do not use story writing structures such as negations e.g. "not X, just Y", "not afraid, just careful", and so on
- no Warhammer 40k
- keep plot legible with continuity across chapters
- do not mention Earth, it is only for locational context

The silent marine protagonist is the Doomslayer and needs no introduction, forever fighting an eternal war with hell and answers to no one. 
Hell continues to be humanity's problem and the Doomslayer's exploits bring him to the current location. Every step denies Hell something concrete: bodies, weapons, territory, command, records, rituals, collaborators, supplies, or time.
The Doomslayer always emerges victorious in this current story but there will always be a new story, another battle with Hell elsewhere.
Please avoid cliffhangers or "to be continued" endings.

Plot Discipline:
- treat Story Plot as mandatory, not inspirational
- the Objective in Story Plot must be the objective that gets resolved
- the Twist in Story Plot must complicate that objective, not replace it
- do not invent a plot not covered by the Story Plot, Objective, and Twist
- the ending must resolve the stated objective directly

Protagonist Notes:
- the protagonist will never choose to work with Hell
- the protagonist prefers to never harm humans, only demons or possessed humans
- the protagonist will only work with anyone if it coincides with the Doomslayer's goal of Hell's destruction
- do not explain anything about the protagonist's identity or motivations in the story

_ENTITIES_

_FORMAT_
]]
    -- flavor injection
    local story_flavor = rand.pick(LLM_NAME.story_components.flavors)
    local story_obj = rand.pick(LLM_NAME.story_components.objectives)
    local story_instruction = story_flavor .. "\nThe Objective: " .. story_obj .. "\n"

    -- sometimes add a twist
    local story_twist
    if rand.odds(75) then
      story_twist = rand.pick(LLM_NAME.story_components.story_twists)
      story_instruction = story_instruction .. "The Twist: " .. story_twist .. "\n"
    end
    prompt = string.gsub(prompt,
    "_FLAVOR_",
    story_instruction)

    -- place injection
    -- create theme probs
    local place_themes_list = {}
    for theme_name,locs in pairs(LLM_NAME.story_components.places) do
      place_themes_list[theme_name] = #locs
    end

    -- pick locations
    local place_theme_pick = rand.key_by_probs(place_themes_list)
    local story_place = rand.pick(LLM_NAME.story_components.places[place_theme_pick])
    prompt = string.gsub(prompt,
    "_LOCATION_",
    story_place)

    local story_characters
    local character_mode = rand.key_by_probs(
      {
        none=3,
        --[[generic=2,]]
        pregen=4
      })
    --[[if character_mode == "generic" then
      story_characters = rand.key_by_probs({
        ["Introduce an original friendly character in the story.\n"]=3,
        ["Introduce an original neutral character in the story.\n"]=4,
        ["Introduce an original hostile character in the story.\n"]=5,
        ["Introduce two original characters in the story.\n"]=7,
        ["Introduce three original characters in the story.\n"]=1,
      })

      if rand.odds(80) then
        story_characters = story_characters .. LLM_NAME.stylize_name_prompt()
      end
    else]]
    local char_count = rand.pick({1,2,3})
    if character_mode == "pregen" then
      story_characters = "The following appear in the story:\n"
      for i = 1, char_count do
        story_characters = story_characters .. rand.pick(LLM_NAME.story_components.actors).. "\n"
      end

      -- sometimes add a McGuffin
      if (char_count == 2 and rand.odds(30))
      or (char_count == 1 and rand.odds(60)) then
        story_characters = story_characters ..  "Found a bit later in this story:\n"
        story_characters = story_characters .. "* " .. rand.pick(LLM_NAME.story_components.mcguffins) .."\n"
      end

      -- maybe change up our pregen names too!
      --[[if rand.odds(33) then
        story_characters = story_characters .. LLM_NAME.stylize_name_prompt()
      end]]
    else
      story_characters = "There are no other characters in the story - the Doomslayer explores this quest on their own. Please do not name any new entities unless specified.\n"
      --[[story_characters = story_characters .. LLM_NAME.stylize_name_prompt()]]

      -- sometimes add a McGuffin
      if rand.odds(50) then
        story_characters = story_characters ..
          rand.pick({
            "Found later in the story:\n",
            "Found interacting Slayer later in the story:\n"
          })
        story_characters = story_characters .. "* " .. rand.pick(LLM_NAME.story_components.mcguffins) .."\n"
      end
    end

    -- higher chance to involve a McGuffin if there are no characters in the story
    if character_mode == "none" then
      if rand.odds(66) then
        story_characters = story_characters ..
          rand.pick({
            "Found later in the story:\n",
            "Wielded by the Slayer's opponents in the story:\n"
          })
        story_characters = story_characters .. "* " .. rand.pick(LLM_NAME.story_components.mcguffins) .."\n"
        -- a small chance to add a second McGuffin
        if rand.odds(33) then
          story_characters = story_characters .. "* " .. rand.pick(LLM_NAME.story_components.mcguffins) .."\n"
        end
      end
    end
    prompt = string.gsub(prompt,
    "_ENTITIES_",
    story_characters)

    local story_format
    if OB_CONFIG.length == "game" then
      story_format = LLM_NAME.story_components.length.game
    else
      story_format = LLM_NAME.story_components.length.epi
    end

    -- word count substitution
    story_format = string.gsub(story_format,
    "_WORD_COUNT_",
    math.round(PARAM.float_story_word_count) or 130)

    -- final format rule lines merge
    prompt = string.gsub(prompt,
    "_FORMAT_",
    story_format)

    gui.debugf("LLM Namer: Story teller prompt\n" .. prompt .. "\n")

    -- temperature
    local temp = rand.pick
    {
      0.9,
      1.0,
      1.1
    }

    -- prompt structure
    local story_chunks = ask(prompt,
    {
      temperature = temp
    },
    "story")

    assert(story_chunks, "LLM Namer: No story retrieved. Is Ollama on? "..
    "Is the climate fixed? Have wages caught up with inflation? Has the authoritarian-populism fad faded? Are we doomed?\n")

    -- parse out common names from the LLM to something more unique
    local noun_replacers = {}
    for _,N in ipairs(LLM_NAME.story_components.replacers) do
      noun_replacers[N] = namelib.generate_unique_noun("exotic")
      story_chunks = string.gsub(story_chunks, N, noun_replacers[N])
    end

    local story_tab = {}
    gui.printf("\n" .. story_chunks .. " <- RAW\n\n")
    story_tab = parse_story_chunks(story_chunks)

    for s_pos = 1, #story_tab do

      -- insert story sequences
      local chunk_name
      if s_pos%2 == 1 then
        chunk_name = "STORYSTART"
      else
        chunk_name = "STORYEND"
      end


      table.insert(PARAM.language_lump, chunk_name .. math.ceil(s_pos/2) .. " =\n")
      -- debug
      if PARAM.bool_llm_namer_debug == 1 then
        if s_pos == 1 then
          table.insert(PARAM.language_lump,
            '"[' .. story_flavor .. ']\\n"'
          )
          table.insert(PARAM.language_lump,
            '"' .. story_obj .. " / " .. (story_twist or "No Twist") .. '\\n\\n"'
          )
        end
      end
      table.insert(PARAM.language_lump,
        format_story_string(
          escape_string(
            story_tab[s_pos]
          ),
          64
        ) .. ';\n'
      )
      table.insert(PARAM.language_lump, "\n")
    end

  end

  -- level name generator loop
  if PARAM.bool_llm_namer == 1 then

    -- level name generator
    for _,epi in pairs(GAME.episodes) do
      for _,L in pairs(epi.levels) do
        gui.at_level("GenAI Level Names", L.id, #GAME.levels)

        if PARAM.bool_skip_boss_maps == 1 and L.is_procedural_gotcha then
          -- do muffins
        else
          local level_data = collect_level_data(L)
          local name = generate_level_name(level_data, L)

          -- parse out common names from the LLM to something more unique
          if name ~= "not_ok" then
            local noun_replacers = {}
            for _,N in ipairs(LLM_NAME.story_components.replacers) do
              noun_replacers[N] = namelib.generate_unique_noun("exotic")
              name = string.gsub(name, N, noun_replacers[N])
            end

            -- direct replacers
            if rand.odds(90) then
              for replacee,choices in pairs(LLM_NAME.naming_novelty.replacers) do
                if string.gmatch(name, replacee) then
                  name = string.gsub(name, replacee, rand.pick(choices))
                end
              end
            end

            if name then
              gui.debugf("LLM Namer: " .. L.name .. " name '" ..
              L.description .. "' substituted with '" .. name .. "'!\n")

              L.description = name

              table.insert(LLM_NAME.history , name)
            end
          end

        end
      end
    end

  end

  -- intermission story generator
  if PARAM.bool_generate_stories == 1 then
    gui.at_level("GenAI Intermission", #GAME.levels, #GAME.levels)
    generate_story()
  end

end

----------------------------------------------------------------

OB_MODULES["llm_namer"] =
{
  name = "llm_namer",

  label = _("LLM Name Generator"),

  where = "experimental",
  priority = 5,

  tooltip = _("Generates level names using an LLM."),

  hooks =
  {
    setup = LLM_NAME.setup,
    end_level = LLM_NAME.get_some_info,
    pre_all_done = LLM_NAME.do_it
  },

  options =
  {
    {
      name = "bool_llm_namer",
      label=_("LLM Level Name Generator"),
      valuator = "button",
      default = 1,
      tooltip = _("Generates a context-aware level name via LLM."),
      longtip = _("Uses Ollama to generate a name for a level by sending level metadata to Ollama. " ..
        "Default model is llama3.1:8b for name generation and gemma4:latest for story generation. " ..
        "Using a different model or LLM platform requires modification of the script. (see the first lines of code in modules/llm_namer.lua)" ..
        "To use this, just download Ollama and llama3.1:8b and gemma4:latest and keep it running all at default settings.\n\n" ..
        "This module uses Lua io.popen to access cURL, and may cause CMD to briefly appear. This is normal behavior.\n\n" ..
        "The module DOES NOT SEND DATA outside of your PC. " ..
        "This module will not work if you do not have libcurl as it communicates in RESTful API style.\n\n"),
      priority = 102,
    },

    {
      name = "level_name_model",
      label = _("Level Name Model"),
      choices = LLM_NAME.MODEL_CHOICES,
      default = "llama3.1:8b",
      tooltip = _("Which LLM model to generate level names. Dense models are recommended."),
      priority = 101,
    },

    {
      name = "story_gen_model",
      label = _("Story Generator Model"),
      choices = LLM_NAME.MODEL_CHOICES,
      default = "gemma4:latest",
      tooltip = _("Which LLM model to generate the intermission story. Mixture-of-Experts models are recommended."),
      priority = 100,
    },

    {
      name = "bool_skip_boss_maps",
      label = _("Skip Gotchas and Boss Maps"),
      valuator = "button",
      default = 1,
      tooltip = _("Skips renaming Procedural Gotchas or Boss Maps when enabled."),
      priority = 99
    },

    {
      name = "prompt_flavor",
      label = _("Prompt Flavor"),
      choices = LLM_NAME.PROMPT_FLAVOR_CHOICES,
      default = "default",
      tooltip = _("Adds additional flavoring to the LLM-generated names by biasing prompt towards specific descriptions."),
      priority = 98,
      gap = 1
    },

    {
      name = "bool_generate_stories",
      label = _("LLM Intermission Stories"),
      valuator = "button",
      default = 1,
      tooltip = _("Generate intermission stories as well. " ..
      "ZDoom Specials must be turned on or intermission will be ignored without MAPINFO structs.\n\n"..
      "Not guaranteed to make authentic stories and will totally hallu"),
      priority = 97,
    },

    {
      name = "float_story_word_count",
      label = _("Story Word Count"),
      valuator = "slider",
      units = " Words",
      default = 130,
      min = 50,
      max = 130,
      increment = 5,
      tooltip = _("Change the rough number of words per intermission screen."),
      priority = 96,

      gap = 1
    },

    {
      name = "bool_listener_check",
      label = _("Startup Listener Check"),
      valuator = "button",
      default = 1,
      tooltip = _("Enables or disables Ollama instance check before level generation begins for speed. " ..
      "When turning this off, be absolutely sure Ollama is running or you may get end errors, wasting your generated level."),
      priority = 95,
    },

    {
      name = "bool_llm_namer_debug",
      label = _("Debug Mode"),
      valuator = "button",
      default = 0,
      tooltip = _("Adds some prompt information to generated text for debugging."),
      priority = 94,
    }
  }
}
