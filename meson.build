#Name and Language
project ('com.github.timecraft.notifier','vala','c')

#GETTEXT option
i18n = import ('i18n')
gnome = import ('gnome')
add_global_arguments('-DGETTEXT_PACKAGE="com.github.timecraft.notifier"', language:'c')

# Create the executable: List files to compile, dependencies, and install it
executable (
meson.project_name (),
'src/notifier.vala',
dependencies: [
dependency ('gtk+-3.0'),
dependency ('sqlite3'),
dependency ('granite'),
],
install: true
)

executable (
meson.project_name () + '-daemon',
'src/notifier-daemon.vala',
dependencies: [
dependency ('gtk+-3.0'),
dependency ('sqlite3')
],
install: true
)

#Translate and install our .desktop file
i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.desktop.in'),
    output: meson.project_name() + '.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: join_paths(get_option('datadir'), 'applications')
)

#Translate and install our .desktop file
i18n.merge_file(
    input: join_paths('data', meson.project_name() + '-daemon.desktop.in'),
    output: meson.project_name() + '-daemon.desktop',
    po_dir: join_paths(meson.source_root(), 'po'),
    type: 'desktop',
    install: true,
    install_dir: '/etc/xdg/autostart/'
)



#Install .appdata.xml for AppCenter

i18n.merge_file(
    input: join_paths('data', meson.project_name() + '.appdata.xml.in'),
    output: meson.project_name() + '.appdata.xml',
    po_dir: join_paths(meson.source_root(), 'po'),
    install: true,
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

subdir ('po')


meson.add_install_script('meson/post_install.py')
