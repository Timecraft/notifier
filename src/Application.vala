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
        int[] months = {};
        int[] days = {};
        int[] times = {};
        string[] names = {};
        int[] priority = {};
        bool[] complete = {};

        this.app.deletable = true;
        this.app.resizable = true;
        this.app.get_style_context ().add_class ("window-background-color");

        var layout = new Gtk.Grid ();
        layout.set_halign(Gtk.Align.CENTER);
        layout.column_spacing = col;
        layout.row_spacing = spc;
        uint rows=layout.get_row_spacing ();
        var newrembtn = new Gtk.Button.with_label ("New Reminder");

        var saverembtn = new Gtk.Button.with_label ("Save Reminders");

        if (rows<3) {
                layout.attach (new Gtk.Label ("Create a new Notifier!"),1,2,1,1);
        }
        newrembtn.clicked.connect ( ()=>{
                        spc++;
                        var newrem = new Gtk.Window ();
                        newrem.title = "New Reminder";
                        var newremname = new Gtk.Entry ();
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
                        newremgrid.attach (new Gtk.Label ("Hour"),3,1,1,1);
                        newremgrid.attach (new Gtk.Label ("Minute"),4,1,1,1);
                        newremgrid.attach (new Gtk.Label ("Month"),1,1,1,1);
                        newremgrid.attach (new Gtk.Label ("Day"),2,1,1,1);
                        newremgrid.attach (new Gtk.Label ("Priority"),5,0,1,1);
                        newremgrid.attach (newremname,0,2,1,1);
                        newremgrid.attach (newremmonth,1,2,1,1);
                        newremgrid.attach (newremday,2,2,1,1);
                        newremgrid.attach (newremhour,3,2,1,1);
                        newremgrid.attach (newremmin,4,2,1,1);
                        newremgrid.attach (newremprior,5,2,1,1);
                        if (rows==2) {
                                layout.remove_row (2);
                                layout.insert_row (2);
                        }
                        var monthname = new Gtk.Label("January");
                        newremgrid.attach(monthname,1,3,1,1);
                        newremmonth.value_changed.connect( ()=>{
                        switch ( (int) newremmonth.get_value ()){
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

                        }});


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
                                switch (min){
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
                                string time = hour + colon + min;
                                string month = monthname.get_text();
                                string day = newremday.get_value ().to_string();
                                string prior = newremprior.get_value ().to_string ();



                                layout.attach (new Gtk.CheckButton (),0,spc,1,1);
                                layout.attach (new Gtk.Label (newremname.get_text ()),1,spc,1,1);
                                layout.attach (new Gtk.Label (prior),2,spc,1,1);
                                layout.attach (new Gtk.Label (month+" "+day),3,spc,1,1);
                                //layout.attach (new Gtk.Label ();,3,spc,1,1);
                                layout.attach (new Gtk.Label (time),4,spc,1,1);

                                complete += false;
                                months += int.parse (month);
                                days += int.parse (day);
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
                        var file = File.new_for_path (Environment.get_home_dir () + "/.reminders.txt");


                        for (int i=0; i<complete.length; i++) {
                                if (complete[i]==true) {
                                        times[i] -= times[i];
                                        names[i] -= names[i];
                                        priority[i] -= priority[i];
                                        complete[i] = complete[i];
                                        i--;

                                }
                                new DataOutputStream (file.create (FileCreateFlags.NONE)).put_string (complete[i].to_string ()+"\n");


                        }
                });


        layout.attach (newrembtn,0,0,1,1);
        layout.attach (saverembtn,2,0,1,1);
        layout.insert_column (0);
        layout.insert_column (4);

        layout.attach (new Gtk.Label ("Name"),1,1,1,1);
        layout.attach (new Gtk.Label ("Priority"),2,1,1,1);
        layout.attach (new Gtk.Label ("Time\t"),3,1,3,1);

        window.add (layout);

        window.show_all ();

        var quit_action = new SimpleAction ("quit", null);
        quit_action.activate.connect ( () => {


                        var file = File.new_for_path (Environment.get_home_dir () + ("/.reminders.txt"));


                        for (int i=0; i<complete.length; i++) {
                                if (complete[i]==true) {
                                        times[i] -= times[i];
                                        names[i] -= names[i];
                                        priority[i] -= priority[i];
                                        complete[i] = complete[i];

                                        i--;

                                }
                                new DataOutputStream (file.create (FileCreateFlags.NONE)).put_string (complete[i].to_string ()+"\n");

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
