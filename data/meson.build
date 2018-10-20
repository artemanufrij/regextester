icon_sizes = ['32', '48', '64']

foreach i : icon_sizes
  install_data(
    join_paths('icons', i, meson.project_name() + '.svg'),
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
  )
  install_data(
    join_paths('icons', i, meson.project_name() + '.svg'),
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps')
  )
endforeach

install_data(
    meson.project_name() + '.desktop',
    install_dir: join_paths(get_option('datadir'), 'applications')
)

install_data(
    meson.project_name() + '.appdata.xml',
    install_dir: join_paths(get_option('datadir'), 'metainfo')
)

prefix = get_option('prefix')
datadir = join_paths(prefix, get_option('datadir'))
pkgdatadir = join_paths(datadir, meson.project_name())

install_data(
  join_paths ('icons', 'regex_match_first.svg'),
  install_dir: join_paths (pkgdatadir, 'icons')
)

install_data(
  join_paths ('icons', 'regex_match_second.svg'),
  install_dir: join_paths (pkgdatadir, 'icons')
)