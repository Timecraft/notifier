# Notifier

![BuildStatus](https://travis-ci.org/Timecraft/notifier.svg?branch=master)

## A reminders application designed with elementary OS in mind.

#### Author: Timecraft:

#### timemaster23x@gmail.com

### Screenshots
#### Welcome to Notifier.
![NotifierScreenshot](data/images/WelcomeUI.png?raw=true)

#### What does it look like?
![NotifierScreenshot](data/images/MainUI.png?raw=true)

#### Make a new reminder.

![NotifierScreenshot](data/images/NewReminder.png?raw=true)

#### Edit all of the reminders.

![NotifierScreenshot](data/images/EditReminder.png?raw=true)

<br /><br /><br />

### Installation
<br />
<a href="https://appcenter.elementary.io/com.github.timecraft.notifier"><img alt="Get it on the AppCenter" src="https://appcenter.elementary.io/badge.svg"></a>
<br /><br /> <br />

### Building, Testing, and Installation

#### Dependencies:

<li> valac </li>
<li> libgtk-3-dev </li>
<li> libgranite-dev </li>
<li> libsqlite3-dev </li>
<li> elementary-sdk </li>
<li> meson </li>

###### A one liner:

`sudo apt install valac libgtk-3-dev libgranite-dev libsqlite3-dev meson elementary-sdk`

#### Installation

Use `meson` to build <br />

`meson build --prefix=/usr`

Change into `build` directory <br />

`cd build` <br />
`ninja`

Install using `ninja install`, then run with `com.github.timecraft.notifier` or by clicking on it in your launcher. <br />

`sudo ninja install` <br />
`com.github.timecraft.notifier`

#### Debugging

If something is acting funny, or if you just want to see my musings, then execution in the terminal will give you all of that. <br />

`com.github.timecraft.notifier`
