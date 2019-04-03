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


     public class Reminder : GLib.Object {
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

     public void makeReminderDatabase () {
                 //Create database directory
                 notifdir = File.new_for_path (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier");
                 notifdata = File.new_for_path (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/" + "reminders.db");
                 if (!notifdir.query_exists ()) {
                         try {
                                 notifdir.make_directory ();
                         } catch (Error e) {
                                 message (_("Error: " + e.message));
                         }
                 }


                 if (!notifdata.query_exists ()) {
                         try {



                                 //Create Database
                                 data = Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db);
                                 if (data != Sqlite.OK) {
                                         stderr.printf (_("Can't open the reminders database: %d: %s\n"), db.errcode (), db.errmsg ());
                                 }
                                 //create table
                                 string q = "
                                 CREATE TABLE Reminders (
                       Complete		TEXT      ,
                       Name            TEXT            ,
                       Year          INTEGER		,
                       Month           INTEGER		,
                       Day           INTEGER		,
                       Hour			INTEGER         ,
                       Minute		INTEGER         ,
                       Priority		INTEGER     ,
                       Description TEXT        ,
                       Timing TEXT
                                   );
                     ";
                                 //checking for errors


                                 if (data != Sqlite.OK) {
                                         stderr.printf (_("Can't open the reminders database: %d: %s\n"), db.errcode (), db.errmsg ());
                                 }

                                 db.prepare_v2 (q,-1, out query);

                                 if (query.step () != Sqlite.OK) {
                                         stderr.printf (_("Error:  %s\n"), db.errmsg ());
                                 }
                                 stdout.puts (_("Created.\n"));
                         } catch (Error e) {
                                 stdout.printf (_("Error:  %s\n"),e.message);


                         }
                 }

                 else {
                         try {
                                 //so there is one... let's make sure we can open it


                                 data = Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db);
                                 if (data != Sqlite.OK) {
                                         stderr.printf (_("Can't open the reminders database: %d: %s\n"), db.errcode (), db.errmsg ());
                                 }
                                 /*Since this is a new update and users who have the app will have
                                    the database but not the timing column, we're going to check to see if it exists.
                                    If it does not, we'll alter the table to have that column.
                                  */
                                 timingstmt = "SELECT * FROM Reminders WHERE Timing;";

                                 db.prepare_v2 (timingstmt,-1,out timingq);
                                 if (timingq.step () != Sqlite.OK) {
                                         Sqlite.Statement ctq;
                                         ctstmt = "ALTER TABLE Reminders ADD COLUMN Timing";
                                         db.prepare_v2 (ctstmt,-1,out ctq);

                                         if (ctq.step () != Sqlite.OK) {
                                                 message (_("Unable to add TIMING column"));
                                         }
                                 }

                         }finally { /*do what?*/}
                 }

     }









     public void loadPreviousReminders () {

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



                 //adding to the UI
                 layout.attach (new Gtk.CheckButton (),0,spc,1,1);
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


         while ( i <= lngth) {



                 Sqlite.Statement update;

                 updatequery = "UPDATE Reminders SET Complete = 'false' WHERE rowid = ?;";



                int checkbtn = 0;
                Gtk.CheckButton [] button = {};
                while (layout.get_child_at (0,checkbtn) != null) {
                 button += new Gtk.CheckButton ();
                 if (button [checkbtn].get_active () == true) {
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
         }

         Sqlite.Statement del;

         deletecomplete = "DELETE FROM Reminders WHERE (Complete = 'true');";
         db.prepare_v2 (deletecomplete,-1,out del);
         del.step ();
         message ("All \"Completed\" reminders have been removed.");
         del.reset ();
    }




    public void editableRems () {
    //UI for selecting edited reminder
    var rems = new Gtk.ListStore (1, typeof (string));

    var popover = new Gtk.Popover (editrembtn);
    popover.popdown ();
    var editremgrid = new Gtk.Grid ();

    rems.clear ();


    Sqlite.Statement remindstmt;

    var remindname = "SELECT Name FROM  Reminders WHERE rowid = ?";


    db.prepare_v2 (remindname,-1, out remindstmt);

    int ld = 1;
    remindstmt.bind_int64 (1,ld);

    string naming;
    Gtk.TreeIter iterm;
    stdout.printf("\n");
    message ("Preparing editing");
    message ("ld prior: " + ld.to_string ());

 int checkbtn = 0;
 while (layout.get_child_at (0,checkbtn) != null) {
 checkbtn ++;
 }

    for (int i = 0; i < checkbtn; i++) {


            remindstmt.step ();

            naming = remindstmt.column_value (0).to_text ();




            message ("Rem loaded: " + naming );

            if (naming != null) {
                    rems.append (out iterm);
                    rems.set (iterm, 0, naming);

            }


            naming = "";





            var remindname2 = "SELECT Name FROM Reminders WHERE rowid = ?";
            db.prepare_v2 (remindname2,-1, out remindstmt);
            ld++;
            remindstmt.bind_int64 (1,ld);

    }
    message ("ld after: " + ld.to_string ());

    var editme = new Gtk.ComboBox.with_model (rems);

    Gtk.CellRendererText rendertext = new Gtk.CellRendererText ();
    editme.pack_start (rendertext, true);
    editme.add_attribute (rendertext, "text", 0);








    var editreminit = new Gtk.Button.with_label (_("\nEdit!\n"));
    if (editme.get_active () == -1) {
            editreminit.set_sensitive (false);
    }
    else {
            editreminit.set_sensitive (true);
    }

    editremgrid.attach (new Gtk.Label (_("\tSelect the reminder you wish to edit.\t")),0,0,3,1);
    editremgrid.attach (editme,1,1,1,1);
    message ("editme.get_sensitive: " + editme.get_sensitive ().to_string ());
    editremgrid.attach (new Gtk.Label (" "),0,2,1,1);
    editremgrid.attach (editreminit,1,3,1,1);


    popover.add (editremgrid);
    popover.show_all ();





    editme.changed.connect ( () => {
            if (editme.get_active () == -1) {
                    editreminit.set_sensitive (false);
            }
            else {
                    editreminit.set_sensitive (true);
            }
});
}











    //Save reminders
    public void saveRems (bool isNew) {
        spc++;
        //clears out that "create new reminder" message



        /* convert integer to string with .to_string (); */ /* comment deprecated when switching to granite */
        string time = reminderTime.get_text ();
        string[] tm2 = time.split (":");
        string hour = tm2 [0];
        string min = tm2 [1];
        //friendly human minutes
        //preparing for putting these into labels
        string name = reminderName.get_text ();
        string[] date = reminderDate.get_text ().split ( " " );
        string year = date [2];

        string day = date [1];
        message ("date.length " + date.length.to_string ());
        if (day.length < 1) {
                message ("Changing year to the 4th part of the date because datetime is weird.");
                year = date [3];

                day = date[2];

        }




        string month = date [0];



        //    message (newremdate.get_text ());

        string frequency = reminderFreq.get_active_id ();

        stdout.printf("\n");
        message ("Changing month into computer friendly number.");
        int monthnum = 0;
        switch (month) {
        case "Jan":  monthnum = 1; break;
        case "Feb":  monthnum = 2; break;
        case "Mar":  monthnum = 3; break;
        case "Apr":  monthnum = 4; break;
        case "May":  monthnum = 5; break;
        case "Jun":  monthnum = 6; break;
        case "Jul":  monthnum = 7; break;
        case "Aug":  monthnum = 8; break;
        case "Sep":  monthnum = 9; break;
        case "Oct":  monthnum = 10; break;
        case "Nov":  monthnum = 11; break;
        case "Dec":  monthnum = 12; break;

        }
        //database friendly values

        var yearnum = int.parse (year);



        var daynum =  int.parse (day);




        var hournum =  int.parse (hour);

        var minutenum =  int.parse (min);

        var priornum = (int) reminderPrior.get_active ();
        var description = reminderDesc.get_text ();

        //Debugging datetime
        stdout.printf("\n");
        message ("Year " + yearnum.to_string ());
        message ("Month " + monthnum.to_string ());
        message ("Day " + daynum.to_string ());
        message ("Hour " + hournum.to_string ());
        message ("Min " + minutenum.to_string ());
        stdout.printf("\n");


        //makes reminder visible in main window
        message ("Adding reminder to main window.");


        layout.attach (new Gtk.CheckButton (),0,spc,1,1);
        layout.attach (new Gtk.Label (reminderName.get_text ()),1,spc,1,1);
        layout.attach (new Gtk.Label (reminderDesc.get_text ()),3,spc,1,1);
        layout.attach (new Gtk.Label (reminderPrior.get_active_id ()),4,spc,1,1);
        layout.attach (new Gtk.Label (_(" ")),5,spc,1,1);
        layout.attach (new Gtk.Label (_("\t" +year + " " + month + " " + day + " ")),6,spc,1,1);
        layout.attach (new Gtk.Label (time),7,spc,1,1);
        layout.attach (new Gtk.Label (" "),8,spc,1,1);
        layout.attach (new Gtk.Label (frequency),10,spc,1,1);
        b++;

        message ("Preparing for database!");
        //saves reminder into database

        Sqlite.Statement save;



        //open, prep, error trap, save

        if (isNew) {
        string savequery = "INSERT INTO Reminders (Complete,Name,Year,Month,Day,Hour,Minute,Priority,Description,Timing) VALUES (?,?,?,?,?,?,?,?,?,?);";
        }
        else {

        }
        res = db.prepare_v2 (savequery,-1,out save);
        if (res != Sqlite.OK) {
                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

        }
        message ("Saving...");
        rownum++;
        colmn = 1;

        //saves the completed state, false by default
        save.bind_text (colmn, "false");

        colmn = 2;


        //saves name
        save.bind_text (colmn, name);
        message ("Name: " + name);
        colmn = 3;



        //saves the year of the reminder
        save.bind_int64 (colmn, yearnum);
        message ("Year: " + yearnum.to_string ());
        colmn = 4;


        //saves the month of the reminder
        save.bind_int64 (colmn, monthnum);
        message ("Month: " + monthnum.to_string ());
        colmn = 5;


        //day of reminder
        save.bind_int64 (colmn, daynum);
        message ("Day: " + daynum.to_string ());
        colmn = 6;


        //hour of reminder
        save.bind_int64 (colmn,hournum);
        message ("Hour: " + hournum.to_string ());
        colmn = 7;


        //and minute of reminder
        save.bind_int64 (colmn, minutenum);
        message ("Minute: " + minutenum.to_string ());
        colmn = 8;

        //how important it is. determines the notification level type in the daemon
        save.bind_int64 (colmn, priornum);
        message ("Priority: " + priornum.to_string ());
        colmn = 9;

        save.bind_text (colmn,description);
        message ("Description: " + description);
        colmn=10;

        save.bind_text (colmn, frequency);
        message ("Frequency: " + frequency);


        //save and clear
        save.step ();
        save.clear_bindings ();
        save.reset ();
        message ("SAVED");

        //destroys the "new reminder" window as it is no longer necessary
        remWindow.destroy ();
        welcome.destroy ();
        window.remove (layout);
        window.add (layout);

        window.show_all ();
    }
 }
