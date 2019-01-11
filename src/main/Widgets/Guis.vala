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
 
 using notifier.Rems, notifier.Vars;
 namespace notifier.Widgets {
     public void mainWindow () {
         //Welcome to Notifier
         welcome = new Granite.Widgets.Welcome ("Notifier", "\t\t\t\t\t\t\t\t\t\t\t\t");
         welcome.append ("list-add",_("Add a reminder"),"");
         Gtk.CheckButton[] checkbtn = {};
 
 
 
         bar = new Gtk.HeaderBar ();
         window.set_position(Gtk.WindowPosition.CENTER);
         
         //create the layout grid
         layout = new Gtk.Grid ();
         layout.set_halign (Gtk.Align.START);
         //making initial columns. helps to keep UI nicer when loading the reminders from database
         layout.insert_column (0);
         layout.insert_column (1);
         layout.insert_column (2);
         layout.insert_column (3);
         layout.insert_column (4);
         layout.insert_column (5);
         layout.insert_column (6);
         layout.insert_column (7);
         layout.insert_column (8);
         layout.insert_column (9);
         layout.insert_column (10);
 
         //sets up main UI
         
         
                 bar.pack_end (newrembtn);
                 bar.pack_end (spclbl);
                 bar.pack_end (editrembtn);
                 bar.set_title (_("Notifier"));
                 bar.show_close_button = true;
                 window.set_titlebar (bar);
                 
                         layout.row_spacing = 10;
                 
                 
                         layout.attach (new Gtk.Label (_("\tName\t")), 1,0,1,1);
                         layout.attach (new Gtk.Label ("\t"),2,0,1,1);
                         layout.attach (new Gtk.Label (_("\tDescription\t")),3,0,1,1);
                         layout.attach (new Gtk.Label (_("\tPriority\t")),4,0,1,1);
                         layout.attach (new Gtk.Label (_("\tTime\t")),6,0,4,1);
                         layout.attach (new Gtk.Label (_("\tFrequency\t")),10,0,1,1);
                         
                         //set some app settings
                         window.deletable = true;
                         window.resizable = false;
                         window.set_size_request(150,330);
                 
                 
                         
                 
                         //button for new reminder and edit reminder in headerbar
                         newrembtn = new Gtk.Button ();
                         newrembtn.set_image (new Gtk.Image.from_icon_name ("list-add",Gtk.IconSize.LARGE_TOOLBAR));
                         newrembtn.tooltip_text = (_("Add a new reminder"));
                          //You pressed a thing on the Welcome Screen, so this should open up the New Reminder Window
                          welcome.activated.connect ( (i) => {
                                          newrembtn.activate ();
                                  });
                  
                  
                  
                          spclbl = new Gtk.Label ("\t");
                  
                          var editrembtn = new Gtk.Button ();
                          editrembtn.set_image (new Gtk.Image.from_icon_name ("edit",Gtk.IconSize.LARGE_TOOLBAR));
                          editrembtn.tooltip_text = (_("Edit an existing reminder"));
                          
                          int lngth = checkbtn.length - 1;
                          int rows = 1;
                 
     }
     
     
     
     
     public void reminderWindow () {
         spc++;

         // Preparing values for the ComboBox
         priorities = new Gtk.ListStore (2, typeof (string), typeof (string));


         priorities.append (out iter);
         priorities.set (iter, 0, _("Normal"), 1, _("\tA standard notification type."));
         priorities.append (out iter);
         priorities.set (iter, 0, _("Low"), 1, _("\tNothing super important."));
         priorities.append (out iter);
         priorities.set (iter, 0, _("High"), 1, _("\tSomething important is happening!"));
         priorities.append (out iter);
         priorities.set (iter, 0, _("Urgent"), 1, _("\tLook at me. Right now."));


         freqs = new Gtk.ListStore (1, typeof (string));


         freqs.append (out iter);
         freqs.set (iter, 0,_("None"));
         freqs.append (out iter);
         freqs.set (iter, 0, _("Daily"));
         freqs.append (out iter);
         freqs.set (iter, 0, _("Weekly"));
         freqs.append (out iter);
         freqs.set (iter, 0, _("Monthly"));
         freqs.append (out iter);
         freqs.set (iter, 0, "Yearly");



         //setup new reminder prompt UI
         remWindow = new Gtk.Window ();
         remWindow.set_size_request (400,500);
         remHeader = new Gtk.HeaderBar ();
         remHeader.set_title (_(""));
         remHeader.show_close_button = true;
         remWindow.set_titlebar (remHeader);

         reminderName = new Gtk.Entry ();
         //var rn = new GLib.DateTime.now_local ();
         reminderDesc = new Gtk.Entry ();
         //    var newremdate = new  ();


         reminderDate = new Granite.Widgets.DatePicker ();
         reminderTime = new Granite.Widgets.TimePicker ();


         reminderPrior = new Gtk.ComboBox.with_model (priorities);


         reminderFreq = new Gtk.ComboBox.with_model (freqs);



         //Show text in box.
         renderer = new Gtk.CellRendererText ();
         reminderPrior.pack_start (renderer, true);
         reminderPrior.add_attribute (renderer, "text", 0);
         reminderPrior.active = 0;

         renderer = new Gtk.CellRendererText ();
         reminderPrior.pack_start (renderer, true);
         reminderPrior.add_attribute (renderer, "text", 1);
         reminderPrior.active = 0;



         reminderPrior.set_id_column (0);

         renderer = new Gtk.CellRendererText ();
         reminderFreq.pack_start (renderer, true);
         reminderFreq.add_attribute (renderer, "text", 0);
         reminderFreq.active = 0;

         reminderFreq.set_id_column (0);










         reminderSave = new Gtk.Button ();
         reminderGrid = new Gtk.Grid ();
         reminderSave.set_image (new Gtk.Image.from_icon_name ("document-save",Gtk.IconSize.LARGE_TOOLBAR));
         reminderSave.tooltip_text = _("Save reminder");
         remHeader.pack_end (reminderSave);
         reminderGrid.set_halign (Gtk.Align.CENTER);
         reminderGrid.attach (new Gtk.Label (_("Reminder Name")),0,0,1,1);
         reminderGrid.attach (new Gtk.Label (_("Remind Time")),2,0,4,1);
         reminderGrid.attach (new Gtk.Label (_("Reminder description")),1,0,1,1);
         reminderGrid.attach (new Gtk.Label (_("Day")),2,1,1,1);
         reminderGrid.attach (new Gtk.Label (_("Time")),5,1,1,1);
         reminderGrid.insert_column(7);
         reminderGrid.attach (new Gtk.Label (_("Priority")),7,0,1,1);
         reminderGrid.attach (new Gtk.Label (_("Frequency")),9,0,1,1);
         reminderGrid.attach (reminderName,0,2,1,1);
         reminderGrid.attach (reminderDesc,1,2,1,1);
         reminderGrid.attach (reminderDate,2,2,1,1);
         reminderGrid.attach (reminderTime,5,2,2,1);
         reminderGrid.attach (reminderPrior,7,2,2,1);
         reminderGrid.attach (reminderFreq,9,2,1,1);

         //newremgrid.attach (newremdate,5,4,1,1);









         //attach the necessary buttons to the window, and show
         remWindow.add (reminderGrid);
         reminderGrid.attach (new Gtk.Label (" "),0,4,1,1);
         remWindow.show_all ();
     }
 }
