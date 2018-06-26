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


public class NotifierServer {





public class NotifierDaemon : GLib.Application {




public NotifierDaemon () {
        Object (application_id: "com.github.timecraft.notifier", flags : ApplicationFlags.NON_UNIQUE);
        set_inactivity_timeout (1000);
}

~NotifierDaemon () {
        release ();
}

public override void startup () {
        message ("Notifier-Daemon started");
        base.startup ();
        hold ();

}

protected override void activate () {
        var notification = new Notification ("");
        Sqlite.Database db;
        Sqlite.Database.open (Environment.get_home_dir () + "/.local/share/com.github.Timecraft.notifier/reminders.db", out db);
        while (true) {
                //prove it's running. mostly for dev purposes
                stdout.printf ("Running...\n");
                //prepare to load reminders from database...
                var countq = "SELECT * FROM Reminders WHERE rowid = ?";
                Sqlite.Statement countstmt;


                db.prepare_v2 (countq,-1, out countstmt);
                int bv = 1;
                countstmt.bind_int64 (1,bv);





                //load reminders from database
                while (countstmt.step () == Sqlite.ROW) {
                        int colmn = 0;
                        Sqlite.Statement save;


                        //get times, prepare times

                        var rn = new DateTime.now_local();
                        var today = rn.get_day_of_month();
                        var thismonth = rn.get_month();
                        var thisyear = rn.get_year();
                        var thishour = rn.get_hour();
                        var thismin = rn.get_minute();


                        //load from database
                        int year = countstmt.column_value (2).to_int ();
                        int month = countstmt.column_value (3).to_int ();

                        string name = countstmt.column_value (1).to_text ();

                        string description = countstmt.column_value(8).to_text ();

                        int hour = countstmt.column_value (5).to_int ();

                        int min = countstmt.column_value (6).to_int ();


                        string frequency = countstmt.column_value (9).to_text ();



                        int day = countstmt.column_value (4).to_int ();


                        var then = new GLib.DateTime.local (year,month,day,hour,min,0);

                        int prior = countstmt.column_value (7).to_int ();
                        var priority = NotificationPriority.LOW;

                        //check if it is time for the notification
                        if (year <= thisyear) {
                                if (month <= thismonth) {
                                        if (day <= today) {
                                                if (hour <= thishour) {
                                                        if (min <= thismin) {

                                                                switch (prior) {
                                                                case 0: priority = NotificationPriority.LOW; break;
                                                                case 1: priority = NotificationPriority.NORMAL; break;
                                                                case 2: priority = NotificationPriority.HIGH; break;
                                                                case 3: priority = NotificationPriority.URGENT; break;
                                                                }




                                                                switch (frequency) {
                                                                case "None": //no repeats of this reminder
                                                                        Sqlite.Statement makecom;
                                                                        string errmsg;

                                                                        db.exec("VACUUM",null, out errmsg);

                                                                        //here will go the piece of the script that will handle the timing



                                                                        //marks the reminder as 'complete'
                                                                        var makecomplete = "UPDATE Reminders SET Complete = 'true' WHERE rowid = ?;";
                                                                        db.prepare_v2 (makecomplete,-1,out makecom);
                                                                        makecom.bind_int64 (1,bv);
                                                                        makecom.step ();
                                                                        makecom.reset ();
                                                                        Sqlite.Statement del;
                                                                        var deletecomplete = "DELETE FROM Reminders WHERE (Complete = 'true');";
                                                                        db.prepare_v2 (deletecomplete,-1,out del);
                                                                        del.step ();
                                                                        del.reset ();
                                                                        break;

                                                                case "Daily": //Daily repeats
                                                                        Sqlite.Statement makecom;
                                                                        string errmsg;

                                                                        db.exec("VACUUM",null, out errmsg);

                                                                        //here will go the piece of the script that will handle the timing





                                                                        var rn2 = rn.add_days (1);


                                                                        string savequery = "INSERT INTO Reminders (Complete,Name,Year,Month,Day,Hour,Minute,Priority,Description,Timing) VALUES (?,?,?,?,?,?,?,?,?,?);";
                                                                        int res = db.prepare_v2 (savequery,-1,out save);
                                                                        if (res != Sqlite.OK) {
                                                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                                                        }

                                                                        colmn = 1;

                                                                        //saves the completed state, false by default
                                                                        save.bind_text (colmn, "false");
                                                                        colmn = 2;


                                                                        //saves name
                                                                        save.bind_text (colmn, name);
                                                                        colmn = 3;



                                                                        //saves the year of the reminder
                                                                        save.bind_int64 (colmn, rn2.get_year ());
                                                                        colmn = 4;


                                                                        //saves the month of the reminder
                                                                        save.bind_int64 (colmn, rn2.get_month ());
                                                                        colmn = 5;


                                                                        //day of reminder
                                                                        save.bind_int64 (colmn, rn2.get_day_of_month ());
                                                                        colmn = 6;


                                                                        //hour of reminder
                                                                        save.bind_int64 (colmn,hour);
                                                                        colmn = 7;


                                                                        //and minute of reminder
                                                                        save.bind_int64 (colmn, min);
                                                                        colmn = 8;

                                                                        //how important it is. determines the notification level type in the daemon
                                                                        save.bind_int64 (colmn, priority);
                                                                        colmn = 9;

                                                                        save.bind_text (colmn,description);
                                                                        colmn=10;

                                                                        save.bind_text (colmn, frequency);


                                                                        //save and clear
                                                                        save.step ();
                                                                        save.clear_bindings ();
                                                                        save.reset ();



                                                                        var makecomplete = "UPDATE Reminders SET Complete = 'true' WHERE rowid = ?;";
                                                                        db.prepare_v2 (makecomplete,-1,out makecom);
                                                                        makecom.bind_int64 (1,bv);
                                                                        makecom.step ();
                                                                        makecom.reset ();


                                                                        Sqlite.Statement del;
                                                                        var deletecomplete = "DELETE FROM Reminders WHERE (Complete = 'true');";
                                                                        db.prepare_v2 (deletecomplete,-1,out del);
                                                                        del.step ();
                                                                        del.reset ();
                                                                        break;

                                                                case "Weekly":   //Weekly reminders
                                                                        Sqlite.Statement makecom;
                                                                        string errmsg;

                                                                        db.exec("VACUUM",null, out errmsg);

                                                                        //here will go the piece of the script that will handle the timing




                                                                        var rn2 = rn.add_days (7);


                                                                        string savequery = "INSERT INTO Reminders (Complete,Name,Year,Month,Day,Hour,Minute,Priority,Description,Timing) VALUES (?,?,?,?,?,?,?,?,?,?);";
                                                                        int res = db.prepare_v2 (savequery,-1,out save);
                                                                        if (res != Sqlite.OK) {
                                                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                                                        }

                                                                        colmn = 1;

                                                                        //saves the completed state, false by default
                                                                        save.bind_text (colmn, "false");
                                                                        colmn = 2;


                                                                        //saves name
                                                                        save.bind_text (colmn, name);
                                                                        colmn = 3;



                                                                        //saves the year of the reminder
                                                                        save.bind_int64 (colmn, rn2.get_year ());
                                                                        colmn = 4;


                                                                        //saves the month of the reminder
                                                                        save.bind_int64 (colmn, rn2.get_month ());
                                                                        colmn = 5;

                                                                        //find the reminders equivalent day in this Week
                                                                        var thatday = then.get_day_of_week ();
                                                                        var thisday = rn2.get_day_of_week ();
                                                                        var rn3 = rn2;
                                                                        //day of reminder
                                                                        var dayofmonth = rn2.get_day_of_month ();



                                                                        while (thatday < thisday) {
                                                                                stdout.printf ("taking a day away \n");
                                                                                rn3 = rn3.add_days (-1);
                                                                                thisday = rn3.get_day_of_week ();
                                                                                dayofmonth = rn3.get_day_of_month ();



                                                                        }
                                                                        while (thatday > thisday) {
                                                                                stdout.printf ("adding a day \n");
                                                                                rn3 = rn3.add_days (1);
                                                                                thisday = rn3.get_day_of_week ();
                                                                                dayofmonth = rn3.get_day_of_month ();

                                                                                //day of reminder


                                                                        }
                                                                        if ( dayofmonth - 7 > today ) {
                                                                                dayofmonth -= 7;
                                                                        }
                                                                        save.bind_int64 (colmn, dayofmonth);
                                                                        colmn = 6;



                                                                        //hour of reminder
                                                                        save.bind_int64 (colmn,countstmt.column_value (5).to_int ());
                                                                        colmn = 7;


                                                                        //and minute of reminder
                                                                        save.bind_int64 (colmn, countstmt.column_value (6).to_int ());
                                                                        colmn = 8;

                                                                        //how important it is. determines the notification level type in the daemon
                                                                        save.bind_int64 (colmn, countstmt.column_value (7).to_int ());
                                                                        colmn = 9;

                                                                        save.bind_text (colmn,description);
                                                                        colmn=10;

                                                                        save.bind_text (colmn, frequency);


                                                                        //save and clear
                                                                        save.step ();
                                                                        save.clear_bindings ();
                                                                        save.reset ();



                                                                        var makecomplete = "UPDATE Reminders SET Complete = 'true' WHERE rowid = ?;";
                                                                        db.prepare_v2 (makecomplete,-1,out makecom);
                                                                        makecom.bind_int64 (1,bv);
                                                                        makecom.step ();
                                                                        makecom.reset ();


                                                                        Sqlite.Statement del;
                                                                        var deletecomplete = "DELETE FROM Reminders WHERE (Complete = 'true');";
                                                                        db.prepare_v2 (deletecomplete,-1,out del);
                                                                        del.step ();
                                                                        del.reset ();
                                                                        break;



                                                                case "Monthly": //monthly reminder
                                                                        Sqlite.Statement makecom;
                                                                        string errmsg;

                                                                        db.exec("VACUUM",null, out errmsg);

                                                                        //here will go the piece of the script that will handle the timing



                                                                        var rn2 = rn.add_months (1);


                                                                        string savequery = "INSERT INTO Reminders (Complete,Name,Year,Month,Day,Hour,Minute,Priority,Description,Timing) VALUES (?,?,?,?,?,?,?,?,?,?);";
                                                                        int res = db.prepare_v2 (savequery,-1,out save);
                                                                        if (res != Sqlite.OK) {
                                                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                                                        }

                                                                        colmn = 1;

                                                                        //saves the completed state, false by default
                                                                        save.bind_text (colmn, "false");
                                                                        colmn = 2;


                                                                        //saves name
                                                                        save.bind_text (colmn, name);
                                                                        colmn = 3;



                                                                        //saves the year of the reminder
                                                                        save.bind_int64 (colmn, rn2.get_year ());
                                                                        colmn = 4;


                                                                        //saves the month of the reminder
                                                                        save.bind_int64 (colmn, rn2.get_month ());
                                                                        colmn = 5;


                                                                        //day of reminder
                                                                        save.bind_int64 (colmn, countstmt.column_value (4).to_int ());
                                                                        colmn = 6;




                                                                        //hour of reminder
                                                                        save.bind_int64 (colmn,countstmt.column_value (5).to_int ());
                                                                        colmn = 7;


                                                                        //and minute of reminder
                                                                        save.bind_int64 (colmn, countstmt.column_value (6).to_int ());
                                                                        colmn = 8;

                                                                        //how important it is. determines the notification level type in the daemon
                                                                        save.bind_int64 (colmn, priority);
                                                                        colmn = 9;

                                                                        save.bind_text (colmn,description);
                                                                        colmn=10;

                                                                        save.bind_text (colmn, frequency);


                                                                        //save and clear
                                                                        save.step ();
                                                                        save.clear_bindings ();
                                                                        save.reset ();



                                                                        var makecomplete = "UPDATE Reminders SET Complete = 'true' WHERE rowid = ?;";
                                                                        db.prepare_v2 (makecomplete,-1,out makecom);
                                                                        makecom.bind_int64 (1,bv);
                                                                        makecom.step ();
                                                                        makecom.reset ();


                                                                        Sqlite.Statement del;
                                                                        var deletecomplete = "DELETE FROM Reminders WHERE (Complete = 'true');";
                                                                        db.prepare_v2 (deletecomplete,-1,out del);
                                                                        del.step ();
                                                                        del.reset ();
                                                                        break;

                                                                case "Yearly": //yearly reminder
                                                                        Sqlite.Statement makecom;
                                                                        string errmsg;

                                                                        db.exec("VACUUM",null, out errmsg);

                                                                        //here will go the piece of the script that will handle the timing





                                                                        var rn2 = rn.add_years (1);


                                                                        string savequery = "INSERT INTO Reminders (Complete,Name,Year,Month,Day,Hour,Minute,Priority,Description,Timing) VALUES (?,?,?,?,?,?,?,?,?,?);";
                                                                        int res = db.prepare_v2 (savequery,-1,out save);
                                                                        if (res != Sqlite.OK) {
                                                                                stderr.printf (_("Error: %d: %s\n"), db.errcode (), db.errmsg ());

                                                                        }

                                                                        colmn = 1;

                                                                        //saves the completed state, false by default
                                                                        save.bind_text (colmn, "false");
                                                                        colmn = 2;


                                                                        //saves name
                                                                        save.bind_text (colmn, name);
                                                                        colmn = 3;



                                                                        //saves the year of the reminder
                                                                        save.bind_int64 (colmn, rn2.get_year ());
                                                                        colmn = 4;


                                                                        //saves the month of the reminder
                                                                        save.bind_int64 (colmn,month);
                                                                        colmn = 5;


                                                                        //day of reminder
                                                                        save.bind_int64 (colmn, day);
                                                                        colmn = 6;


                                                                        //hour of reminder
                                                                        save.bind_int64 (colmn,hour);
                                                                        colmn = 7;


                                                                        //and minute of reminder
                                                                        save.bind_int64 (colmn, min);
                                                                        colmn = 8;

                                                                        //how important it is. determines the notification level type in the daemon
                                                                        save.bind_int64 (colmn, priority);
                                                                        colmn = 9;

                                                                        save.bind_text (colmn,description);
                                                                        colmn=10;

                                                                        save.bind_text (colmn, frequency);


                                                                        //save and clear
                                                                        save.step ();
                                                                        save.clear_bindings ();
                                                                        save.reset ();



                                                                        var makecomplete = "UPDATE Reminders SET Complete = 'true' WHERE rowid = ?;";
                                                                        db.prepare_v2 (makecomplete,-1,out makecom);
                                                                        makecom.bind_int64 (1,bv);
                                                                        makecom.step ();
                                                                        makecom.reset ();


                                                                        Sqlite.Statement del;
                                                                        var deletecomplete = "DELETE FROM Reminders WHERE (Complete = 'true');";
                                                                        db.prepare_v2 (deletecomplete,-1,out del);
                                                                        del.step ();
                                                                        del.reset ();
                                                                        break;
                                                                }
                                                                notification.set_priority (priority);
                                                                notification.set_body (_(description));
                                                                notification.set_title (_(name));
                                                                this.send_notification ("com.github.timecraft.notifier",notification);
                                                        }

                                                }
                                        }
                                }
                        }



                        var countq2 = "SELECT * FROM Reminders WHERE rowid = ?";
                        db.prepare_v2 (countq2,-1, out countstmt);
                        bv++;
                        countstmt.bind_int64 (1,bv);
                }
                bv=0;
                Thread.usleep(60000000);

        }
}


}

//start the daemon
public static int main (string[] args) {
        var app = new NotifierDaemon (); //create instance of notifier daemon

        //try to register app
        try {
                app.register ();
        } catch (Error e) {
                error ("Couldn't register application.");
        }

        //run
        return app.run (args);
}
}
