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

using Granite.Widgets;

public class notifier : Gtk.Application {
const string GETTEXT_PACKAGE = "...";




public notifier () {
        Object (
                application_id: "com.github.timecraft.notifier",
                flags : ApplicationFlags.FLAGS_NONE
                );
}


protected override void activate () {


        //Welcome to Notifier
        var welcome = new Granite.Widgets.Welcome ("Notifier", "\t\t\t\t\t\t\t\t\t\t\t\t");
        welcome.append ("list-add",_("Add a reminder"),"");





        //Checking to see if User's computer is configured for 24h or am/pm
        var am24pm = new DateTime.now_local ();
        var testampm = new TimePicker ();
        testampm.time = am24pm;
        string wit = testampm.get_text ();
        message (wit);

        var ap = wit.contains ("AM");

        if (ap == false) {
                ap = wit.contains ("PM");
        }






        var window = new Gtk.ApplicationWindow (this);



        var bar = new Gtk.HeaderBar ();
        window.set_position(Gtk.WindowPosition.CENTER);

        //lets set a few variables, eh?
        int c = 0;
        int colmn = 0;
        int rownum = 0;
        var spc = 1;
        Gtk.CheckButton[] checkbtn = {};
        int b = 0;



        //Create database directory
        File notifdir = File.new_for_path (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier");
        File notifdata = File.new_for_path (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/" + "reminders.db");
        if (!notifdir.query_exists ()) {
                try {
                        notifdir.make_directory ();
                } catch (Error e) {
                        message (_("Error: " + e.message));
                }
        }

        Sqlite.Database db;
        if (!notifdata.query_exists ()) {
                try {



                        //Create Database
                        int data = Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db);
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
                        Sqlite.Statement query;
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


                        int data = Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db);
                        if (data != Sqlite.OK) {
                                stderr.printf (_("Can't open the reminders database: %d: %s\n"), db.errcode (), db.errmsg ());
                        }
                        /*Since this is a new update and users who have the app will have
                           the database but not the timing column, we're going to check to see if it exists.
                           If it does not, we'll alter the table to have that column.
                         */
                        var timingstmt = "SELECT * FROM Reminders WHERE Timing;";
                        Sqlite.Statement timingq;
                        db.prepare_v2 (timingstmt,-1,out timingq);
                        if (timingq.step () != Sqlite.OK) {
                                Sqlite.Statement ctq;
                                var ctstmt = "ALTER TABLE Reminders ADD COLUMN Timing";
                                db.prepare_v2 (ctstmt,-1,out ctq);

                                if (ctq.step () != Sqlite.OK) {
                                        message (_("Unable to add TIMING column"));
                                }
                        }

                }finally { /*do what?*/}
        }




        //set some app settings
        window.deletable = true;
        window.resizable = false;
        window.set_size_request(150,330);


        //create the layout grid
        var layout = new Gtk.Grid ();
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

        //button for new reminder and edit reminder in headerbar
        var newrembtn = new Gtk.Button ();
        newrembtn.set_image (new Gtk.Image.from_icon_name ("list-add",Gtk.IconSize.LARGE_TOOLBAR));
        newrembtn.tooltip_text = (_("Add a new reminder"));

        //You pressed a thing on the Welcome Screen, so this should open up the New Reminder Window
        welcome.activated.connect ( (i) => {
                        newrembtn.activate ();
                });



        var spclbl = new Gtk.Label ("\t");

        var editrembtn = new Gtk.Button ();
        editrembtn.set_image (new Gtk.Image.from_icon_name ("edit",Gtk.IconSize.LARGE_TOOLBAR));
        editrembtn.tooltip_text = (_("Edit an existing reminder"));



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


        int lngth = checkbtn.length - 1;
        int rows = 1;


        //prepare to load reminders from database...
        var countq = "SELECT * FROM Reminders WHERE rowid = ?";
        Sqlite.Statement countstmt;

        Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db);

        db.prepare_v2 (countq,-1, out countstmt);
        int bv = 1;
        countstmt.bind_int64 (1,bv);





