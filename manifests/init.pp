class rbenv (
  $ensure             = 'present',
  $global             = $::rbenv::params::global,
  $rbenv_root         = $::rbenv::params::rbenv_root,
  $rbenv_version      = $::rbenv::params::rbenv_version,
  $ruby_build_version = $::rbenv::praams::ruby_build_version,
) {

  include rbenv::params

  $rbenv_bin    = "${rbenv_root}/bin"
  $rbenv_shims  = "${rbenv_root}/shims"
  $rbenv_PATH   = [ $rbenv_bin, $rbenv_shims ]
  $rbenv_ENV    = "RBENV_ROOT=${rbenv_root}"

  class { '::rbenv::install': }->
  Class['rbenv']

}
