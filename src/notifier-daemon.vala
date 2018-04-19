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
while (true){
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
          stdout.printf ("Running...\n");

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

                int prior = countstmt.column_value (7).to_int ();
                var priority = NotificationPriority.LOW;

                //check if it is time for the notification
                if (year <= thisyear) {
                  if (month <= thismonth) {
                    if (day <= today) {
                      if (hour <= thishour) {
                        if (min <= thismin){
                          var notification = new Notification (_(name));
                          switch (prior){
                            case 0: priority = NotificationPriority.LOW; break;
                            case 1: priority = NotificationPriority.NORMAL; break;
                            case 2: priority = NotificationPriority.HIGH; break;
                            case 3: priority = NotificationPriority.URGENT; break;
                          }
                          notification.set_priority (priority);
                          notification.set_body (_(description));
                          this.send_notification ("com.github.Timecraft.Notifier",notification);


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



                            //marks the reminder as 'complete'
                            var makecomplete = "UPDATE Reminders SET Day = ? WHERE rowid = ?;";
                            db.prepare_v2 (makecomplete,-1,out makecom);
                            today++;
                            makecom.bind_int64 (1,today);
                            makecom.bind_int64 (2,bv);
                            makecom.step ();
                            makecom.reset ();

                            //make sure that the year is "this year", otherwise the reminder will be going forever, basically.
                            makecomplete = "UPDATE Reminders SET Year = ? WHERE rowid = ?;";
                            db.prepare_v2 (makecomplete,-1,out makecom);

                            makecom.bind_int64 (1,thisyear);
                            makecom.bind_int64 (2,bv);
                            makecom.step ();
                            makecom.reset ();

                            //similarly with the year thing
                            makecomplete = "UPDATE Reminders SET Month = ? WHERE rowid = ?;";
                            db.prepare_v2 (makecomplete,-1,out makecom);

                            makecom.bind_int64 (1,thismonth);
                            makecom.bind_int64 (2,bv);
                            makecom.step ();
                            makecom.reset ();

                            Sqlite.Statement del;
                            var deletecomplete = "DELETE FROM Reminders WHERE (Complete = 'true');";
                            db.prepare_v2 (deletecomplete,-1,out del);
                            del.step ();
                            del.reset ();
                            break;

                          /*  case "Weekly": //Weekly reminders
                            Sqlite.Statement makecom;
                            string errmsg;

                            db.exec("VACUUM",null, out errmsg);

                            //here will go the piece of the script that will handle the timing



                            //marks the reminder as 'complete'
                            var makecomplete = "UPDATE Reminders SET Day = ? WHERE rowid = ?;";
                            db.prepare_v2 (makecomplete,-1,out makecom);
                            day += 7;

                            makecom.bind_int64 (1,day);
                            makecom.bind_int64 (2,bv);
                            makecom.step ();
                            makecom.reset ();
                            Sqlite.Statement del;
                            var deletecomplete = "DELETE FROM Reminders WHERE (Complete = 'true');";
                            db.prepare_v2 (deletecomplete,-1,out del);
                            del.step ();
                            del.reset ();
                            break;*/


                            case "Monthly": //monthly reminder
                            Sqlite.Statement makecom;
                            string errmsg;

                            db.exec("VACUUM",null, out errmsg);

                            //here will go the piece of the script that will handle the timing



                            //marks the reminder as 'complete'
                            var makecomplete = "UPDATE Reminders SET Month = ? WHERE rowid = ?;";
                            db.prepare_v2 (makecomplete,-1,out makecom);
                            thismonth ++;
                            makecom.bind_int64 (1,month);
                            makecom.bind_int64 (2,bv);
                            makecom.step ();
                            makecom.reset ();

                            makecomplete = "UPDATE Reminders SET Year = ? WHERE rowid = ?;";
                            db.prepare_v2 (makecomplete,-1,out makecom);

                            makecom.bind_int64 (1,thisyear);
                            makecom.bind_int64 (2,bv);
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



                            //marks the reminder as 'complete'
                            var makecomplete = "UPDATE Reminders SET Year = ? WHERE rowid = ?;";
                            db.prepare_v2 (makecomplete,-1,out makecom);
                            thisyear ++;
                            makecom.bind_int64 (1,year);
                            makecom.bind_int64 (2,bv);
                            makecom.step ();
                            makecom.reset ();
                            Sqlite.Statement del;
                            var deletecomplete = "DELETE FROM Reminders WHERE (Complete = 'true');";
                            db.prepare_v2 (deletecomplete,-1,out del);
                            del.step ();
                            del.reset ();
                            break;
                          }

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

}}


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
