define rbenv::ruby (
  $user,
  $ensure  = 'present',
  $version = $title,
) {

  include rbenv

  if ! defined(Rbenv::Build[$version]) {
    rbenv::build { $version:
      ensure => 'present',
    }
  }
}
