/*
 * Copyright (c) 2018 Timecraft <timemaster23x@gmail.com>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public
 * License along with this program; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
 * Boston, MA 02110-1301 USA
 */

 using notifier.Rems;

 namespace notifier.Vars {
 // Main window gui variables
    Granite.Widgets.Welcome welcome;
    Gtk.ApplicationWindow window;
    Gtk.HeaderBar bar;
    Gtk.Grid layout;
    Gtk.Button newrembtn;
    Gtk.Button editrembtn;
    Gtk.Label spclbl;




// Time manager vars
    DateTime am24pm;
    Granite.Widgets.TimePicker testampm;
    bool ap;
    int c = 0;
    int colmn = 0;
    int rownum = 0;
    int spc = 1;
    int b = 0;
    int lngth;
    int rows = 1;




// File Management vars
File notifdir;
File notifdata;

// Sqlite vars
Sqlite.Database db;
int data;
int bv = 1;
int spc2 = 1;
Sqlite.Statement query;
Sqlite.Statement countstmt;
Sqlite.Statement timingq;
Sqlite.Statement notimeupd;
string savequery;
string updatequery;
string deletecomplete;
string timingstmt;
string ctstmt;
string cqstmt;
string countq;
string countq2;

int i = 0;

//Reminder vars
Reminder userrem;
string name;
string hour;
string min;
string time;
string year;
string monthn;
string day;
string description;
string prior;
string timing;
string notime;
int month;

//Reminder window vars
Gtk.ListStore priorities;
Gtk.ListStore freqs;
Gtk.TreeIter iter;
Gtk.Window remWindow;
Gtk.HeaderBar remHeader;
Gtk.Entry reminderName;
Gtk.Entry reminderDesc;
Granite.Widgets.DatePicker reminderDate;
Granite.Widgets.TimePicker reminderTime;
Gtk.ComboBox reminderPrior;
Gtk.ComboBox reminderFreq;
Gtk.CellRendererText renderer;
Gtk.Button reminderSave;
Gtk.Grid reminderGrid;

int res;
Sqlite.Statement chngrowid;
 }
