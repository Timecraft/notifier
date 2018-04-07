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
        window.title="Notifier";









        var col = 4;
        var spc= 2;
        int[] times = {};
        string[] names = {};
        int[] priority = {};
        bool[] complete = {};





        this.app.deletable = true;
        this.app.resizable = true;
        this.app.get_style_context ().add_class (_("window-background-color")_);

        var layout = new Gtk.Grid ();
        layout.column_spacing = col;
        layout.row_spacing = spc;
        uint rows=layout.get_row_spacing ();
        var newrembtn = new Gtk.Button.with_label (_("New Reminder")_);

        var saverembtn = new Gtk.Button.with_label (_("Save Reminders")_);

        if (rows<3) {
                layout.attach (new Gtk.Label (_("Create a new Notifier!")_),1,2,1,1);
        }
        newrembtn.clicked.connect ( ()=>{
                        spc++;
                        var newrem = new Gtk.Window ();
                        newrem.title (_("New Reminder")_)
                        var newremname = new Gtk.Entry ();
                        var newremhour = new Gtk.SpinButton.with_range (0,23,1);
                        var newremmin = new Gtk.SpinButton.with_range (0,60,5);
                        var newremprior = new Gtk.SpinButton.with_range (0,3,1);
                        var newremcanc = new Gtk.Button.with_label (_("Cancel")_);
                        var newremsave = new Gtk.Button.with_label (_("Save")_);
                        var newremgrid = new Gtk.Grid ();
                        newremgrid.attach (new Gtk.Label (_("Reminder Name")_),0,0,1,1);
                        newremgrid.attach (new Gtk.Label (_("Remind Time")_),1,0,2,1);
                        newremgrid.attach (new Gtk.Label (_("Hour")_),1,1,1,1);
                        newremgrid.attach (new Gtk.Label (_("Minute")_),2,1,1,1);
                        newremgrid.attach (new Gtk.Label (_("Priority")_),3,0,1,1);
                        newremgrid.attach (newremname,0,2,1,1);
                        newremgrid.attach (newremhour,1,2,1,1);
                        newremgrid.attach (newremmin,2,2,1,1);
                        newremgrid.attach (newremprior,3,2,1,1);
                        if (rows==2) {
                                layout.remove_row (2);
                                layout.insert_row (2);
                        }


                        newremgrid.attach (newremsave,3,3,1,1);
                        newremgrid.attach (newremcanc,0,3,1,1);
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
                                if (min=="0") {
                                        min="00";
                                }
                                string time = hour + colon + min;

                                string prior = newremprior.get_value ().to_string ();



                                layout.attach (new Gtk.CheckButton (),0,spc,1,1);
                                layout.attach (new Gtk.Label (newremname.get_text ()),1,spc,1,1);
                                layout.attach (new Gtk.Label (prior),2,spc,1,1);
                                layout.attach (new Gtk.Label (time),3,spc,1,1);

                                complete += false;
                                names += newremname.get_text ();
                                times += int.parse (time);
                                priority += int.parse (prior);
                                //save reminders to a file for reload reference





                                newrem.destroy ();

                                window.show_all ();

                        });
                        //Gtk.Grid.attatch (widget,column,row,columns taken, rows taken)


                });
        saverembtn.clicked.connect ( ()=>{
                        var file = File.new_for_path (Environment.get_home_dir () + "/.reminders.txt")_);


                        for (int i=0; i<complete.length; i++) {
                                if (complete[i]==true) {
                                        times[i] -= times[i];
                                        names[i] -= names[i];
                                        priority[i] -= priority[i];
                                        complete[i] = complete[i];
                                        i--;

                                }
                                new DataOutputStream (file.create (FileCreateFlags.NONE)).put_string (complete[i].to_string ()+"\n")_);


                        }
                });


        layout.attach (newrembtn,0,0,1,1);
        layout.attach (saverembtn,2,0,1,1);
        layout.insert_column (0);
        layout.insert_column (4);

        layout.attach (new Gtk.Label (_("Name")_),1,1,1,1);
        layout.attach (new Gtk.Label (_("Priority")_),2,1,1,1);
        layout.attach (new Gtk.Label (_("Time\t")_),3,1,2,1);

        window.add (layout);

        window.show_all ();

        var quit_action = new SimpleAction ("quit", null);
        quit_action.activate.connect ( () => {


                        var file = File.new_for_path (Environment.get_home_dir () + "/.reminders.txt")_);


                        for (int i=0; i<complete.length; i++) {
                                if (complete[i]==true) {
                                        times[i] -= times[i];
                                        names[i] -= names[i];
                                        priority[i] -= priority[i];
                                        complete[i] = complete[i];

                                        i--;

                                }
                                new DataOutputStream (file.create (FileCreateFlags.NONE)).put_string (complete[i].to_string ()+"\n")_);

                        }




                        if (window != null) {


                                window.destroy ();
                        }
                });

        add_action (quit_action);
        set_accels_for_action ("app.quit",{"<Control>Q",null});
}
public static int main (string [] args ){
        var app = new notifier ();
        return app.run (args);
}
}
