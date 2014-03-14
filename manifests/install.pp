class rbenv::install {

  $rbenv_root         = $::rbenv::rbenv_root

  vcsrepo { $rbenv_root:
    ensure   => $::rbenv::ensure,
    revision => $::rbenv::rbenv_version,
    source   => $::rbenv::params::rbenv_source,
    provider => git,
  }->
  rbenv::plugin { 'ruby-build':
    ensure   => $::rbenv::ensure,
    revision => $::rbenv::ruby_build_version,
    source   => $::rbenv::params::ruby_build_source,
  }

}
