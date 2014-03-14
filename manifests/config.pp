class rbenv::config {

  $_real_rbenv_plugins = merge($::rbenv::params::rbenv_plugins, $::rbenv::rbenv_plugins)
  if has_key($_real_rbenv_plugins, 'rbenv-default-gems') {
    $gem_list = join($::rbenv::default_gems, "\n")
    $file_ensure = case $::rbenv::ensure {
      'absent': { 'absent' }
      default:  { 'file' }
    }

    file { "${::rbenv::rbenv_root}/default-gems":
      ensure  => $file_ensure,
      content => "${gem_list}\n",
    }
  }
}
