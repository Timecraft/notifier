# Create the executable: List files to compile, dependencies, and install it
executable (
meson.project_name (),
'notifier.vala',
dependencies: [
dependency ('gtk+-3.0'),
dependency ('sqlite3'),
dependency ('granite'),
],
install: true
)

executable (
meson.project_name () + '-daemon',
'notifier-daemon.vala',
dependencies: [
dependency ('gtk+-3.0'),
dependency ('sqlite3')
],
install: true
)
