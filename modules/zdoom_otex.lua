------------------------------------------------------------------------
--  MODULE: OTEX Theme Generator
------------------------------------------------------------------------
--
--  Copyright (C) 2024-2024 MsrSgtShooterPerson
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
--  This program is distributed in the hope that it will be useful,
--  but WITHOUT ANY WARRANTY; without even the implied warranty of
--  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--  GNU General Public License for more details.
--
-------------------------------------------------------------------
gui.import("zdoom_otex_db.lua")


OTEX_PROC_MODULE = { }

OTEX_MATERIALS = { }
OTEX_ROOM_THEMES = { }

OTEX_EXCLUSIONS = 
{
  -- animated textures
  WRNG = "textures",
  CHAN = "all",
  COMP = "all",

  -- textures with transparency
  EXIT = "all",
  FENC = "all",
  SWTC = "all",
  WARP = "all",
  VINE = "all",
  SOLI = "all",
  DOOR = "all",
  GATE = "all",
  FLAG = "all",
  RAIL = "all",
  LASR = "all",

  -- VFX
  FIRE = "all",

  -- liquids
  FALL = "all",
  BLOD = "all",
  GOOP = "all",
  LAVA = "all",
  ICYW = "all",
  NUKE = "all",
  SLUD = "all",
  TAR_ = "all",
  WATE = "all",

  -- skies
  SKY0 = "all",
  SKY1 = "all",
  SKY2 = "all",
  SKY3 = "all",
  SKY4 = "all",
  SKY5 = "all",
  SKY6 = "all",

  -- teleporter flats
  TLPT = "all",

  LGHT = "all",

  -- outdoors
  GRSS = "all",
  ICE_ = "all",

  -- just plain weird
  CRPT = "textures"
}

-- some textures that must be removed manually from the DB
OTEX_DIRECT_REMOVALS =
{
  MRBL =
  {
    textures =
    {
      "OMRBLA90",
      "OMRBLA91",
      "OMBRLA92",
      "OMBRLA93",
      "OMBRLA94",
  
      "OMBRLC90",
  
      "OMBRLF29",
      "OMBRLF38",
      "OMBRLF90",
  
      "OMBRLG90",
  
      "OMRBLI92",
      "OMRBLI93",
  
      "OMRBLJ90",
      "OMRBLJ93",
  
      "OMRBLK90",
  
      "OMRBLO28",
      "OMRBLO29",
  
      "OMBRLP90",
      "OMBRLP91",
  
      "OMBRLR90",
      "OMBRLR94"  
    }
  },

  BRCK =
  {
    textures =
    {
      "OBRCKB10",
      "OBRCKB11",
      "OBRCKB12",
      "OBRCKB13",
      "OBRCKB20",
      "OBRCKB21",
      "OBRCKB22",
      "OBRCKB23",

      "OBRCKF11",
      "OBRCKF12",
      "OBRCKF13",
      "OBRCKF14",
      "OBRCKF21",
      "OBRCKF22",
      "OBRCKF23",
      "OBRCKF24",

      "OBRCKL10",
      "OBRCKL11",
      "OBRCKL21",

      "OBRCKU03",
      "OBRCKU04",
      "OBRCKU05",
      "OBRCKU06",

      "OBRCKU13",
      "OBRCKU14",
      "OBRCKU15",
      "OBRCKU16",

      "OBRCKU23",
      "OBRCKU24",
      "OBRCKU25",
      "OBRCKU26",

      "OBRCKU3D",
      "OBRCKU3E",
      "OBRCKU3F",
      "OBRCKU3G",
      "OBRCKU3H",
      "OBRCKU3I",

      "OTUDRB80",
      "OTUDRB81"
    }
  },

  BKMT =
  {
    textures =
    {
      "OBKMTD90",
      "OBKMTD91",
      "OBKMTD92",
      "OBKMTD95",
      "OBKMTD96",
      "OBKMTD97"
    }
  },

  BOOK =
  {
    textures =
    {
      "OBOOKA01",
      "OBOOKA02",
      "OBOOKA05",
      "OBOOKA10",
      "OBOOKA11",
      "OBOOKA12"
    }
  },

  VENT =
  {
    textures =
    {
      "OVENTE03",
      "OVENTE04",
      "OVENTE13",
      "OVENTE14"
    }
  }
}

OTEX_THEME_RESTRICTIONS =
{
  MRBL = {"hell"},
  BONE = {"hell"},
  FLSH = {"hell"},
  HELL = {"hell"},

  BRCK = {"hell", "urban"},
  BOOK = {"hell", "urban"},
  
  SOIL = {"hell", "urban"},
  ROCK = {"hell"},
  SAND = {"hell"},
  DIRT = {"hell"}
}

