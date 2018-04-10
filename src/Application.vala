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

        window.title="Notifier";
        var col = 4;
        var spc= 2;

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
              complete		TEXT   		NOT NULL,
              name            TEXT        		NOT NULL,
              year          INTEGER		NOT NULL,
              month           INTEGER		NOT NULL,
              day          	INTEGER		NOT NULL,
              hour			INTEGER         NOT NULL,
              minute		INTEGER         NOT NULL,
              priority		INTEGER           NOT NULL
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
        layout.set_halign(Gtk.Align.CENTER);
        layout.column_spacing = col;
        layout.row_spacing = spc;
        uint rows=layout.get_row_spacing ();
        var newrembtn = new Gtk.Button.with_label ("New Reminder");



        if (rows<3) {
                layout.attach (new Gtk.Label ("Create a new Notifier!"),1,2,1,1);
        }
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
                        if (rows==2) {
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



                                layout.attach (new Gtk.CheckButton (),0,spc,1,1);
                                layout.attach (new Gtk.Label (newremname.get_text ()),1,spc,1,1);
                                layout.attach (new Gtk.Label (prior),2,spc,1,1);
                                layout.attach (new Gtk.Label (" "),3,spc,1,1);
                                layout.attach (new Gtk.Label (year + " " + month + " " + day),4,spc,1,1);
                                layout.attach (new Gtk.Label (time),5,spc,1,1);
                                Sqlite.Database db;
                                Sqlite.Statement save;
                                colmn ++;


                                Sqlite.Database.open(Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db);


                                int res = db.prepare_v2("INSERT INTO Reminders (complete,name,year,month,day,hour,minute,priority) VALUES ('false',?,?,?,?,?,?,?)",-1,out save);
                                save.bind_text (colmn, name);
                                save.bind_int (colmn, (int) newremyear.get_value ());
                                save.bind_int (colmn, (int) newremmonth);
                                save.bind_int (colmn, (int) newremday);
                                save.bind_int (colmn, (int) newremhour);
                                save.bind_int (colmn, (int) newremmin);
                                save.bind_int (colmn, (int) newremprior);
                                save.step();

                                save.reset();




                                //save reminders to a file for reload reference





                                newrem.destroy ();

                                window.show_all ();

                        });
                        //Gtk.Grid.attatch (widget,column,row,columns taken, rows taken)


                });


        layout.attach (newrembtn,0,0,1,1);
;
        layout.insert_column (0);
        layout.insert_column (4);

        layout.attach (new Gtk.Label ("Name"),1,1,1,1);
        layout.attach (new Gtk.Label ("Priority"),2,1,1,1);
        layout.attach (new Gtk.Label ("Time\t"),3,1,3,1);

        window.add (layout);

        window.show_all ();

        var quit_action = new SimpleAction ("quit", null);
        quit_action.activate.connect ( () => {

                        if (window != null) {
                                window.destroy ();
                        }
                });

        add_action (quit_action);
        set_accels_for_action ("app.quit",{"<Control>Q",null});
}
}
public static int main (string [] args ){
        var app = new notifier ();
        return app.run (args);
}
