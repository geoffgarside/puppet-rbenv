define rbenv::config (
  $user = $title
) {
  $file_ensure = $::rbenv::ensure ? {
    'absent' => 'absent',
    default  => 'file'
  }

  file { "/home/${user}/.rbenv-profile.sh":
    ensure  => $file_ensure,
    owner   => $user,
    mode    => '0755',
    content => template('rbenv/rbenv-profile.sh.erb'),
  }

  $rbenv_profile_source = '. $HOME/.rbenv-profile.sh'

  Exec {
    path => ['/bin', '/usr/bin', '/usr/local/bin'],
  }

  exec { "echo '${rbenv_profile_source}' >> ~${user}/.cshrc":
    unless => "grep '${rbenv_profile_source}' ~${user}/.cshrc",
    onlyif => "test -f ~${user}/.cshrc",
  }

  exec { "echo '${rbenv_profile_source}' >> ~${user}/.profile":
    unless => "grep '${rbenv_profile_source}' ~${user}/.profile",
    onlyif => "test -f ~${user}/.profile",
  }
  
  exec { "echo '${rbenv_profile_source}' >> ~${user}/.bashrc":
    unless => "grep '${rbenv_profile_source}' ~${user}/.bashrc",
    onlyif => "test -f ~${user}/.bashrc",
  }
}
