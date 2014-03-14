define rbenv::build (
  $ensure = 'present',
  $version = $title,
) {

  include stdlib
  include rbenv
  include rbenv::depends

  $versions_path = "${::rbenv::rbenv_root}/versions"
  $install_path  = "${versions_path}/${version}"
  $default_PATH  = ['/bin', '/usr/bin', '/usr/local/bin']
  $compile_ENV   = $::rbenv::params::compile_ENV

  Exec {
    path        => concat($::rbenv::rbenv_PATH, $default_PATH),
    environment => [$::rbenv::rbenv_ENV, $compile_ENV],
  }

  if $ensure == 'absent' {
    exec { "rbenv uninstall -f ${version}":
      onlyif => "test -d ${install_path}",
    }
  } else {
    exec { "rbenv install ${version}":
      creates => $install_path,
      require => Class['rbenv::depends'],
    }
  }
}
