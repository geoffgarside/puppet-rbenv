define rbenv::install (
  $rbenv_root = $title,
  $global     = $::rbenv::global,
  $ensure     = $::rbenv::ensure,
  $user       = $::rbenv::user,
) {

  $file_ensure = $::rbenv::ensure ? {
    'absent' => 'absent',
    default  => 'file'
  }

  $dir_ensure = $::rbenv::ensure ? {
    'absent' => 'absent',
    default  => 'directory'
  }

  vcsrepo { $rbenv_root:
    ensure   => $ensure,
    provider => git,
    revision => $::rbenv::rbenv_version,
    source   => $::rbenv::params::rbenv_source,
    user     => $user,
  }->
  file { "${rbenv_root}/version":
    ensure  => $file_ensure,
    content => "${global}\n",
    owner   => $user,
  }->
  file { "${rbenv_root}/versions":
    ensure => $dir_ensure,
    owner  => $user,
    mode   => '0755',
  }->
  Rbenv::Plugin {
    ensure      => $ensure,
    rbenv_root  => $rbenv_root,
    user        => $user,
  }

  $_real_rbenv_plugins = merge($::rbenv::params::rbenv_plugins, $::rbenv::rbenv_plugins)
  $_user_rbenv_plugins = rbenv_suffix_keys($_real_rbenv_plugins, " ${user}")

  create_resources('rbenv::plugin', $_user_rbenv_plugins)
  if has_key($_real_rbenv_plugins, 'rbenv-default-gems') {
    $gem_list = join($::rbenv::default_gems, "\n")

    file { "${rbenv_root}/default-gems":
      ensure  => $file_ensure,
      content => "${gem_list}\n",
      owner   => $user,
      require => Vcsrepo[$rbenv_root],
    }
  }
}
