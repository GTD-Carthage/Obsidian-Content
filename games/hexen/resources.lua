------------------------------------------------------------------------
--  HEXEN RESOURCES and GFX
------------------------------------------------------------------------
--
--  Copyright (C) 2006-2015 Andrew Apted
--  Copyright (C) 2011-2012 Jared Blackburn
--
--  This program is free software; you can redistribute it and/or
--  modify it under the terms of the GNU General Public License
--  as published by the Free Software Foundation; either version 2
--  of the License, or (at your option) any later version.
--
------------------------------------------------------------------------

HEXEN.color_palette =
{
    2,  2,  2,   4,  4,  4,  15, 15, 15,  19, 19, 19,  27, 27, 27,
   28, 28, 28,  33, 33, 33,  39, 39, 39,  45, 45, 45,  51, 51, 51,
   57, 57, 57,  63, 63, 63,  69, 69, 69,  75, 75, 75,  81, 81, 81,
   86, 86, 86,  92, 92, 92,  98, 98, 98, 104,104,104, 112,112,112,
  121,121,121, 130,130,130, 139,139,139, 147,147,147, 157,157,157,
  166,166,166, 176,176,176, 185,185,185, 194,194,194, 203,203,203,
  212,212,212, 221,221,221, 230,230,230,  29, 32, 29,  38, 40, 37,
   50, 50, 50,  59, 60, 59,  69, 72, 68,  78, 80, 77,  88, 93, 86,
   97,100, 95, 109,112,104, 116,123,112, 125,131,121, 134,141,130,
  144,151,139, 153,161,148, 163,171,157, 172,181,166, 181,189,176,
  189,196,185,  22, 29, 22,  27, 36, 27,  31, 43, 31,  35, 51, 35,
   43, 55, 43,  47, 63, 47,  51, 71, 51,  59, 75, 55,  63, 83, 59,
   67, 91, 67,  75, 95, 71,  79,103, 75,  87,111, 79,  91,115, 83,
   95,123, 87, 103,131, 95,  20, 16, 36,  30, 26, 46,  40, 36, 57,
   50, 46, 67,  59, 57, 78,  69, 67, 88,  79, 77, 99,  89, 87,109,
   99, 97,120, 109,107,130, 118,118,141, 128,128,151, 138,138,162,
  148,148,172,  62, 40, 11,  75, 50, 16,  84, 59, 23,  95, 67, 30,
  103, 75, 38, 110, 83, 47, 123, 95, 55, 137,107, 62, 150,118, 75,
  163,129, 84, 171,137, 92, 180,146,101, 188,154,109, 196,162,117,
  204,170,125, 208,176,133,  27, 15,  8,  38, 20, 11,  49, 27, 14,
   61, 31, 14,  65, 35, 18,  74, 37, 19,  83, 43, 19,  87, 47, 23,
   95, 51, 27, 103, 59, 31, 115, 67, 35, 123, 75, 39, 131, 83, 47,
  143, 91, 51, 151, 99, 59, 160,108, 64, 175,116, 74, 180,126, 81,
  192,135, 91, 204,143, 93, 213,151,103, 216,159,115, 220,167,126,
  223,175,138, 227,183,149,  37, 20,  4,  47, 24,  4,  57, 28,  6,
   68, 33,  4,  76, 36,  3,  84, 40,  0,  97, 47,  2, 114, 54,  0,
  125, 63,  6, 141, 75,  9, 155, 83, 17, 162, 95, 21, 169,103, 26,
  180,113, 32, 188,124, 20, 204,136, 24, 220,148, 28, 236,160, 23,
  244,172, 47, 252,187, 57, 252,194, 70, 251,201, 83, 251,208, 97,
  251,221,123,   2,  4, 41,   2,  5, 49,   6,  8, 57,   2,  5, 65,
    2,  5, 79,   0,  4, 88,   0,  4, 96,   0,  4,104,   4,  6,121,
    2,  5,137,  20, 23,152,  38, 41,167,  56, 59,181,  74, 77,196,
   91, 94,211, 109,112,226, 127,130,240, 145,148,255,  31,  4,  4,
   39,  0,  0,  47,  0,  0,  55,  0,  0,  67,  0,  0,  79,  0,  0,
   91,  0,  0, 103,  0,  0, 115,  0,  0, 127,  0,  0, 139,  0,  0,
  155,  0,  0, 167,  0,  0, 185,  0,  0, 202,  0,  0, 220,  0,  0,
  237,  0,  0, 255,  0,  0, 255, 46, 46, 255, 91, 91, 255,137,137,
  255,171,171,  20, 16,  4,  13, 24,  9,  17, 33, 12,  21, 41, 14,
   24, 50, 17,  28, 57, 20,  32, 65, 24,  35, 73, 28,  39, 80, 31,
   44, 86, 37,  46, 95, 38,  51,104, 43,  60,122, 51,  68,139, 58,
   77,157, 66,  85,174, 73,  94,192, 81, 157, 51,  4, 170, 65,  2,
  185, 86,  4, 213,119,  6, 234,147,  5, 255,178,  6, 255,195, 26,
  255,216, 45,   4,133,  4,   8,175,  8,   2,215,  2,   3,234,  3,
   42,252, 42, 121,255,121,   3,  3,184,  15, 41,220,  28, 80,226,
   41,119,233,  54,158,239,  67,197,246,  80,236,252, 244, 14,  3,
  255, 63,  0, 255, 95,  0, 255,127,  0, 255,159,  0, 255,195, 26,
  255,223,  0,  43, 13, 64,  61, 14, 89,  90, 15,122, 120, 16,156,
  149, 16,189, 178, 17,222, 197, 74,232, 215,129,243, 234,169,253,
   61, 16, 16,  90, 36, 33, 118, 56, 49, 147, 77, 66, 176, 97, 83,
  204,117, 99,  71, 53,  2,  81, 63,  6,  96, 72,  0, 108, 80,  0,
  120, 88,  0, 128, 96,  0, 149,112,  1, 181,136,  3, 212,160,  4,
  255,255,255
}


