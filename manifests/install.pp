class rbenv::install {

  $rbenv_root         = $::rbenv::rbenv_root
  $ruby_build_root    = "${rbenv_root}/plugins/ruby-build"

  Vcsrepo {
    ensure    => $::rbenv::ensure,
    provider  => git,
  }

  vcsrepo { $rbenv_root:
    revision => $::rbenv::rbenv_version,
    source   => $::rbenv::params::rbenv_source,
  }->
  vcsrepo { $ruby_build_root:
    revision => $::rbenv::ruby_build_version,
    source   => $::rbenv::params::ruby_build_source,
  }

}
