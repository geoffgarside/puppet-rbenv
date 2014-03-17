class rbenv::params {

  $global             = 'system'

  $rbenv_root         = '/usr/local/share/rbenv'
  $rbenv_version      = 'master'
  $rbenv_source       = 'https://github.com/sstephenson/rbenv.git'

  $default_gems       = ['bundler ~>1.5.1']
  $rbenv_plugins      = {
    'ruby-build' => {
      'revision' => 'master',
      'source'   => 'https://github.com/sstephenson/ruby-build.git'
    },
    'rbenv-gem-rehash' => {
      'revision' => 'master',
      'source'   => 'https://github.com/sstephenson/rbenv-gem-rehash.git'
    },
    'rbenv-default-gems' => {
      'revision' => 'master',
      'source'   => 'https://github.com/sstephenson/rbenv-default-gems.git'
    },
    'bundler' => {
      'revision' => 'master',
      'source'   => 'https://github.com/carsomyr/rbenv-bundler.git'
    }  
  }

  case $::osfamily {
    FreeBSD: {
      # ruby-build will do this itself, but FreeBSD 10 is an exception
      # so we'll give it a helping hand here.
      if versioncmp($::kernelversion, "10.0") >= 0 {
        $compile_ENV = 'MAKE=make'
      } else {
        $compile_ENV = 'MAKE=gmake'
      }
    }
    default: {
      $compile_ENV = 'MAKE=make'
    }
  }
}
