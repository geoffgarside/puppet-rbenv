define rbenv::ruby (
  $user,
  $version,
  $ensure     = 'present',
  $home       = undef,
  $rbenv_root = undef,
) {

  include rbenv

  $_homedir = $user ? {
    'root'  => '/root',
    default => "${::rbenv::params::homedir}/${user}"
  }

  $user_homedir           = pick($home, $_homedir)
  $user_rbenv_root        = pick($rbenv_root, "${user_homedir}/.rbenv")
  $user_rbenv_versions    = "${user_rbenv_root}/versions"
  $rbenv_shared_versions  = "${::rbenv::rbenv_root}/versions"

  $link_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'link'
  }

  if ! defined(Rbenv::Build[$version]) {
    rbenv::build { $version:
      ensure => $ensure,
    }
  }

  if ! defined(Rbenv::User[$user]) {
    rbenv::user { $user:
      ensure      => $ensure,
      home        => $user_homedir,
      rbenv_root  => $user_rbenv_root,
      require     => Rbenv::Build[$version],
    }
  }

  file { "${user_rbenv_versions}/${version}":
    ensure  => $link_ensure,
    target  => "${rbenv_shared_versions}/${version}",
    require => [
      Rbenv::Build[$version],
      Rbenv::User[$user],
    ]
  }
}
