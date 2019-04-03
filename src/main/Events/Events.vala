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

using notifier.Widgets, notifier.Vars, notifier.Rems, notifier.main;

namespace notifier.Events {
    public void windowEvents () {
        window.destroy.connect ( () => {
        updateRems ();
    }
}

public void buttonEvents () {

    //New Reminder
    newrembtn.clicked.connect ( () => {
    reminderWindow (true, null);
    }



    //Edit reminder
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

    //Creating the "Reminder" to send to the window
    var userrem = new Reminder (
    //name
    reminderstmt.column_value (1).to_text (),

    //year
    reminderstmt.column_value (2).to_int (),

    //month
    reminderstmt.column_value (3).to_int (),

    //day
    reminderstmt.column_value (4).to_int (),

    //hour
    reminderstmt.column_value (5).to_int (),

    //minute
    reminderstmt.column_value (6).to_int (),

    //priority
    reminderstmt.column_value (7).to_int ();

    //description
    reminderstmt.column_value (8).to_text (),

    //timing
    reminderstmt.column_value (9).to_text (),


    );




    message ("Reminder name = " + reminderstmt.column_value (1).to_text ());
    message ("Reminder hour = " + reminderstmt.column_value (5).to_int ());
    message ("Reminder minute = " + reminderstmt.column_value (6).to_int ());
    message ("Reminder year = " + reminderstmt.column_value (2).to_text ());
    message ("Reminder month = " +reminderstmt.column_value (3).to_text ());
    message ("Reminder day = " + reminderstmt.column_value (4).to_text ());
    message ("Reminder desc = " + reminderstmt.column_value (8).to_text ());
    message ("Reminder timing = " + reminderstmt.column_value (9).to_text ());
    reminderWindow (false, userrem);
    }


   reminderSave.clicked.connect ( () => {

           saveRems ();

   });


   //Window was quit
   quit_action.activate.connect ( () => {

                   if (window != null) {

                           window.destroy ();
                   }
           });

   add_action (quit_action);
   set_accels_for_action ("app.quit", {"<Control>Q",null});








                   string changerowid = "VACUUM;";
                   db.prepare_v2 (changerowid, -1, out chngrowid);
                   chngrowid.step ();
                   chngrowid.reset ();

           });



           //Find editableReminders
           //Selction for editing Reminders
                   editrembtn.clicked.connect ( () => {
                                   editableReminders ();
                                   });
}
}
