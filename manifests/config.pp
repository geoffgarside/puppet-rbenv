class rbenv::config {
  require stdlib

  case $::rbenv::ensure {
    'absent': {
      $file_ensure = 'absent'
    }
    default: {
      $file_ensure = 'file'
    }
  }

  $owner      = $::rbenv::owner
  $group      = $::rbenv::group
  $global     = $::rbenv::global
  $rbenv_root = $::rbenv::rbenv_root

  file { "${rbenv_root}/version":
    ensure  => $file_ensure,
    content => "${global}\n",
    owner   => $owner,
    group   => $group,
    mode    => '0644',
  }

  $_real_rbenv_plugins = merge($::rbenv::params::rbenv_plugins, $::rbenv::rbenv_plugins)
  if has_key($_real_rbenv_plugins, 'rbenv-default-gems') {
    $gem_list = join($::rbenv::default_gems, "\n")

    file { "${rbenv_root}/default-gems":
      ensure  => $file_ensure,
      content => "${gem_list}\n",
      owner   => $owner,
      group   => $group,
      require => Vcsrepo[$rbenv_root],
    }
  }
}
