define rbenv::config (
  $user    = $title,
  $homedir = undef,
) {

  $_homedir = $user ? {
    'root'  => '/root',
    default => "/home/${user}"
  }

  $user_homedir = pick($homedir, $_homedir)
  $rbenv_root = $user ? {
    'root'  => $::rbenv::rbenv_root,
    default => "${user_homedir}/.rbenv"
  }

  file { "${user_homedir}/.rbenv-profile.sh":
    ensure  => 'absent',
    owner   => $user,
    mode    => '0755',
    content => template('rbenv/rbenv-profile.sh.erb'),
  }

  file_line { "${user_homedir}/.cshrc RBENV PATH":
    ensure  => $::rbenv::ensure,
    path    => "${user_homedir}/.cshrc",
    line    => "set path = (${rbenv_root}/shims ${rbenv_root}/bin \$path)",
  }

  file_line { "${user_homedir}/.profile RBENV PATH":
    ensure  => $::rbenv::ensure,
    path    => "${user_homedir}/.profile",
    line    => "export PATH=${rbenv_root}/shims:${rbenv_root}/bin:\$PATH",
  }

  file_line { "${user_homedir}/.bash_profile RBENV PATH":
    ensure  => $::rbenv::ensure,
    path    => "${user_homedir}/.bash_profile",
    line    => "export PATH=${rbenv_root}/shims:${rbenv_root}/bin:\$PATH",
  }

  # If we don't have a .rbenv then set RBENV_ROOT
  if $rbenv_root == $::rbenv::rbenv_root {
    file_line { "${user_homedir}/.cshrc RBENV_ROOT":
      ensure  => $::rbenv::ensure,
      path    => "${user_homedir}/.cshrc",
      line    => "setenv RBENV_ROOT ${rbenv_root}",
    }
    
    file_line { "${user_homedir}/.profile RBENV_ROOT":
      ensure  => $::rbenv::ensure,
      path    => "${user_homedir}/.profile",
      line    => "export RBENV_ROOT=${rbenv_root}",
    }

    file_line { "${user_homedir}/.bash_profile RBENV_ROOT":
      ensure  => $::rbenv::ensure,
      path    => "${user_homedir}/.bash_profile",
      line    => "export RBENV_ROOT=${rbenv_root}",
    }
  }
}
