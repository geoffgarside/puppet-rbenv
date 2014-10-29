define rbenv::user (
  $user       = $title,
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

  rbenv::install { $user_rbenv_root: user => $user, }->
  rbenv::config { $user: homedir => $user_homedir, }
}
