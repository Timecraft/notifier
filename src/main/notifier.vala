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

using Granite.Widgets, notifier.Vars, notifier.Rems, notifier.Widgets;

namespace notifier.main {
public class notifier : Gtk.Application {
const string GETTEXT_PACKAGE = "...";




public notifier () {
        Object (
                application_id: "com.github.timecraft.notifier",
                flags : ApplicationFlags.FLAGS_NONE
                );
}


protected override void activate () {


        


window = new Gtk.ApplicationWindow (this);


        //Checking to see if User's computer is configured for 24h or am/pm
        am24pm = new DateTime.now_local ();
        testampm = new TimePicker ();
        testampm.time = am24pm;
        string wit = testampm.get_text ();
        message (wit);

        ap = wit.contains ("AM");

        if (ap == false) {
                ap = wit.contains ("PM");
        }






        

        //lets set a few variables, eh?
        
        


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




        

       









        


        












                        //Gtk.Grid.attach (widget,column,row,rows taken, columns taken)


                










        



}
}
}
public static int main (string [] args ) {
        var app = new notifier.main.notifier ();
        return app.run (args);
}
