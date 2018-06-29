project('com.github.timecraft.notifier', ['vala', 'c'],
    version : '1.0.0',
    license: 'GPL-3.0'
)

add_project_arguments([
        '-DGETTEXT_PACKAGE="@0@"'.format(meson.project_name())
    ],
    language: 'c',
)

gnome = import('gnome')
i18n = import('i18n')


conf = configuration_data()
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

c_args = [
  '-include', 'config.h'
]

sources = files()
sources2 = files()

subdir('data')
subdir('src')


dependencies = [
	dependency('gobject-2.0'),
    dependency('glib-2.0'),
    dependency('granite'),
    dependency('gtk+-3.0'),
dependency('sqlite3')
]

e = executable('com.github.timecraft.notifier',
    sources,
    c_args: c_args,
    dependencies: dependencies,
    install : true
)

e2 = executable('com.github.timecraft.notifier-daemon',
sources2,
c_arge: c_args,
dependencies: dependencies,
install: true
)

#test('tests', e, args : ['--run-tests'])

meson.add_install_script('meson/post_install.py')
