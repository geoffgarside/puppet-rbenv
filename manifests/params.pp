class rbenv::params {

  $global             = 'system'

  $rbenv_root         = '/usr/local/share/rbenv'
  $rbenv_version      = 'master'
  $rbenv_source       = 'https://github.com/sstephenson/rbenv.git'

  $default_gems       = ['bundler ~>1.7.4']
  $rbenv_plugins      = {
    'ruby-build' => {
      'plugin_name' => 'ruby-build',
      'revision'    => 'master',
      'source'      => 'https://github.com/sstephenson/ruby-build.git'
    },
    'rbenv-gem-rehash' => {
      'plugin_name' => 'rbenv-gem-rehash',
      'revision'    => 'master',
      'source'      => 'https://github.com/sstephenson/rbenv-gem-rehash.git'
    },
    'rbenv-default-gems' => {
      'plugin_name' => 'rbenv-default-gems',
      'revision'    => 'master',
      'source'      => 'https://github.com/sstephenson/rbenv-default-gems.git'
    },
    'bundler' => {
      'plugin_name' => 'bundler',
      'revision'    => 'master',
      'source'      => 'https://github.com/carsomyr/rbenv-bundler.git'
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

      $homedir          = '/usr/home'
      $has_cshrc        = true
      $has_profile      = true
      $has_bash_profile = true
    }
    Darwin: {
      $compile_ENV      = ['MAKE=make', 'LDFLAGS=-L/usr/local/opt/openssl/lib','CPPFLAGS=-I/usr/local/opt/openssl/include']
      $homedir          = '/Users'
      $has_cshrc        = false
      $has_profile      = false
      $has_bash_profile = false
    }
    default: {
      $compile_ENV      = 'MAKE=make'
      $homedir          = '/home'
      $has_cshrc        = false
      $has_profile      = false
      $has_bash_profile = false
    }
  }
}
