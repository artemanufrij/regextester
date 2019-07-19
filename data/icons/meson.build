icon_sizes = ['32', '48', '64']

foreach i : icon_sizes
  install_data(
    join_paths(i, meson.project_name() + '.svg'),
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i, 'apps')
  )
  install_data(
    join_paths(i, meson.project_name() + '.svg'),
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', i + 'x' + i + '@2', 'apps')
  )
endforeach

install_data(
    'regex-match-first.svg',
    install_dir: join_paths(get_option('datadir'), meson.project_name(), 'icons')
)

install_data(
    'regex-match-second.svg',
    install_dir: join_paths(get_option('datadir'), meson.project_name(), 'icons')
)
