class rbenv (
  $ensure             = 'present',
  $global             = $::rbenv::params::global,
  $rbenv_root         = $::rbenv::params::rbenv_root,
  $rbenv_version      = $::rbenv::params::rbenv_version,
  $ruby_build_version = $::rbenv::praams::ruby_build_version,
) {

  include rbenv::params

  class { '::rbenv::install': }->
  Class['rbenv']

}
