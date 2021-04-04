//
// Input header file for the Fast Light Tool Kit (FLTK).
//
// Copyright 1998-2005 by Bill Spitzak and others.
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Library General Public
// License as published by the Free Software Foundation; either
// version 2 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Library General Public License for more details.
//
// You should have received a copy of the GNU Library General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
// USA.
//
// Please report all bugs and problems on the following page:
//
//     http://www.fltk.org/str.php
//

//----------------------------------------------------------------
//
// Modified 25/Sep/2005 by Andrew Apted, from FLTK 1.1.7
//
// Provides an Fl_Name_Input which prevents characters that
// are illegal for the basename of a file from being entered.
//
//----------------------------------------------------------------

#ifndef Fl_NameInput_H
#define Fl_NameInput_H

#include <FL/Fl_Input_.H>

class FL_EXPORT Fl_NameInput : public Fl_Input_ {
    int handle_key();
    int shift_position(int p);
    int shift_up_down_position(int p);
    void handle_mouse(int keepmark = 0);

   public:
    Fl_NameInput(int, int, int, int, const char * = 0);
    void draw();
    int handle(int);

   private:
    void filter_text();
    bool valid_char(char ch);
};

#endif  // Fl_NameInput_H
