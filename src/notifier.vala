/*
 * Copyright (c) 2018 Timemaster2 <timemaster23x@gmail.com>
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


public class notifier : Gtk.Application {
const string GETTEXT_PACKAGE = "...";




public notifier () {
        Object (
                application_id: "com.github.Timecraft.notifier",
                flags : ApplicationFlags.FLAGS_NONE
                );
}


protected override void activate () {


      /*  var provider = new Gtk.CssProvider ();
        provider.load_from_path("com/github/timecraft/notifier/style/style.css");*/
        var window = new Gtk.ApplicationWindow (this);
        var bar = new Gtk.HeaderBar ();

        //lets set a few variables, eh?
        int c = 0;
        int colmn = 0;
        int rownum = 0;
        var spc = 2;
        Gtk.CheckButton[] checkbtn = {};
        int b = 0;


        //Create database directory
        File notifdir = File.new_for_path (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier");
        File notifdata = File.new_for_path (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/" + "reminders.db");
        if (!notifdir.query_exists ()) {
                notifdir.make_directory ();
        }


        if (!notifdata.query_exists ()) {
                try {

                        Sqlite.Database db;

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
                        Sqlite.Database db;

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
                            stderr.printf (_("Unable to add TIMING column"));
                          }
                        }

                }finally { /*do what?*/}
        }




        //set some app settings
        window.deletable = true;
        window.resizable = false;
        window.set_size_request(150,-1);


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

        //button for new reminder. in headerbar
        var newrembtn = new Gtk.Button ();
        newrembtn.set_image (new Gtk.Image.from_icon_name ("add",Gtk.IconSize.LARGE_TOOLBAR));
        newrembtn.tooltip_text = _("Add a new reminder");

        bar.pack_end (newrembtn);
        bar.set_title (_("Notifier"));
        bar.show_close_button = true;
        window.set_titlebar (bar);




        layout.row_spacing = 5;
        layout.attach (new Gtk.Label (_("\tName\t")),1,1,1,1);
        layout.attach (new Gtk.Label (_("\tDescription\t")),2,1,1,1);
        layout.attach (new Gtk.Label (_("\tPriority\t")),3,1,1,1);
        layout.attach (new Gtk.Label (_("\tTime\t")),5,1,4,1);
        layout.attach (new Gtk.Label (_("\tFrequency\t")),9,1,1,1);


        int lngth = checkbtn.length - 1;
        int rows = 1;


        //prepare to load reminders from database...
        var countq = "SELECT * FROM Reminders WHERE rowid = ?";
        Sqlite.Statement countstmt;
        Sqlite.Database db;
        Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db);

        db.prepare_v2 (countq,-1, out countstmt);
        int bv = 1;
        countstmt.bind_int64 (1,bv);





        //load reminders from database
        while (countstmt.step () == Sqlite.ROW) {

                layout.attach (new Gtk.Label (" "),1,spc,1,1);
                spc++;


                layout.insert_row (spc);
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

                string time = hour + ":" + min;


                string year = countstmt.column_value (2).to_text ();

                int month = countstmt.column_value (3).to_int ();
                string monthn = "";
                //switchin from integer month to string month. more human friendly
                switch ( month) {
                case 1: monthn = "January"; break;
                case 2: monthn = "February"; break;
                case 3: monthn = "March"; break;
                case 4: monthn = "April"; break;
                case 5: monthn = "May"; break;
                case 6: monthn = "June"; break;
                case 7: monthn = "July"; break;
                case 8: monthn = "August"; break;
                case 9: monthn = "September"; break;
                case 10: monthn = "October"; break;
                case 11: monthn = "November"; break;
                case 12: monthn = "December"; break;

                }

                string day = countstmt.column_value (4).to_text ();

                string description = countstmt.column_value (8).to_text ();

                string timing = countstmt.column_value (9).to_text ();


                string prior = countstmt.column_value (7).to_text ();

                checkbtn += new Gtk.CheckButton ();
                lngth = checkbtn.length - 1;
                //adding to the UI
                layout.attach (checkbtn[b],0,spc,1,1);
                layout.attach (new Gtk.Label (name),1,spc,1,1);
                layout.attach (new Gtk.Label (description),2,spc,1,1);
                layout.attach (new Gtk.Label (prior),3,spc,1,1);
                layout.attach (new Gtk.Label (_("")),4,spc,1,1);
                layout.attach (new Gtk.Label (_(year + " " + monthn + " " + day + " ")),5,spc,1,1);
                layout.attach (new Gtk.Label (time),6,spc,1,1);
                layout.attach (new Gtk.Label (" "),10,spc,1,1);
                layout.attach (new Gtk.Label (timing),9,spc,1,1);
                b++;
                spc++;
                spc++;
                rows = 3;
                //Onto the next database row, if any
                var countq2 = "SELECT * FROM Reminders WHERE rowid = ?";
                db.prepare_v2 (countq2,-1, out countstmt);
                bv++;
                countstmt.bind_int64 (1,bv);
        }
        //You have no reminders!
        if (rows==1) {
                layout.attach (new Gtk.Label (_("Create a new Reminder!")),3,2,2,1);

        }


        //create new reminder
        newrembtn.clicked.connect ( () => {
                        spc++;


                        //setup new reminder prompt UI
                        var newrem = new Gtk.Window ();
                        var newbar = new Gtk.HeaderBar ();
                        newbar.set_title (_("New Reminder"));
                        newbar.show_close_button = true;
                        newrem.set_titlebar (newbar);
                        var newremname = new Gtk.Entry ();
                        var rn = new GLib.DateTime.now_local ();
                        var newremdesc = new Gtk.Entry ();
                        var newremyear = new Gtk.SpinButton.with_range (rn.get_year (),9999,1);
                        var newremhour = new Gtk.SpinButton.with_range (0,23,1);
                        var newremmin = new Gtk.SpinButton.with_range (0,60,5);
                        var newremmonth = new Gtk.SpinButton.with_range (1,12,1);
                        var newremday = new Gtk.SpinButton.with_range (1,31,1);
                        var newremprior = new Gtk.SpinButton.with_range (0,3,1);
                        var newremtime = new Gtk.SpinButton.with_range (0,3,1);


                        newremmonth.set_wrap (true);
                        newremday.set_wrap (true);
                        newremhour.set_wrap (true);
                        newremmin.set_wrap (true);
                        newremtime.set_wrap (true);

                        var newremcanc = new Gtk.Button.with_label (_("Cancel"));
                        var newremsave = new Gtk.Button.with_label (_("Save"));
                        var newremgrid = new Gtk.Grid ();
                        newremgrid.set_halign (Gtk.Align.CENTER);
                        newremgrid.attach (new Gtk.Label (_("Reminder Name")),0,0,1,1);
                        newremgrid.attach (new Gtk.Label (_("Remind Time")),2,0,4,1);
                        newremgrid.attach (new Gtk.Label (_("Reminder description")),1,0,1,1);
                        newremgrid.attach (new Gtk.Label (_("Year")),2,1,1,1);
                        newremgrid.attach (new Gtk.Label (_("Hour")),5,1,1,1);
                        newremgrid.attach (new Gtk.Label (_("Minute")),6,1,1,1);
                        newremgrid.attach (new Gtk.Label (_("Month")),3,1,1,1);
                        newremgrid.attach (new Gtk.Label (_("Day")),4,1,1,1);
                        newremgrid.insert_column(7);
                        newremgrid.attach (new Gtk.Label (_("Priority")),7,0,1,1);
                        newremgrid.attach (new Gtk.Label (_("Frequency")),8,0,1,1);
                        newremgrid.attach (newremname,0,2,1,1);
                        newremgrid.attach (newremdesc,1,2,1,1);
                        newremgrid.attach (newremyear,2,2,1,1);
                        newremgrid.attach (newremmonth,3,2,1,1);
                        newremgrid.attach (newremday,4,2,1,1);
                        newremgrid.attach (newremhour,5,2,1,1);
                        newremgrid.attach (newremmin,6,2,1,1);
                        newremgrid.attach (newremprior,7,2,1,1);
                        newremgrid.attach (newremtime,8,2,1,1);

                        var timename = new Gtk.Label ("None");
                        newremgrid.attach (timename,8,3,1,1);
                        newremtime.value_changed.connect ( () => {
                          switch (newremtime.get_value_as_int ()){
                            case 0: timename.set_text ("None"); break;
                            case 1: timename.set_text ("Daily"); break;
                          //case 2: timename.set_text ("Weekly"); break;
                            case 2: timename.set_text ("Monthly"); break;
                            case 3: timename.set_text ("Yearly"); break;
                          }
                          });
                        var monthname = new Gtk.Label (_("January"));

                        newremgrid.attach (monthname,3,3,1,1);

                        newremmonth.value_changed.connect ( () => {
                                //human friendly string month
                                switch ( (int) newremmonth.get_value ()) {
                                case 1: monthname.set_text (_("January")); break;
                                case 2: monthname.set_text (_("February")); break;
                                case 3: monthname.set_text (_("March")); break;
                                case 4: monthname.set_text (_("April")); break;
                                case 5: monthname.set_text (_("May")); break;
                                case 6: monthname.set_text (_("June")); break;
                                case 7: monthname.set_text (_("July")); break;
                                case 8: monthname.set_text (_("August")); break;
                                case 9: monthname.set_text (_("September")); break;
                                case 10: monthname.set_text (_("October")); break;
                                case 11: monthname.set_text (_("November")); break;
                                case 12: monthname.set_text (_("December")); break;

                                }
                        });

                        // a very rudimentary way of allowing for AM/PM style time.
                        //Need help figuring out how to ask the system for this information.
                        var hourampm = new Gtk.Label ("12:00 AM");
                        newremgrid.attach (hourampm,5,3,1,1);
                        newremhour.value_changed.connect ( () =>{
                                switch ( (int) newremhour.get_value ()) {
                                case 0: hourampm.set_text ("12:00 AM"); break;
                                case 1: hourampm.set_text ("1:00 AM"); break;
                                case 2: hourampm.set_text ("2:00 AM"); break;
                                case 3: hourampm.set_text ("3:00 AM"); break;
                                case 4: hourampm.set_text ("4:00 AM"); break;
                                case 5: hourampm.set_text ("5:00 AM"); break;
                                case 6: hourampm.set_text ("6:00 AM"); break;
                                case 7: hourampm.set_text ("7:00 AM"); break;
                                case 8: hourampm.set_text ("8:00 AM"); break;
                                case 9: hourampm.set_text ("9:00 AM"); break;
                                case 10: hourampm.set_text ("10:00 AM"); break;
                                case 11: hourampm.set_text ("11:00 AM"); break;
                                case 12: hourampm.set_text ("12:00 PM"); break;
                                case 13: hourampm.set_text ("1:00 PM"); break;
                                case 14: hourampm.set_text ("2:00 PM"); break;
                                case 15: hourampm.set_text ("3:00 PM"); break;
                                case 16: hourampm.set_text ("4:00 PM"); break;
                                case 17: hourampm.set_text ("5:00 PM"); break;
                                case 18: hourampm.set_text ("6:00 PM"); break;
                                case 19: hourampm.set_text ("7:00 PM"); break;
                                case 20: hourampm.set_text ("8:00 PM"); break;
                                case 21: hourampm.set_text ("9:00 PM"); break;
                                case 22: hourampm.set_text ("10:00 PM"); break;
                                case 23: hourampm.set_text ("11:00 PM"); break;
                                }
                        });

                        //attach the necessary buttons to the window, and show
                        newremgrid.attach (newremsave,5,4,1,1);
                        newremgrid.attach (newremcanc,0,4,1,1);
                        newrem.add (newremgrid);
                        newrem.show_all ();
                        newremcanc.clicked.connect ( () => {
                                //user didn't want a new reminder : (
                                newrem.destroy ();
                        });
                        //saves new reminder
                        newremsave.clicked.connect ( () => {
                                layout.attach (new Gtk.Label (" "),1,spc,1,1);
                                spc++;
                                //clears out that "create new reminder" message
                                rows=3;
                                if (rows==3) {
                                        layout.remove_row (2);
                                        layout.insert_row (2);
                                }


                                /* convert integer to string with .to_string (); */
                                string hour = newremhour.get_value ().to_string ();
                                string colon = ":";
                                string min = newremmin.get_value ().to_string ();
                                //friendly human minutes
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
                                //preparing for putting these into labels
                                string name = newremname.get_text ();
                                string time = hour + colon + min;
                                string year = newremyear.get_value ().to_string ();
                                string month = monthname.get_text ();
                                string day = newremday.get_value ().to_string ();
                                string prior = newremprior.get_value ().to_string ();
                                string frequency = timename.get_text ();


                                //makes reminder visible in main window
                                checkbtn += new Gtk.CheckButton ();
                                lngth = checkbtn.length - 1;
                                layout.attach (checkbtn[b],0,spc,1,1);
                                layout.attach (new Gtk.Label (newremname.get_text ()),1,spc,1,1);
                                layout.attach (new Gtk.Label (newremdesc.get_text ()),2,spc,1,1);
                                layout.attach (new Gtk.Label (prior),3,spc,1,1);
                                layout.attach (new Gtk.Label (_(" ")),4,spc,1,1);
                                layout.attach (new Gtk.Label (_(year + " " + month + " " + day + " ")),5,spc,1,1);
                                layout.attach (new Gtk.Label (time),6,spc,1,1);
                                layout.attach (new Gtk.Label (" "),7,spc,1,1);
                                layout.attach (new Gtk.Label (frequency),9,spc,1,1);
                                b++;

                                //saves reminder into database
                                Sqlite.Database db3;
                                Sqlite.Statement save;

                                //database friendly values
                                var yearnum = (int) newremyear.get_value ();
                                var monthnum = (int) newremmonth.get_value ();
                                var daynum = (int) newremday.get_value ();
                                var hournum = (int) newremhour.get_value ();
                                var minutenum = (int) newremmin.get_value ();
                                var priornum = (int) newremprior.get_value ();
                                var description = newremdesc.get_text ();

                                //open, prep, error trap
                                Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db3);

                                string savequery = "INSERT INTO Reminders (Complete,Name,Year,Month,Day,Hour,Minute,Priority,Description,Timing) VALUES (?,?,?,?,?,?,?,?,?,?);";
                                int res = db3.prepare_v2 (savequery,-1,out save);
                                if (res != Sqlite.OK) {
                                        stderr.printf (_("Error: %d: %s\n"), db3.errcode (), db3.errmsg ());

                                }
                                rownum++;
                                colmn = 1;

                                //saves the completed state, false by default
                                save.bind_text (colmn, "false");
                                colmn = 2;


                                //saves name
                                save.bind_text (colmn, name);
                                colmn = 3;



                                //saves the year of the reminder
                                save.bind_int64 (colmn, yearnum);
                                colmn = 4;


                                //saves the month of the reminder
                                save.bind_int64 (colmn, monthnum);
                                colmn = 5;


                                //day of reminder
                                save.bind_int64 (colmn, daynum);
                                colmn = 6;


                                //hour of reminder
                                save.bind_int64 (colmn,hournum);
                                colmn = 7;


                                //and minute of reminder
                                save.bind_int64 (colmn, minutenum);
                                colmn = 8;

                                //how important it is. determines the notification level type in the daemon
                                save.bind_int64 (colmn, priornum);
                                colmn = 9;

                                save.bind_text (colmn,description);
                                colmn=10;

                                save.bind_text (colmn, frequency);


                                //save and clear
                                save.step ();
                                save.clear_bindings ();
                                save.reset ();

                                //destroys the "new reminder" window as it is no longer necessary
                                newrem.destroy ();

                                window.show_all ();

                        });
                        //Gtk.Grid.attach (widget,column,row,rows taken, columns taken)


                });







        window.add (layout);


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

                                Sqlite.Database db4;
                                int data = Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db4);
                                if (data != Sqlite.OK) {
                                        stderr.printf (_("Can't open the reminders database: %d: %s\n"), db4.errcode (), db4.errmsg ());
                                }
                                Sqlite.Statement update;

                                string updatequery = "UPDATE Reminders SET Complete = 'false' WHERE rowid = ?;";





                                if (checkbtn[i].get_active () == true) {
                                        updatequery = "UPDATE Reminders SET Complete = 'true' WHERE rowid = ?;";

                                }
                                if (db4.prepare_v2 (updatequery,-1,out update) != Sqlite.OK) {
                                        layout.attach (new Gtk.Label (db4.errmsg ()),3,0,1,3);
                                }



                                if (update.bind_int64 (1,c) != Sqlite.OK) {
                                        layout.attach (new Gtk.Label (db4.errmsg ()),3,0,1,3);
                                }
                                if (update.step () != Sqlite.OK) {
                                        layout.attach (new Gtk.Label (db4.errmsg ()),3,0,1,3);
                                }

                                update.clear_bindings ();
                                update.reset ();
                                i++;
                                c++;
                        }
                        Sqlite.Database db5;
                        Sqlite.Statement del;
                        Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db5);
                        var deletecomplete = "DELETE FROM Reminders WHERE (Complete = 'true');";
                        db5.prepare_v2 (deletecomplete,-1,out del);
                        del.step ();
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