OTEX_SPECIAL_RESOURCES =
{
  RAIL = {k="fence", t={"tech", "urban"}},
  FENC = {k="fence"}
}

function OTEX_PROC_MODULE.setup(self)
  PARAM.OTEX_module_activated = true
  module_param_up(self)
  OTEX_PROC_MODULE.synthesize_procedural_themes()
end


function OTEX_PROC_MODULE.synthesize_procedural_themes()
  local resource_tab = {}

  local function pick_unique_texture(table, tex_group, total_tries)
    local tex
    local tries = 0

    tex = rand.pick(tex_group)
    while not table[tex] and tries < (total_tries or 5) do
      tex = rand.pick(tex_group)
      tries = tries + 1
    end

    return tex
  end

  resource_tab = table.copy(OTEX_RESOURCE_DB)
  table.name_up(resource_tab)

  -- create material mappings
  for _,resource_group in pairs(resource_tab) do
    if resource_group.has_all then
      for _,T in pairs(resource_group.textures) do
        OTEX_MATERIALS[T]=
        {
          t=T,
          f=rand.pick(resource_group.flats)
        }
      end
      for _,F in pairs(resource_group.flats) do
        OTEX_MATERIALS[F]=
        {
          f=F,
          t=rand.pick(resource_group.textures)
        }
      end
    end

    if resource_group.has_textures and
    not resource_group.has_flats then
      for _,T in pairs(resource_group.textures) do
        OTEX_MATERIALS[T]=
        {
          t=T,
          f="CEIL5_2"
        }
      end
    end

    if resource_group.has_flats and
    not resource_group.has_textures then
      for _,F in pairs(resource_group.flats) do
        OTEX_MATERIALS[F] =
        {
          f=F,
          t="BROWNHUG"
        }
      end
    end
  end

  -- direct removals
  for theme_group,_ in pairs(OTEX_DIRECT_REMOVALS) do
    for img_group,_ in pairs(OTEX_DIRECT_REMOVALS[theme_group]) do
      for _,tex in pairs(OTEX_DIRECT_REMOVALS[theme_group][img_group]) do
        table.kill_elem(resource_tab[theme_group][img_group], tex)
      end
    end
  end

  -- create pick list
  local validity_list = {}
  local group_pick_list = {
    tech = {textures = {}, flats = {}},
    urban = {textures = {}, flats = {}},
    hell = {textures = {}, flats = {}},
    any = {textures = {}, flats = {}}
  }
  local av_themes = {"hell","urban","tech","any"}


  for group,_ in pairs(resource_tab) do
    for _,theme in pairs(av_themes) do

      -- do textures
      if OTEX_EXCLUSIONS[group] and OTEX_EXCLUSIONS[group] == "all" then
        -- do nothing
      else
        if not (OTEX_THEME_RESTRICTIONS[group] 
        and table.has_elem(OTEX_THEME_RESTRICTIONS[group], theme)) then
          if resource_tab[group].has_textures == true 
          and not OTEX_EXCLUSIONS[group] then
            group_pick_list[theme].textures[group] = 10
          end
          if resource_tab[group].has_flats == true
          and not OTEX_EXCLUSIONS[group] then
            group_pick_list[theme].flats[group] = 10
          end
        end
      end
  
    end
  end

  local generic_floors_list = {}
  for G,_ in pairs(resource_tab) do
    if string.find(G, "DMD") then
      for _,T in pairs(resource_tab[G].flats) do
        generic_floors_list[T] = 10
      end
    end
  end
  
  -- resource_tab exclusions
  for k,v in pairs(OTEX_EXCLUSIONS) do
    if v == "textures" then
      resource_tab[k].textures = {}
      resource_tab[k].has_textures = false
      resource_tab[k].has_all = false
    elseif v == "flats" then
      resource_tab[k].flats = {}
      resource_tab[k].has_flats = false
      resource_tab[k].has_all = false
    else
      resource_tab[k] = {}
      resource_tab[k] = nil
    end
  end

  -- try to create a consistent theme
  local themes =
  {
    "tech","hell","urban","any"
  }
  for i = 1, PARAM.float_otex_num_themes * 0.75 do
    for _,T in pairs(themes) do
      local grouping, room_theme = {}
      local tab_pick, tex_pick, RT_name

      RT_name = T .. "_OTEX_cons_" .. i .. "_"
      room_theme =
      {
        env = "building",
        prob = rand.pick({40,50,60}) * PARAM.float_otex_rt_prob_mult,
        name = RT_name
      }
      room_theme.walls = {}
      room_theme.floors = {}
      room_theme.ceilings = {}

      tab_pick = rand.key_by_probs(group_pick_list[T].textures)
      tex_pick = rand.pick(resource_tab[tab_pick].textures)
      room_theme.walls[tex_pick] = 5
      RT_name = RT_name .. tex_pick .. "_"

      if rand.odds(25) or resource_tab[tab_pick].has_flats == false then
        tab_pick = rand.key_by_probs(group_pick_list["any"].flats)
      end
      tex_pick = rand.pick(resource_tab[tab_pick].flats)
      room_theme.floors[tex_pick] = 5
      RT_name = RT_name .. tex_pick .. "_"

      if rand.odds(25) or resource_tab[tab_pick].has_flats == false then
        tab_pick = rand.key_by_probs(group_pick_list["any"].flats)
      end
      tex_pick = rand.pick(resource_tab[tab_pick].flats)
      room_theme.ceilings[tex_pick] = 5
      RT_name = RT_name .. tex_pick

      room_theme.name = RT_name
      OTEX_ROOM_THEMES[RT_name] = room_theme
    end
  end

  -- try a completely random theme
  for i = 1, PARAM.float_otex_num_themes * 0.25 do
    local RT_name = "any_OTEX_random_" .. i .. "_"
    local room_theme, tab_pick = {}
    local tex_pick

    room_theme =
    {
      env = "building",
      prob = rand.pick({40,50,60}),
    }
    room_theme.walls = {}
    room_theme.floors = {}
    room_theme.ceilings = {}

    tab_pick = rand.key_by_probs(group_pick_list["any"].textures)
    tex_pick = rand.pick(resource_tab[tab_pick].textures)
    room_theme.walls[tex_pick] = 5
    RT_name = RT_name .. tex_pick .. "_"

    tab_pick = rand.key_by_probs(group_pick_list["any"].flats)
    tex_pick = rand.pick(resource_tab[tab_pick].flats)
    room_theme.floors[tex_pick] = 5
    RT_name = RT_name .. tex_pick .. "_"

    tab_pick = rand.key_by_probs(group_pick_list["any"].flats)
    tex_pick = rand.pick(resource_tab[tab_pick].flats)
    room_theme.ceilings[tex_pick] = 5
    RT_name = RT_name .. tex_pick

    room_theme.name = RT_name
    OTEX_ROOM_THEMES[RT_name] = room_theme
  end

  -- insert into outdoor facades
  for theme,table_group in pairs(GAME.THEMES) do
    local tab_pick, tex_pick, pick_num = 0

    if GAME.THEMES[theme].facades then
      for i = 1, 50 do
        local pick_num = 0

        tab_pick = rand.key_by_probs(group_pick_list[theme].textures)
        while not GAME.THEMES[theme].facades[tex_pick] and pick_num < 5 do
          tex_pick = rand.pick(resource_tab[tab_pick].textures)
          GAME.THEMES[theme].facades[tex_pick] = rand.pick({15,20,25,30})
          pick_num = pick_num + 1
        end
      end
    end

  end

