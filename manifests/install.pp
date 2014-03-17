define rbenv::install (
  $rbenv_root,
  $ensure = $::rbenv::ensure,
) {

  vcsrepo { $rbenv_root:
    ensure   => $ensure,
    revision => $::rbenv::rbenv_version,
    source   => $::rbenv::params::rbenv_source,
    provider => git,
  }

  Rbenv::Plugin {
    ensure      => $ensure,
    rbenv_root  => $rbenv_root,
  }

  $_real_rbenv_plugins = merge($::rbenv::params::rbenv_plugins, $::rbenv::rbenv_plugins)

  create_resources('rbenv::plugin', $_real_rbenv_plugins)
  if has_key($_real_rbenv_plugins, 'rbenv-default-gems') {
    $gem_list    = join($::rbenv::default_gems, "\n")
    $file_ensure = $::rbenv::ensure ? {
      'absent' => 'absent',
      default  => 'file'
    }

    file { "${rbenv_root}/default-gems":
      ensure  => $file_ensure,
      content => "${gem_list}\n",
    }
  }
}
