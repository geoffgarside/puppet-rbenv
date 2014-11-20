define rbenv::user(
  $ensure     = 'present',
  $user       = $name,
  $home       = undef,
  $group      = undef,
  $rbenv_root = undef,
) {

  $_homedir = $user ? {
    'root'  => $::rbenv::params::root_homedir,
    default => "${::rbenv::params::user_homedir}/${user}"
  }

  $_group = $user ? {
    'root'  => '0',
    default => $user,
  }

  $user_group      = pick($group, $_group)
  $user_homedir    = pick($home, $_homedir)
  $user_rbenv_root = pick($rbenv_root, "${user_homedir}/.rbenv")

  $dir_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'directory',
  }

  $file_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'file',
  }

  # Create the users rbenv root directory
  file { $user_rbenv_root:
    ensure  => $dir_ensure,
    owner   => $user,
    group   => $user_group,
    mode    => '0755',
  }

  # Create following dirs
  #  * .rbenv/versions
  file { "${user_rbenv_root}/versions":
    ensure  => $dir_ensure,
    owner   => $user,
    group   => $user_group,
    mode    => '0755',
    purge   => false,
    replace => false,
    require => File[$user_rbenv_root],
  }

  file { "${user_rbenv_root}/version":
    ensure  => $file_ensure,
    content => "system\n",
    owner   => $user,
    group   => $user_group,
    mode    => '0644',
    purge   => false,
    replace => false,
    require => File[$user_rbenv_root],
  }

  file { "${user_rbenv_root}/default-gems":
    ensure  => $file_ensure,
    owner   => $user,
    group   => $user_group,
    source  => "${::rbenv::rbenv_root}/default-gems",
    mode    => '0644',
    replace => false,
    require => File[$user_rbenv_root],
  }

  # Create following dirs, keep in sync
  #  * .rbenv/bin
  #  * .rbenv/completions
  #  * .rbenv/libexec
  #  * .rbenv/plugins
  #  * .rbenv/rbenv.d
  #  * .rbenv/shims
  #  * .rbenv/src
  file { "${user_rbenv_root}/bin":
    ensure  => $dir_ensure,
    owner   => $user,
    group   => $user_group,
    mode    => '0755',
    source  => "${::rbenv::rbenv_root}/bin",
    recurse => true,
    force   => true,
    purge   => true,
    replace => true,
    require => File[$user_rbenv_root],
  }

  file { "${user_rbenv_root}/completions":
    ensure  => $dir_ensure,
    owner   => $user,
    group   => $user_group,
    mode    => '0755',
    source  => "${::rbenv::rbenv_root}/completions",
    recurse => true,
    force   => true,
    purge   => true,
    replace => true,
    require => File[$user_rbenv_root],
  }

  file { "${user_rbenv_root}/libexec":
    ensure  => $dir_ensure,
    owner   => $user,
    group   => $user_group,
    mode    => '0755',
    source  => "${::rbenv::rbenv_root}/libexec",
    recurse => true,
    force   => true,
    purge   => true,
    replace => true,
    require => File[$user_rbenv_root],
  }

  file { "${user_rbenv_root}/plugins":
    ensure  => $dir_ensure,
    owner   => $user,
    group   => $user_group,
    mode    => '0755',
    source  => "${::rbenv::rbenv_root}/plugins",
    recurse => true,
    force   => true,
    purge   => true,
    replace => true,
    require => File[$user_rbenv_root],
  }

  file { "${user_rbenv_root}/rbenv.d":
    ensure  => $dir_ensure,
    owner   => $user,
    group   => $user_group,
    mode    => '0755',
    source  => "${::rbenv::rbenv_root}/rbenv.d",
    recurse => true,
    force   => true,
    purge   => true,
    replace => true,
    require => File[$user_rbenv_root],
  }

  file { "${user_rbenv_root}/shims":
    ensure  => $dir_ensure,
    owner   => $user,
    group   => $user_group,
    mode    => '0755',
    source  => "${::rbenv::rbenv_root}/shims",
    recurse => true,
    force   => true,
    purge   => true,
    replace => true,
    require => File[$user_rbenv_root],
  }

  file { "${user_rbenv_root}/src":
    ensure  => $dir_ensure,
    owner   => $user,
    group   => $user_group,
    mode    => '0755',
    source  => "${::rbenv::rbenv_root}/src",
    recurse => true,
    force   => true,
    purge   => true,
    replace => true,
    require => File[$user_rbenv_root],
  }
}
