project('com.github.artemanufrij.regextester', 'vala', 'c', version: '1.1.0')

i18n = import('i18n')
add_global_arguments('-DGETTEXT_PACKAGE="@0@"'.format (meson.project_name()), language:'c')

subdir('src')
subdir('po')
subdir('data')
subdir('schemas')

executable(
    meson.project_name(),
    sources,
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('granite')
    ],
    install: true
)

meson.add_install_script('meson/post_install.py')
