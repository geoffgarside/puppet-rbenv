class rbenv::params {

  $user               = 'root'
  $owner              = 'root'
  $group              = '0'

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
      $root_homedir = '/root'
      $user_homedir = '/usr/home'
    }
    Darwin: {
      $root_homedir = '/var/root'
      $user_homedir = '/Users'
    }
    default: {
      $root_homedir = '/root'
      $user_homedir = '/home'
    }
  }
}
