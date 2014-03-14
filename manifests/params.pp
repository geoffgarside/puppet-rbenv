class rbenv::params {

  $global             = 'system'

  $rbenv_root         = '/usr/local/rbenv'
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
    }
  }
}
