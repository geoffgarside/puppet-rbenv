define rbenv::config (
  $user    = $title,
  $homedir = undef,
) {
  $file_ensure = $::rbenv::ensure ? {
    'absent' => 'absent',
    default  => 'file'
  }

  $_homedir = $user ? {
    'root'  => '/root',
    default => "/home/${user}"
  }

  $user_homedir = pick($homedir, $_homedir)

  file { "${user_homedir}/.rbenv-profile.sh":
    ensure  => $file_ensure,
    owner   => $user,
    mode    => '0755',
    content => template('rbenv/rbenv-profile.sh.erb'),
  }

  $rbenv_profile = '$HOME/.rbenv-profile.sh'

  Exec {
    path => ['/bin', '/usr/bin', '/usr/local/bin'],
  }

  exec { "echo 'source ${rbenv_profile}' >> ${user_homedir}/.cshrc":
    unless => "grep '${rbenv_profile}' ${user_homedir}/.cshrc",
    onlyif => "test -f ${user_homedir}/.cshrc",
  }

  exec { "echo '. ${rbenv_profile}' >> ${user_homedir}/.profile":
    unless => "grep '${rbenv_profile}' ${user_homedir}/.profile",
    onlyif => "test -f ${user_homedir}/.profile",
  }

  exec { "echo '. ${rbenv_profile}' >> ${user_homedir}/.bashrc":
    unless => "grep '${rbenv_profile}' ${user_homedir}/.bashrc",
    onlyif => "test -f ${user_homedir}/.bashrc",
  }
}
