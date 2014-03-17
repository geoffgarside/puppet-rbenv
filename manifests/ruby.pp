define rbenv::ruby (
  $user,
  $ensure   = 'present',
  $version  = $title,
) {

  include rbenv

  if ! defined(Rbenv::Build[$version]) {
    rbenv::build { $version:
      ensure => $ensure,
    }
  }

  $rbenv_root             = "/home/${user}/.rbenv"
  $rbenv_versions         = "${rbenv_root}/versions"
  $rbenv_shared_versions  = "${::rbenv::rbenv_root}/versions"
  
  $link_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'link'
  }

  rbenv::install { $rbenv_root:
    user => $user,
  }->
  rbenv::config { $user: }->
  file { "${rbenv_versions}/${version}":
    ensure => $link_ensure,
    target => "${rbenv_shared_versions}/${version}",
  }
}
