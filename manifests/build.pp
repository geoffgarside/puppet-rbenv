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
  $compile_ENV   = any2array($::rbenv::params::compile_ENV)
  $rbenv_ENV     = any2array($::rbenv::rbenv_ENV)
  $rbenv_PATH    = any2array($::rbenv::rbenv_PATH)

  $exec_path        = concat($rbenv_PATH, $default_PATH)
  $exec_environment = concat($rbenv_ENV, $compile_ENV)

  if $ensure == 'absent' {
    exec { "rbenv uninstall -f ${version}":
      onlyif      => "test -d ${install_path}",
      path        => $exec_path,
      environment => $exec_environment,
    }
  } else {
    exec { "rbenv install ${version}":
      path        => $exec_path,
      environment => $exec_environment,
      logoutput   => 'on_failure',
      creates     => $install_path,
      timeout     => 0,
      require     => [
        Class['rbenv'],
        Class['rbenv::depends']
      ],
    }
  }
}