end


function OTEX_PROC_MODULE.get_levels_after_themes()
  table.deep_merge(GAME.MATERIALS, OTEX_MATERIALS, 2)
  table.deep_merge(GAME.ROOM_THEMES, OTEX_ROOM_THEMES, 2)
end

----------------------------------------------------------------

OB_MODULES["otex_proc_module"] =
{

  name = "otex_proc_module",

  label = _("OTEX Resource Pack [PRE-ALPHA]"),

  where = "other",
  priority = 75,

  port = "zdoom",

  game = "doomish",

  hooks =
  {
    setup = OTEX_PROC_MODULE.setup,
    get_levels_after_themes = OTEX_PROC_MODULE.get_levels_after_themes
  },

  tooltip = _("If enabled, generates room themes using OTEX based on a resource table. ".. 
  "OTEX must be manually loaded in the sourceport. " ..
  "Includes textures and flats only, no patches.\n\n" ..
  "Currently does not make any kind of sensibly curated room themes."),

  options =
  {
    {
      name="float_otex_num_themes",
      label=_("Room Themes Count"),
      valuator = "slider",
      min = 2,
      max = 40,
      increment = 2,
      default = 8,
      tooltip = _("How many OTEX room themes to synthesize."),
      longtip = _("Not all room themes may show up in levels as appearance " ..
      "is reliant on use probability. Use multipler below to increase " ..
      "or decrease further"),
      priority = 2
    },
    {
      name="float_otex_rt_prob_mult",
      label=_("Probability Multiplier"),
      valuator="slider",
      units="x",
      min = 0,
      max = 20,
      increment = 0.1,
      default = 1,
      tooltip = _("Multiplier for all synthesized OTEX room themes."),
      priority = 1
    }
  }
}
