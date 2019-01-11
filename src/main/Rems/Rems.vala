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
 
 using notifier.main, notifier.Vars, notifier.Widgets;
 
 namespace notifier.Rems {
 
 
     private class Reminder : GLib.Object {
     public string name {get; set;}
     public int year {get; set;}
     public int month {get; set;}
     public int day {get; set;}
     public int hour {get; set;}
     public int min {get; set;}
     public int prior {get; set;}
     public string description {get; set;}
     public string timing {get; set;}
     
     public Reminder (
     string name, 
     int year, 
     int month, 
     int day, 
     int hour, 
     int min, 
     int prior, 
     string description, 
     string timing
     ) {
         
     }
     
     
     }
     
     public void loadPreviousReminders () {
     Gtk.CheckButton[] checkbtn = {};
         //prepare to load reminders from database...
         countq = "SELECT * FROM Reminders WHERE rowid = ?";
         
 
         Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db);
 
         db.prepare_v2 (countq,-1, out countstmt);
         
         countstmt.bind_int64 (1,bv);
 
 
 
 
 
         //load reminders from database
         
         while (countstmt.step () == Sqlite.ROW) {
         
 
                 spc++;
                 spc2++;
                 message (spc2.to_string ());
 
 
 //The user's reminder
                userrem = new Reminder (
                //name
                    countstmt.column_value (1).to_text (),
                    //year
                    countstmt.column_value (2).to_int (),
                    //month
                    countstmt.column_value (3).to_int (),
                    //day
                    countstmt.column_value (4).to_int (),
                    //hour
                    countstmt.column_value (5).to_int (),
                    //min
                    countstmt.column_value (6).to_int (),
                    //prior
                    countstmt.column_value (7).to_int (),
                    //description
                    countstmt.column_value (8).to_text (),
                    //timing
                    countstmt.column_value (9).to_text ()
                );
 
                 lngth = checkbtn.length - 1;
 

                 //adding a 0 to single digit minutes. human friendly
 
 
                 switch (userrem.min.to_string ()) {
                 case "0": min = "00"; break;
                 case "1": min = "01"; break;
                 case "2": min = "02"; break;
                 case "3": min = "03"; break;
                 case "4": min = "04"; break;
                 case "5": min = "05"; break;
                 case "6": min = "06"; break;
                 case "7": min = "07"; break;
                 case "8": min = "08"; break;
                 case "9": min = "09"; break;
 
                 }
 
                 //If the User's computer is configured in am/pm, Notifier will switch the view to show AM/PM
                 if (ap == true) {
                         var pa = " am";
                         if (int.parse (hour) > 12) {
                                 hour = (int.parse (hour) - 12).to_string ();;
                                 pa = " pm";
 
                         }
                         min = min + pa;
                 }
 
                 time = hour + ":" + min;
 
 
                 
                 monthn = "";
                 //switchin from integer month to string month. more human friendly
                 switch (userrem.month) {
                 case 1: monthn = _("Jan"); break;
                 case 2: monthn = _("Feb"); break;
                 case 3: monthn = _("Mar"); break;
                 case 4: monthn = _("Apr"); break;
                 case 5: monthn = _("May"); break;
                 case 6: monthn = _("Jun"); break;
                 case 7: monthn = _("Jul"); break;
                 case 8: monthn = _("Aug"); break;
                 case 9: monthn = _("Sep"); break;
                 case 10: monthn = _("Oct"); break;
                 case 11: monthn = _("Nov"); break;
                 case 12: monthn = _("Dec"); break;
 
                 }
 
                 
 
                 
                 
                 if (timing == "") {
                         timing=_("None");
                         notime = "UPDATE Reminders SET Timing = 'None' WHERE rowid = ?;";
                         db.prepare_v2 (notime,-1,out notimeupd);
                         notimeupd.bind_int64(1,bv);
                         notimeupd.step ();
                         notimeupd.reset ();
                         notimeupd.clear_bindings ();
                 }
 
 
                 
                 switch (userrem.prior.to_string ()) {
                 case "0": prior = _("Normal"); break;
                 case "1": prior = _("Low"); break;
                 case "2": prior = _("High"); break;
                 case "3": prior = _("Urgent"); break;
 
                 }
 
                 checkbtn += new Gtk.CheckButton ();
                 lngth = checkbtn.length - 1;
                 //adding to the UI
                 layout.attach (checkbtn[b],0,spc,1,1);
                 layout.attach (new Gtk.Label (name),1,spc,1,1);
                 layout.attach (new Gtk.Label (description),3,spc,1,1);
                 layout.attach (new Gtk.Label (prior),4,spc,1,1);
                 layout.attach (new Gtk.Label (_(" ")),5,spc,1,1);
                 layout.attach (new Gtk.Label (_("\t" + year + " " + monthn + " " + day + " ")),6,spc,1,1);
                 layout.attach (new Gtk.Label (time),7,spc,1,1);
                 layout.attach (new Gtk.Label (" "),11,spc,1,1);
                 layout.attach (new Gtk.Label (timing),10,spc,1,1);
                 b++;
 
                 rows = 3;
                 //Onto the next database row, if any
                 countq2 = "SELECT * FROM Reminders WHERE rowid = ?";
                 db.prepare_v2 (countq2,-1, out countstmt);
                 bv++;
                 countstmt.bind_int64 (1,bv);
         }
         //You have no reminders!
         if (spc == 1) {
                 window.add (welcome);
 
         }
         else {
                 window.add (layout);
         }
     }
     
     
     
     
     
     
     
     
     
     
     
    public void updateRems () {
         c = 1;
Gtk.CheckButton[] checkbtn = {};
         
         while ( i <= lngth) {



                 Sqlite.Statement update;

                 updatequery = "UPDATE Reminders SET Complete = 'false' WHERE rowid = ?;";





                 if (checkbtn[i].get_active () == true) {
                         updatequery = "UPDATE Reminders SET Complete = 'true' WHERE rowid = ?;";
                         message ("Reminder number " + c.to_string () + " is to be deleted.");

                 }
                 if (db.prepare_v2 (updatequery,-1,out update) != Sqlite.OK) {
                         layout.attach (new Gtk.Label (db.errmsg ()),3,0,1,3);
                 }



                 if (update.bind_int64 (1,c) != Sqlite.OK) {
                         layout.attach (new Gtk.Label (db.errmsg ()),3,0,1,3);
                 }
                 if (update.step () != Sqlite.OK) {
                         layout.attach (new Gtk.Label (db.errmsg ()),3,0,1,3);
                 }

                 update.clear_bindings ();
                 update.reset ();
                 i++;
                 c++;
         }

         Sqlite.Statement del;

         deletecomplete = "DELETE FROM Reminders WHERE (Complete = 'true');";
         db.prepare_v2 (deletecomplete,-1,out del);
         del.step ();
         message ("All \"Completed\" reminders have been removed.");
         del.reset ();
    }
 }
