define rbenv::ruby (
  $user,
  $version = $title
) {

  include rbenv

  if ! defined(Rbenv::Build[$version]) {
    rbenv::build { $version:
      ensure => 'present',
    }
  }
}
