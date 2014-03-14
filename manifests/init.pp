class rbenv (
  $ensure        = 'present',
  $global        = $::rbenv::params::global,
  $rbenv_root    = $::rbenv::params::rbenv_root,
  $rbenv_version = $::rbenv::params::rbenv_version,
  $rbenv_plugins = $::rbenv::params::rbenv_plugins,
  $default_gems  = $::rbenv::params::default_gems,
) inherits rbenv::params {

  $rbenv_bin    = "${rbenv_root}/bin"
  $rbenv_shims  = "${rbenv_root}/shims"
  $rbenv_PATH   = [ $rbenv_bin, $rbenv_shims ]
  $rbenv_ENV    = "RBENV_ROOT=${rbenv_root}"

  class { '::rbenv::install': }->
  class { '::rbenv::config': }->
  Class['rbenv']

}
