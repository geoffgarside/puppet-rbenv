define rbenv::ruby (
  $ensure  = 'present',
  $version = $name,
) {
  include rbenv

  if ! defined(Rbenv::Build[$version]) {
    rbenv::build { $version:
      ensure => $ensure,
    }
  }
}