------------------------------------------------------------------------

function HEXEN.make_cool_gfx()
  local PURPLE =
  {
    0, 231, 232, 233, 234, 235, 236, 237, 238, 239
  }

  local GREEN =
  {
    0, 186, 188, 190, 192, 194, 196, 198, 200, 202
  }

  local BROWN =
  {
    0, 97, 99, 101, 103, 105, 107, 109, 111, 113, 115, 117, 119, 121
  }

  local RED =
  {
    0, 164, 166, 168, 170, 172, 174, 176, 178, 180, 183
  }

  local WHITE =
  {
    0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30
  }

  local BLUE =
  {
    0, 146, 148, 150, 152, 154, 156, 217, 219, 221, 223
  }


  local colmaps =
  {
    PURPLE, GREEN, BROWN, RED, BLUE
  }

  rand.shuffle(colmaps)

  gui.set_colormap(1, colmaps[1])
  gui.set_colormap(2, colmaps[2])
  gui.set_colormap(3, colmaps[3])
  gui.set_colormap(4, WHITE)

  local carve = "RELIEF"
  local c_map = 3

  if rand.odds(33) then
    carve = "CARVE"
    c_map = 4
  end

  -- patches : SEWER08, BRASS3, BRASS4
  gui.wad_logo_gfx("W_121", "p", "BOLT",  64,128, 1)
  gui.wad_logo_gfx("W_320", "p", "PILL", 128,128, 2)
  gui.wad_logo_gfx("W_321", "p", carve,  128,128, c_map)

  -- flats
  gui.wad_logo_gfx("O_BOLT",  "f", "BOLT",  64,64, 1)
  gui.wad_logo_gfx("O_PILL",  "f", "PILL",  64,64, 2)
  gui.wad_logo_gfx("O_CARVE", "f", carve,   64,64, c_map)
end


function HEXEN.all_done()
  HEXEN.make_mapinfo()
  HEXEN.make_cool_gfx()
end

