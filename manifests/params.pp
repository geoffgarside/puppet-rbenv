class rbenv::params {

  $global             = 'system'

  $rbenv_root         = '/usr/local/rbenv'
  $rbenv_version      = 'master'
  $rbenv_source       = 'https://github.com/sstephenson/rbenv.git'

  $rbenv_plugins      = {
    'ruby-build' => {
      'revision' => 'master',
      'source'   => 'https://github.com/sstephenson/ruby-build.git'
    },
  }
}
