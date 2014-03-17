define rbenv::install (
  $rbenv_root = $title,
  $global     = $::rbenv::global,
  $ensure     = $::rbenv::ensure,
  $user       = $::rbenv::user,
) {

  vcsrepo { $rbenv_root:
    ensure   => $ensure,
    provider => git,
    revision => $::rbenv::rbenv_version,
    source   => $::rbenv::params::rbenv_source,
    user     => $user,
  }

  $file_ensure = $::rbenv::ensure ? {
    'absent' => 'absent',
    default  => 'file'
  }

  file { "${rbenv_root}/version":
    ensure  => $file_ensure,
    content => "${global}\n",
    owner   => $user,
  }

  Rbenv::Plugin {
    ensure      => $ensure,
    rbenv_root  => $rbenv_root,
    user        => $user,
  }

  $_real_rbenv_plugins = merge($::rbenv::params::rbenv_plugins, $::rbenv::rbenv_plugins)

  create_resources('rbenv::plugin', $_real_rbenv_plugins)
  if has_key($_real_rbenv_plugins, 'rbenv-default-gems') {
    $gem_list = join($::rbenv::default_gems, "\n")

    file { "${rbenv_root}/default-gems":
      ensure  => $file_ensure,
      content => "${gem_list}\n",
      owner   => $user,
    }
  }
}
