class rbenv (
  $ensure        = 'present',
  $user          = 'root',
  $global        = $::rbenv::params::global,
  $rbenv_root    = $::rbenv::params::rbenv_root,
  $rbenv_version = $::rbenv::params::rbenv_version,
  $rbenv_plugins = $::rbenv::params::rbenv_plugins,
  $default_gems  = $::rbenv::params::default_gems,
) inherits rbenv::params {

  $rbenv_bin    = "${rbenv_root}/bin"
  $rbenv_shims  = "${rbenv_root}/shims"
  $rbenv_PATH   = [ $rbenv_shims, $rbenv_bin ]
  $rbenv_ENV    = ["RBENV_ROOT=${rbenv_root}"]

  rbenv::user { $user:
    rbenv_root => $rbenv_root,
  }
}
