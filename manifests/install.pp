class rbenv::install {
  case $::rbenv::ensure {
    'absent': {
      $file_ensure = 'absent'
      $dir_ensure  = 'absent'
    }
    default: {
      $file_ensure = 'file'
      $dir_ensure  = 'directory'
    }
  }

  $user          = $::rbenv::user
  $owner         = $::rbenv::owner
  $group         = $::rbenv::group
  $rbenv_root    = $::rbenv::rbenv_root
  $rbenv_source  = $::rbenv::params::rbenv_source
  $rbenv_version = $::rbenv::rbenv_version

  vcsrepo { $rbenv_root:
    ensure   => $::rbenv::ensure,
    provider => 'git',
    revision => $rbenv_version,
    source   => $rbenv_source,
    user     => $user,
    owner    => $owner,
    group    => $group,
  }

  file { [
    "${rbenv_root}/shims",
    "${rbenv_root}/plugins",
    "${rbenv_root}/versions",
    ]:
    ensure  => $dir_ensure,
    mode    => '0755',
    owner   => $owner,
    group   => $group,
    require => Vcsrepo[$rbenv_root],
  }

  Rbenv::Plugin {
    ensure      => $ensure,
    rbenv_root  => $rbenv_root,
    user        => $user,
    require     => Vcsrepo[$rbenv_root],
  }

  $_real_rbenv_plugins = merge($::rbenv::params::rbenv_plugins, $::rbenv::rbenv_plugins)
  $_user_rbenv_plugins = rbenv_suffix_keys($_real_rbenv_plugins, " ${user}")

  create_resources('rbenv::plugin', $_user_rbenv_plugins)
}
