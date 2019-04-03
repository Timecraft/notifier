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


                        //Gtk.Grid.attach (widget,column,row,rows taken, columns taken)


}
}
}



public static int main (string [] args ) {
        var app = new notifier.main.notifier ();
        return app.run (args);
}
