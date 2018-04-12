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
private Gtk.ApplicationWindow app;



public notifier (){
        Object (
                application_id: "com.github.Timecraft.notifier",
                flags : ApplicationFlags.FLAGS_NONE
                );
}
protected override void activate () {



        var window = new Gtk.ApplicationWindow (this);
        int colmn = 0;

        int rownum=0;

        window.title="Notifier";

























        var col = 4;
        var spc= 2;
        Gtk.CheckButton[] checkbtn = {};
        int b = 0;
        //Create database directory
        File notifdir = File.new_for_path (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier");
        File notifdata = File.new_for_path (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/" + "reminders.db");
        if (!notifdir.query_exists ()) {
                notifdir.make_directory();
        }


        if(!notifdata.query_exists ()) {
                try{

                        Sqlite.Database db;
                        string errmsg;
                        //Create Database
                        int data = Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db);
                        if (data != Sqlite.OK) {
                                stderr.printf ("Can't open the reminders database: %d: %s\n", db.errcode (), db.errmsg ());
                        }

                        string q = """
                        CREATE TABLE Reminders (
              Complete		TEXT      ,
              Name            TEXT            ,
              Year          INTEGER		,
              Month           INTEGER		,
              Day           INTEGER		,
              Hour			INTEGER         ,
              Minute		INTEGER         ,
              Priority		INTEGER
                          );
            """;
                        data = db.exec (q,null, out errmsg);
                        if (data != Sqlite.OK) {
                                stderr.printf ("Error:  %s\n", errmsg);
                        }
                        stdout.puts ("Created.\n");
                } catch (Error e) {
                        stdout.printf("Error:  %s\n",e.message);


                }
        }

        else{
                try{

                        Sqlite.Database db;

                        int data = Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db);
                        if (data != Sqlite.OK) {
                                stderr.printf ("Can't open the reminders database: %d: %s\n", db.errcode (), db.errmsg ());
                        }

                }finally{}
        }





        this.app.deletable = true;
        this.app.resizable = true;
        this.app.get_style_context ().add_class ("window-background-color");

        var layout = new Gtk.Grid ();
        layout.set_halign(Gtk.Align.START);
        layout.insert_column (0);
        layout.insert_column (1);
        layout.insert_column (2);
        layout.insert_column (3);
        layout.insert_column (4);
        layout.insert_column (5);




        var newrembtn = new Gtk.Button.with_label ("New Reminder");
        int c = 0;



        int lngth = checkbtn.length-1;
        uint rows=layout.get_row_spacing ();


        var countq = "SELECT * FROM Reminders WHERE rowid=?";
        Sqlite.Statement countstmt;
        Sqlite.Database db;
        Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db);

        db.prepare_v2 (countq,-1, out countstmt);
        int bv = 1;
        countstmt.bind_int64(1,bv);






        while(countstmt.step () ==Sqlite.ROW) {


                layout.insert_row(spc);


                string name = countstmt.column_value (1).to_text ();

                string hour = countstmt.column_value (5).to_text ();

                string min = countstmt.column_value (6).to_text ();

                switch (min) {
                case "0": min="00"; break;
                case "1": min="01"; break;
                case "2": min="02"; break;
                case "3": min="03"; break;
                case "4": min="04"; break;
                case "5": min="05"; break;
                case "6": min="06"; break;
                case "7": min="07"; break;
                case "8": min="08"; break;
                case "9": min="09"; break;

                }

                string time = hour + ":" + min;


                string year = countstmt.column_value (2).to_text ();

                int month =  countstmt.column_value (3).to_int ();
                string monthn = "";

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

                string prior = countstmt.column_value (7).to_text ();

                checkbtn += new Gtk.CheckButton ();
                lngth = checkbtn.length-1;
                layout.attach (checkbtn[b],0,spc,1,1);
                layout.attach (new Gtk.Label (name),1,spc,1,1);
                layout.attach (new Gtk.Label (prior),2,spc,1,1);
                layout.attach (new Gtk.Label (""),3,spc,1,1);
                layout.attach (new Gtk.Label (year + " " + monthn + " " + day),4,spc,1,1);
                layout.attach (new Gtk.Label (time),5,spc,1,1);
                b++;
                spc++;
                rows=3;
                var countq2 = "SELECT * FROM Reminders WHERE rowid=?";
                db.prepare_v2 (countq2,-1, out countstmt);
                bv++;
                countstmt.bind_int64(1,bv);
        }

        if (rows<3) {
                layout.attach (new Gtk.Label ("Create a new Notifier!"),1,2,1,1);

        }


        //create new reminder
        newrembtn.clicked.connect ( ()=>{
                        spc++;
                        var newrem = new Gtk.Window ();
                        newrem.title = "New Reminder";
                        var newremname = new Gtk.Entry ();
                        var rn = new GLib.DateTime.now_local ();
                        var newremyear = new Gtk.SpinButton.with_range (rn.get_year (),9999,1);
                        var newremhour = new Gtk.SpinButton.with_range (0,23,1);
                        var newremmin = new Gtk.SpinButton.with_range (0,60,5);
                        var newremmonth = new Gtk.SpinButton.with_range (1,12,1);
                        var newremday = new Gtk.SpinButton.with_range (1,31,1);
                        var newremprior = new Gtk.SpinButton.with_range (0,3,1);
                        var newremcanc = new Gtk.Button.with_label ("Cancel");
                        var newremsave = new Gtk.Button.with_label ("Save");
                        var newremgrid = new Gtk.Grid ();
                        newremgrid.set_halign(Gtk.Align.CENTER);
                        newremgrid.attach (new Gtk.Label ("Reminder Name"),0,0,1,1);
                        newremgrid.attach (new Gtk.Label ("Remind Time"),1,0,4,1);
                        newremgrid.attach (new Gtk.Label ("Year"),1,1,1,1);
                        newremgrid.attach (new Gtk.Label ("Hour"),4,1,1,1);
                        newremgrid.attach (new Gtk.Label ("Minute"),5,1,1,1);
                        newremgrid.attach (new Gtk.Label ("Month"),2,1,1,1);
                        newremgrid.attach (new Gtk.Label ("Day"),3,1,1,1);
                        newremgrid.attach (new Gtk.Label ("Priority"),6,0,1,1);
                        newremgrid.attach (newremname,0,2,1,1);
                        newremgrid.attach (newremyear,1,2,1,1);
                        newremgrid.attach (newremmonth,2,2,1,1);
                        newremgrid.attach (newremday,3,2,1,1);
                        newremgrid.attach (newremhour,4,2,1,1);
                        newremgrid.attach (newremmin,5,2,1,1);
                        newremgrid.attach (newremprior,6,2,1,1);
                        if (rows<3) {
                                layout.remove_row (2);
                                layout.insert_row (2);
                        }
                        var monthname = new Gtk.Label("January");
                        newremgrid.attach(monthname,2,3,1,1);
                        newremmonth.value_changed.connect( ()=>{
                                switch ( (int) newremmonth.get_value ()) {
                                case 1: monthname.set_text("January"); break;
                                case 2: monthname.set_text("February"); break;
                                case 3: monthname.set_text("March"); break;
                                case 4: monthname.set_text("April"); break;
                                case 5: monthname.set_text("May"); break;
                                case 6: monthname.set_text("June"); break;
                                case 7: monthname.set_text("July"); break;
                                case 8: monthname.set_text("August"); break;
                                case 9: monthname.set_text("September"); break;
                                case 10: monthname.set_text("October"); break;
                                case 11: monthname.set_text("November"); break;
                                case 12: monthname.set_text("December"); break;

                                }
                        });


                        newremgrid.attach (newremsave,5,4,1,1);
                        newremgrid.attach (newremcanc,0,4,1,1);
                        newrem.add (newremgrid);
                        newrem.show_all ();
                        /*newremcanc.clicked.connect ( ()=>{
                           newrem.quit
                           });*/
                        //saves new reminder
                        newremsave.clicked.connect ( ()=>{


                                /* convert integer to string with .to_string (); */
                                string hour = newremhour.get_value ().to_string ();
                                string colon = ":";
                                string min =  newremmin.get_value ().to_string ();
                                switch (min) {
                                case "0": min="00"; break;
                                case "1": min="01"; break;
                                case "2": min="02"; break;
                                case "3": min="03"; break;
                                case "4": min="04"; break;
                                case "5": min="05"; break;
                                case "6": min="06"; break;
                                case "7": min="07"; break;
                                case "8": min="08"; break;
                                case "9": min="09"; break;

                                }
                                string name = newremname.get_text();
                                string time = hour + colon + min;
                                string year = newremyear.get_value ().to_string();
                                string month = monthname.get_text();
                                string day = newremday.get_value ().to_string();
                                string prior = newremprior.get_value ().to_string ();


                                //makes reminder visible in main window
                                checkbtn += new Gtk.CheckButton ();
                                lngth = checkbtn.length-1;
                                layout.attach (checkbtn[b],0,spc,1,1);
                                layout.attach (new Gtk.Label (newremname.get_text ()),1,spc,1,1);
                                layout.attach (new Gtk.Label (prior),2,spc,1,1);
                                layout.attach (new Gtk.Label (" "),3,spc,1,1);
                                layout.attach (new Gtk.Label (year + " " + month + " " + day),4,spc,1,1);
                                layout.attach (new Gtk.Label (time),5,spc,1,1);
                                b++;

                                //saves reminder into database
                                Sqlite.Database db3;
                                Sqlite.Statement save;

                                var yearnum = (int) newremyear.get_value ();
                                var monthnum = (int) newremmonth.get_value ();
                                var daynum = (int) newremday.get_value ();
                                var hournum = (int) newremhour.get_value ();
                                var minutenum = (int) newremmin.get_value ();
                                var priornum = (int) newremprior.get_value ();


                                Sqlite.Database.open(Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db3);

                                string savequery = "INSERT INTO Reminders (Complete,Name,Year,Month,Day,Hour,Minute,Priority) VALUES (?,?,?,?,?,?,?,?);";
                                int res = db3.prepare_v2(savequery,-1,out save);
                                if (res != Sqlite.OK) {
                                        stderr.printf ("Error: %d: %s\n", db3.errcode (), db3.errmsg ());

                                }
                                rownum++;
                                colmn = 1;


                                save.bind_text (colmn, "false");
                                colmn = 2;



                                save.bind_text (colmn, name);
                                colmn = 3;




                                save.bind_int64 (colmn, yearnum);
                                colmn = 4;



                                save.bind_int64 (colmn, monthnum);
                                colmn = 5;



                                save.bind_int64 (colmn, daynum);
                                colmn =6;



                                save.bind_int64 (colmn,hournum);
                                colmn =7;



                                save.bind_int64 (colmn, minutenum);
                                colmn =8;


                                save.bind_int64 (colmn, priornum);



                                save.step();
                                save.clear_bindings();
                                save.reset();











                                //destroys the "new reminder" window as it is no longer necessary
                                newrem.destroy ();

                                window.show_all ();

                        });
                        //Gtk.Grid.attatch (widget,column,row,columns taken, rows taken)


                });

        //sets up main UI
        layout.attach (newrembtn,0,0,2,1);



        layout.row_spacing =5;
        layout.attach (new Gtk.Label ("Name\t"),1,1,1,1);
        layout.attach (new Gtk.Label ("Priority\t"),2,1,1,1);
        layout.attach (new Gtk.Label ("Time\t"),4,1,1,1);





        window.add (layout);


        window.show_all();
        var quit_action = new SimpleAction ("quit", null);
        quit_action.activate.connect ( () => {

                        if (window != null) {

                                window.destroy ();
                        }
                });

        add_action (quit_action);
        set_accels_for_action ("app.quit",{"<Control>Q",null});



        window.destroy.connect( () =>{
                        c=1;

                        int i = 0;
                        while( i <=lngth) {

                                Sqlite.Database db4;
                                int data = Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db4);
                                if (data != Sqlite.OK) {
                                        stderr.printf ("Can't open the reminders database: %d: %s\n", db4.errcode (), db4.errmsg ());
                                }
                                Sqlite.Statement update;

                                string updatequery = "UPDATE Reminders SET Complete='false' WHERE rowid=?;";





                                if (checkbtn[i].get_active () == true) {
                                        updatequery = "UPDATE Reminders SET Complete='true' WHERE rowid=?;";

                                }
                                if(db4.prepare_v2(updatequery,-1,out update) != Sqlite.OK) {
                                        layout.attach (new Gtk.Label(db4.errmsg ()),3,0,1,3);
                                }



                                if(update.bind_int64 (1,c) != Sqlite.OK) {
                                        layout.attach (new Gtk.Label(db4.errmsg ()),3,0,1,3);
                                }
                                if(update.step () != Sqlite.OK) {
                                        layout.attach (new Gtk.Label(db4.errmsg ()),3,0,1,3);
                                }

                                update.clear_bindings ();
                                update.reset ();
                                i++;
                                c++;
                        }
                        Sqlite.Database db5;
                        Sqlite.Statement del;
                        Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db5);
                        var deletecomplete = "DELETE FROM Reminders WHERE (Complete='true');";
                        db5.prepare_v2 (deletecomplete,-1,out del);
                        del.step ();
                        del.reset ();


                        Sqlite.Statement chngrowid;
                        var changerowid = "VACUUM;";
                        db.prepare_v2 (changerowid, -1, out chngrowid);
                        chngrowid.step();
                        chngrowid.reset();

                });



}
}
public static int main (string [] args ){
        var app = new notifier ();
        return app.run (args);
}
