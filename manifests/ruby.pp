define rbenv::ruby (
  $user,
  $ensure   = 'present',
  $version  = $title,
  $homedir  = undef,
) {

  include rbenv

  if ! defined(Rbenv::Build[$version]) {
    rbenv::build { $version:
      ensure => $ensure,
    }
  }

  $_homedir = $user ? {
    'root'  => '/root',
    default => "/home/${user}"
  }

  $user_homedir           = pick($homedir, $_homedir)
  $rbenv_root             = "${user_homedir}/.rbenv"
  $rbenv_versions         = "${rbenv_root}/versions"
  $rbenv_shared_versions  = "${::rbenv::rbenv_root}/versions"
  
  $link_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'link'
  }

  rbenv::install { $rbenv_root:
    user => $user,
  }->
  rbenv::config { $user:
    homedir => $user_homedir,
  }->
  file { "${rbenv_versions}/${version}":
    ensure => $link_ensure,
    target => "${rbenv_shared_versions}/${version}",
  }
}
