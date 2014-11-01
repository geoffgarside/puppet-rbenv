define rbenv::build (
  $ensure  = 'present',
  $version = $name,
) {
  include stdlib
  include rbenv

  $versions_path = "${::rbenv::rbenv_root}/versions"
  $install_path  = "${versions_path}/${version}"
  $default_PATH  = ['/bin', '/usr/bin', '/usr/local/bin']
  $rbenv_PATH    = any2array($::rbenv::rbenv_PATH)
  $rbenv_ENV     = any2array($::rbenv::rbenv_ENV)
  $exec_PATH     = concat($rbenv_PATH, $default_PATH)
  $exec_ENV      = concat($rbenv_ENV, $compile_ENV)

  if $ensure == 'absent' {
    exec { "rbenv uninstall ${version}":
      onlyif      => "test -d ${install_path}",
      path        => $exec_PATH,
      environment => $exec_ENV,
    }
  } else {
    exec { "rbenv install ${version}":
      path        => $exec_PATH,
      environment => $exec_ENV,
      logoutput   => 'on_failure',
      creates     => $install_path,
      timeout     => 1800,
      require     => Class['rbenv'],
    }
  }
}
