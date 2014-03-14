class rbenv::install {

  vcsrepo { $::rbenv::rbenv_root:
    ensure   => $::rbenv::ensure,
    revision => $::rbenv::rbenv_version,
    source   => $::rbenv::params::rbenv_source,
    provider => git,
  }

  Rbenv::Plugin {
    ensure => $::rbenv::ensure,
  }

  $_real_rbenv_plugins = merge($::rbenv::params::rbenv_plugins, $::rbenv::rbenv_plugins)
  create_resources('rbenv::plugin', $_real_rbenv_plugins)
}