        //load reminders from database
        int spc2 = 1;
        while (countstmt.step () == Sqlite.ROW) {

                spc++;
                spc2++;
                message (spc2.to_string ());



                lngth = checkbtn.length - 1;


                string name = countstmt.column_value (1).to_text ();

                string hour = countstmt.column_value (5).to_text ();

                string min = countstmt.column_value (6).to_text ();
                //adding a 0 to single digit minutes. human friendly


                switch (min) {
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

                string time = hour + ":" + min;


                string year = countstmt.column_value (2).to_text ();

                int month =  countstmt.column_value (3).to_int ();
                string monthn = "";
                //switchin from integer month to string month. more human friendly
                switch (month) {
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

                string day = countstmt.column_value (4).to_text ();

                string description = countstmt.column_value (8).to_text ();
                Sqlite.Statement notimeupd;
                string timing = countstmt.column_value (9).to_text ();
                if (timing == "") {
                        timing=_("None");
                        string notime = "UPDATE Reminders SET Timing = 'None' WHERE rowid = ?;";
                        db.prepare_v2 (notime,-1,out notimeupd);
                        notimeupd.bind_int64(1,bv);
                        notimeupd.step ();
                        notimeupd.reset ();
                        notimeupd.clear_bindings ();
                }


                string prior = countstmt.column_value (7).to_text ();
                switch (prior) {
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
                var countq2 = "SELECT * FROM Reminders WHERE rowid = ?";
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









//Selction for editing Reminders
        editrembtn.clicked.connect ( () => {
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


                        for (int i = 0; i < checkbtn.length; i++) {


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









//Actually editing
                        editreminit.clicked.connect ( () => {
                                ld = 1;
                                message ("Clearing remindstmt");
                                remindstmt.clear_bindings ();
                                remindstmt.reset ();





                                var remnum = editme.get_active () + 1;


                                //Showing Previously made values;

                                var reminder = "SELECT * FROM  Reminders WHERE rowid = ?";
                                Sqlite.Statement reminderstmt;
                                db.prepare_v2 (reminder,-1, out reminderstmt);


                                reminderstmt.bind_int64 (1,remnum);

                                reminderstmt.step ();


                                while (reminderstmt.column_value (3).to_int () == 0) {
                                        reminderstmt.clear_bindings ();

                                        message ("Adding 1 to remnum, as selected reminder is empty.");

                                        reminder = "SELECT * FROM  Reminders WHERE rowid = ?";
                                        db.prepare_v2 (reminder,-1, out reminderstmt);
                                        reminderstmt.bind_int64(1,remnum + 1);
                                        reminderstmt.step ();
                                        remnum++;
                                }

                                string name = reminderstmt.column_value (1).to_text ();
                                message ("Reminder name = " + name);

                                string hr = reminderstmt.column_value (5).to_text ();
                                message ("Reminder hour = " + hr);

                                string minn = reminderstmt.column_value (6).to_text ();
                                message ("Reminder minute = " + minn);

                                string year = reminderstmt.column_value (2).to_text ();
                                message ("Reminder year = " + year);

                                int month =  reminderstmt.column_value (3).to_int ();
                                message ("Reminder month = " + month.to_string ());

                                string day = reminderstmt.column_value (4).to_text ();
                                message ("Reminder day = " + day);

                                string description = reminderstmt.column_value (8).to_text ();
                                message ("Reminder desc = " + description);

                                string timing = reminderstmt.column_value (9).to_text ();
                                message ("Reminder timing = " + timing);

                                var editprior = reminderstmt.column_value (7).to_int ();

                                // Preparing values for the ComboBox
                                Gtk.TreeIter iter;
                                var priorities = new Gtk.ListStore (2, typeof (string), typeof (string));


                                priorities.append (out iter);
                                priorities.set (iter, 0, _("Normal"), 1, _("\tA standard notification type."));
                                priorities.append (out iter);
                                priorities.set (iter, 0, _("Low"), 1, _("\tNothing super important."));
                                priorities.append (out iter);
                                priorities.set (iter, 0, _("High"), 1, _("\tSomething important is happening!"));
                                priorities.append (out iter);
                                priorities.set (iter, 0, _("Urgent"), 1, _("\tLook a)t me. Right now."));


                                var freqs = new Gtk.ListStore (1, typeof (string));


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
                                var editrem = new Gtk.Window ();
                                var editbar = new Gtk.HeaderBar ();
                                editrem.set_size_request (400,500);
                                editbar.set_title (_("Edit Reminder"));
                                editbar.show_close_button = true;
                                editrem.set_titlebar (editbar);

                                var editremname = new Gtk.Entry ();
                                editremname.set_text (name);
                                //var rn = new GLib.DateTime.now_local ();
                                var editremdesc = new Gtk.Entry ();
                                editremdesc.set_text (description);
                                //    var editremdate = new  ();

                                var tmm = new DateTime.local (int.parse (year), month, int.parse (day), int.parse (hr), int.parse (minn), 0);


                                var editremdate = new DatePicker ();
                                editremdate.date = tmm;
                                var editremtime = new TimePicker ();
                                editremtime.time = tmm;


                                var editremprior = new Gtk.ComboBox.with_model (priorities);
                                editremprior.set_id_column (0);
                                editremprior.set_active (editprior);



                                var editremfreq = new Gtk.ComboBox.with_model (freqs);

                                editremfreq.set_id_column (0);





                                //Show text in box.
                                Gtk.CellRendererText renderer = new Gtk.CellRendererText ();
                                editremprior.pack_start (renderer, true);
                                editremprior.add_attribute (renderer, "text", 0);
                                editremprior.active = 0;




                                renderer = new Gtk.CellRendererText ();
                                editremprior.pack_start (renderer, true);
                                editremprior.add_attribute (renderer, "text", 1);
                                editremprior.active = 0;

                                editremprior.set_id_column (0);


                                renderer = new Gtk.CellRendererText ();
                                editremfreq.pack_start (renderer, true);
                                editremfreq.add_attribute (renderer, "text", 0);
                                editremfreq.active = 0;




                                var editremsave = new Gtk.Button ();
                                var editremindgrid = new Gtk.Grid ();
                                editremsave.set_image (new Gtk.Image.from_icon_name ("document-save",Gtk.IconSize.LARGE_TOOLBAR));
                                editremsave.tooltip_text = _("Save reminder");
                                editbar.pack_end (editremsave);
                                editremindgrid.set_halign (Gtk.Align.CENTER);
                                editremindgrid.attach (new Gtk.Label (_("Reminder Name")),0,0,1,1);
                                editremindgrid.attach (new Gtk.Label (_("Remind Time")),2,0,4,1);
                                editremindgrid.attach (new Gtk.Label (_("Reminder description")),1,0,1,1);
                                editremindgrid.attach (new Gtk.Label (_("Day")),2,1,1,1);
                                editremindgrid.attach (new Gtk.Label (_("Time")),5,1,1,1);
                                editremindgrid.insert_column(7);
                                editremindgrid.attach (new Gtk.Label (_("Priority")),7,0,1,1);
                                editremindgrid.attach (new Gtk.Label (_("Frequency")),9,0,1,1);
                                editremindgrid.attach (editremname,0,2,1,1);
                                editremindgrid.attach (editremdesc,1,2,1,1);
                                editremindgrid.attach (editremdate,2,2,1,1);
                                editremindgrid.attach (editremtime,5,2,2,1);
                                editremindgrid.attach (editremprior,7,2,2,1);
                                editremindgrid.attach (editremfreq,9,2,1,1);

                                //editremindgrid.attach (editremdate,5,4,1,1);









                                //attach the necessary buttons to the window, and show
                                editrem.add (editremindgrid);
                                editremindgrid.attach (new Gtk.Label (" "),0,4,1,1);
                                editrem.show_all ();













                                editme.destroy ();

                                editme.clear ();
                                popover.destroy ();


                                //saves edited reminder


                                message ("\nrownumber " + (remnum).to_string ());










                                /* convert integer to string with .to_string (); */ /* comment deprecated when switching to granite */
                                string time = editremtime.get_text ();
                                string[] tm2 = time.split (":");
                                string hr2 = tm2 [0];
                                string minn2 = tm2 [1];
                                //friendly human minutes
                                //preparing for putting these into labels
                                string name2 = editremname.get_text ();
                                string[] date2 = editremdate.get_text ().split ( " " );
                                string year2 = date2 [2];

                                string day2 = date2 [1];
                                message ("date2.length " + date2.length.to_string ());
                                if (day2.length < 1) {
                                        message ("Changing year to the 4th part of the date because datetime is weird.");
                                        day2 = date2 [2];

                                        year2 = date2 [3];

                                }




                                string month2 = date2 [0];

                                stdout.printf("\n");
                                for (int i = 0; i<date2.length; i++ ) {
                                        message (date2[i]);

                                }

                                //    message (editremdate.get_text ());

                                string frequency = editremfreq.get_active_id ();

                                stdout.printf("\n");
                                message ("Changing month into computer friendly number.");
                                int monthnum = 0;
                                switch (month2) {
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
                                //Debugging datetime
                                stdout.printf("\n");
                                message ("Year " + year2);
                                message ("Month " + month2);
                                message ("Day " + day2);
                                message ("hr " + hr2);

                                stdout.printf("\n");
                                string[] timer = minn2.split (" ");
                                minn2 = timer[0];
                                message ("Min " + minn2);

                                string ampm = timer[1];
                                message ("ampm = " + ampm);

                                remnum++;
                                editremsave.clicked.connect ( () => {
                                        for (int h = 1; h<=10; h++) {

                                                layout.get_child_at (h,remnum).destroy ();


                                                message ("At:\t" + remnum.to_string () + " " + h.to_string ());
                                        }


                                        /* convert integer to  with .to_ (); */ /* comment deprecated when switching to granite */
                                        time = editremtime.get_text ();
                                        tm2 = time.split (":");
                                        hr2 = tm2 [0];
                                        minn2 = tm2 [1];
                                        //friendly human minutes
                                        //preparing for putting these into labels
                                        name2 = editremname.get_text ();
                                        date2 = editremdate.get_text ().split ( " " );
                                        year2 = date2 [2];

                                        day2 = date2 [1];
                                        message ("date2.length " + date2.length.to_string ());
                                        if (day2.length < 1) {
                                                message ("Changing year to the 4th part of the date because datetime is weird.");
                                                day2 = date2 [2];

                                                year2 = date2 [3];

                                        }




                                        month2 = date2 [0];




                                        //makes reminder visible in main window
                                        message ("Adding reminder to main window.");

                                        checkbtn += new Gtk.CheckButton ();
                                        lngth = checkbtn.length - 1;


                                        layout.attach (checkbtn[remnum],0,(remnum),1,1);
                                        //Gtk.Grid.attach (widget,column,row,rows taken, columns taken)
                                        layout.attach (new Gtk.Label (editremname.get_text ()),1,(remnum),1,1);
                                        layout.attach (new Gtk.Label (editremdesc.get_text ()),3,(remnum),1,1);
                                        layout.attach (new Gtk.Label (editremprior.get_active_id ()),4,(remnum),1,1);
                                        layout.attach (new Gtk.Label (_(" ")),5,(remnum),1,1);
                                        layout.attach (new Gtk.Label (_("\t" + year2 + " " + month2 + " " + day2 + " ")),6,(remnum),1,1);
                                        layout.attach (new Gtk.Label (time),7,(remnum),1,1);
                                        layout.attach (new Gtk.Label (" "),8,(remnum),1,1);
                                        layout.attach (new Gtk.Label (frequency),10,(remnum),1,1);


                                        message ("Preparing for database!");
                                        //saves reminder into database

                                        Sqlite.Statement save;

                                        //database friendly values

                                        var yearnum = int.parse (year2);



                                        var daynum =  int.parse (day2);




                                        var hrnum =  int.parse (hr2);

                                        if (ampm == "PM") {
                                                message ("Adding 12 to because this is a PM situation");
                                                hrnum = (hrnum + 12);
                                                message ("Hour is now: " + hrnum.to_string ());
                                        }

                                        var minutenum =  int.parse (minn2);

                                        var priornum = (int) editremprior.get_active ();
                                        var description2 = editremdesc.get_text ();


                                        //open, prep, error trap, save



                                        string savequery = "UPDATE Reminders SET Complete='false', Name=?, Year=?, Month=?, Day=?, Hour=?, Minute=?, Priority=?, Description=?, Timing=? WHERE rowid=?;";
                                        int res = db.prepare_v2 (savequery,-1,out save);
                                        if (res != Sqlite.OK) {
                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                        }

                                        message ("Saving...");
                                        rownum++;


                                        message ("rownum: " + (remnum - 1).to_string ());
                                        colmn = 1;



                                        if (res != Sqlite.OK) {
                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                        }


                                        //saves name
                                        res = save.bind_text (colmn, name2);
                                        colmn = 2;
                                        if (res != Sqlite.OK) {
                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                        }
                                        message ("Name: " + name2);


                                        //saves the year of the reminder
                                        res = save.bind_int64 (colmn, yearnum);
                                        colmn = 3;
                                        if (res != Sqlite.OK) {
                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                        }
                                        message ("Year: " + yearnum.to_string ());

                                        //saves the month of the reminder
                                        res = save.bind_int64 (colmn, monthnum);
                                        colmn = 4;
                                        if (res != Sqlite.OK) {
                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                        }
                                        message ("Month: " + monthnum.to_string ());

                                        //day of reminder
                                        res = save.bind_int64 (colmn, daynum);
                                        colmn = 5;
                                        if (res != Sqlite.OK) {
                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                        }
                                        message ("Day: " + daynum.to_string ());

                                        //hr of reminder
                                        res = save.bind_int64 (colmn,hrnum);
                                        colmn = 6;
                                        if (res != Sqlite.OK) {
                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                        }
                                        message ("Hour: " + hrnum.to_string ());

                                        //and minute of reminder
                                        res = save.bind_int64 (colmn, minutenum);
                                        colmn = 7;
                                        if (res != Sqlite.OK) {
                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                        }
                                        message ("Minute: " + minutenum.to_string ());

                                        //how important it is. determines the notification level type in the daemon
                                        res = save.bind_int64 (colmn, priornum);
                                        colmn = 8;
                                        if (res != Sqlite.OK) {
                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                        }
                                        message ("Priority: " + priornum.to_string ());

                                        res = save.bind_text (colmn,description2);
                                        colmn=9;
                                        if (res != Sqlite.OK) {
                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                        }
                                        message ("Description: " + description2);

                                        res = save.bind_text (colmn, frequency);
                                        colmn = 10;
                                        if (res != Sqlite.OK) {
                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                        }
                                        message ("Frequency: " + frequency);
                                        res = save.bind_int64 (colmn,(remnum - 1));
                                        if (res != Sqlite.OK) {
                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                        }

                                        //save and clear
                                        res = save.step ();
                                        if (res != Sqlite.OK) {
                                                message (res.to_string ());

                                        }
                                        save.clear_bindings ();
                                        save.reset ();
                                        message ("SAVED");

                                        //destroys the "new reminder" window as it is no longer necessary
                                        editrem.destroy ();



                                        window.show_all ();

                                });
                        });



                });





















        //create new reminder
        newrembtn.clicked.connect ( () => {
                        spc++;

                        // Preparing values for the ComboBox
                        Gtk.TreeIter iter;
                        var priorities = new Gtk.ListStore (2, typeof (string), typeof (string));


                        priorities.append (out iter);
                        priorities.set (iter, 0, _("Normal"), 1, _("\tA standard notification type."));
                        priorities.append (out iter);
                        priorities.set (iter, 0, _("Low"), 1, _("\tNothing super important."));
                        priorities.append (out iter);
                        priorities.set (iter, 0, _("High"), 1, _("\tSomething important is happening!"));
                        priorities.append (out iter);
                        priorities.set (iter, 0, _("Urgent"), 1, _("\tLook at me. Right now."));


                        var freqs = new Gtk.ListStore (1, typeof (string));


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
                        var newrem = new Gtk.Window ();
                        newrem.set_size_request (400,500);
                        var newbar = new Gtk.HeaderBar ();
                        newbar.set_title (_("New Reminder"));
                        newbar.show_close_button = true;
                        newrem.set_titlebar (newbar);

                        var newremname = new Gtk.Entry ();
                        //var rn = new GLib.DateTime.now_local ();
                        var newremdesc = new Gtk.Entry ();
                        //    var newremdate = new  ();


                        var newremdate = new DatePicker ();
                        var newremtime = new TimePicker ();


                        var newremprior = new Gtk.ComboBox.with_model (priorities);


                        var newremfreq = new Gtk.ComboBox.with_model (freqs);



                        //Show text in box.
                        Gtk.CellRendererText renderer = new Gtk.CellRendererText ();
                        newremprior.pack_start (renderer, true);
                        newremprior.add_attribute (renderer, "text", 0);
                        newremprior.active = 0;

                        renderer = new Gtk.CellRendererText ();
                        newremprior.pack_start (renderer, true);
                        newremprior.add_attribute (renderer, "text", 1);
                        newremprior.active = 0;



                        newremprior.set_id_column (0);

                        renderer = new Gtk.CellRendererText ();
                        newremfreq.pack_start (renderer, true);
                        newremfreq.add_attribute (renderer, "text", 0);
                        newremfreq.active = 0;

                        newremfreq.set_id_column (0);










                        var newremsave = new Gtk.Button ();
                        var newremgrid = new Gtk.Grid ();
                        newremsave.set_image (new Gtk.Image.from_icon_name ("document-save",Gtk.IconSize.LARGE_TOOLBAR));
                        newremsave.tooltip_text = _("Save reminder");
                        newbar.pack_end (newremsave);
                        newremgrid.set_halign (Gtk.Align.CENTER);
                        newremgrid.attach (new Gtk.Label (_("Reminder Name")),0,0,1,1);
                        newremgrid.attach (new Gtk.Label (_("Remind Time")),2,0,4,1);
                        newremgrid.attach (new Gtk.Label (_("Reminder description")),1,0,1,1);
                        newremgrid.attach (new Gtk.Label (_("Day")),2,1,1,1);
                        newremgrid.attach (new Gtk.Label (_("Time")),5,1,1,1);
                        newremgrid.insert_column(7);
                        newremgrid.attach (new Gtk.Label (_("Priority")),7,0,1,1);
                        newremgrid.attach (new Gtk.Label (_("Frequency")),9,0,1,1);
                        newremgrid.attach (newremname,0,2,1,1);
                        newremgrid.attach (newremdesc,1,2,1,1);
                        newremgrid.attach (newremdate,2,2,1,1);
                        newremgrid.attach (newremtime,5,2,2,1);
                        newremgrid.attach (newremprior,7,2,2,1);
                        newremgrid.attach (newremfreq,9,2,1,1);

                        //newremgrid.attach (newremdate,5,4,1,1);









                        //attach the necessary buttons to the window, and show
                        newrem.add (newremgrid);
                        newremgrid.attach (new Gtk.Label (" "),0,4,1,1);
                        newrem.show_all ();



                        //saves new reminder
                        newremsave.clicked.connect ( () => {

                                spc++;
                                //clears out that "create new reminder" message



                                /* convert integer to string with .to_string (); */ /* comment deprecated when switching to granite */
                                string time = newremtime.get_text ();
                                string[] tm2 = time.split (":");
                                string hour = tm2 [0];
                                string min = tm2 [1];
                                //friendly human minutes
                                //preparing for putting these into labels
                                string name = newremname.get_text ();
                                string[] date = newremdate.get_text ().split ( " " );
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

                                string frequency = newremfreq.get_active_id ();

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

                                var priornum = (int) newremprior.get_active ();
                                var description = newremdesc.get_text ();

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
                                checkbtn += new Gtk.CheckButton ();
                                lngth = checkbtn.length - 1;
                                layout.attach (checkbtn[b],0,spc,1,1);
                                layout.attach (new Gtk.Label (newremname.get_text ()),1,spc,1,1);
                                layout.attach (new Gtk.Label (newremdesc.get_text ()),3,spc,1,1);
                                layout.attach (new Gtk.Label (newremprior.get_active_id ()),4,spc,1,1);
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


                                string savequery = "INSERT INTO Reminders (Complete,Name,Year,Month,Day,Hour,Minute,Priority,Description,Timing) VALUES (?,?,?,?,?,?,?,?,?,?);";
                                int res = db.prepare_v2 (savequery,-1,out save);
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
                                newrem.destroy ();
                                welcome.destroy ();
                                window.remove (layout);
                                window.add (layout);

                                window.show_all ();

                        });
                        //Gtk.Grid.attach (widget,column,row,rows taken, columns taken)


                });









        window.show_all ();
        var quit_action = new SimpleAction ("quit", null);
        quit_action.activate.connect ( () => {

                        if (window != null) {

                                window.destroy ();
                        }
                });

        add_action (quit_action);
        set_accels_for_action ("app.quit", {"<Control>Q",null});



        window.destroy.connect ( () => {
                        c = 1;

                        int i = 0;
                        while ( i <= lngth) {



                                Sqlite.Statement update;

                                string updatequery = "UPDATE Reminders SET Complete = 'false' WHERE rowid = ?;";





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

                        var deletecomplete = "DELETE FROM Reminders WHERE (Complete = 'true');";
                        db.prepare_v2 (deletecomplete,-1,out del);
                        del.step ();
                        message ("All \"Completed\" reminders have been removed.");
                        del.reset ();


                        Sqlite.Statement chngrowid;
                        var changerowid = "VACUUM;";
                        db.prepare_v2 (changerowid, -1, out chngrowid);
                        chngrowid.step ();
                        chngrowid.reset ();

                });



}
}
public static int main (string [] args ) {
        var app = new notifier ();
        return app.run (args);
}
