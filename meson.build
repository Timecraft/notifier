#Name and Language
project ('com.github.timecraft.notifier','vala','c')

#GETTEXT option
i18n = import ('i18n')
gnome = import ('gnome')
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')


subdir ('data')
subdir ('src')
subdir ('po')


meson.add_install_script('meson/post_install.py')
