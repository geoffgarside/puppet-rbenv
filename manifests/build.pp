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
  $exec_ENV      = concat($rbenv_ENV, [])

  if $ensure == 'absent' {
    exec { "rbenv uninstall ${version}":
      onlyif      => "test -d ${install_path}",
      user        => $::rbenv::user,
      path        => $exec_PATH,
      environment => $exec_ENV,
    }
  } else {

    # Mac OS X requires GCC for Ruby versions 1.9.3-p0 and below
    # NOTE: This requires that the homebrew/dupes repo has been tapped
    if $::osfamily == 'Darwin' {
      if versioncmp($version, "1.9.3-p0") < 1 or $version =~ /^ree/ {
        if ! defined(Package['apple-gcc42']) {
          package { 'apple-gcc42':
            ensure => 'present'
          }
        }

        Package['apple-gcc42'] -> Exec["rbenv install ${version}"]
      }
    }

    exec { "rbenv install ${version}":
      user        => $::rbenv::user,
      path        => $exec_PATH,
      environment => $exec_ENV,
      logoutput   => 'on_failure',
      creates     => $install_path,
      timeout     => 1800,
      require     => Class['rbenv'],
    }
  }
}
