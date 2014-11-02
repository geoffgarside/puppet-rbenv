define rbenv::ruby (
  $ensure  = 'present',
  $version = $name,
  $user    = undef,
  $home    = undef,
  $group   = undef,
  $global  = false,
) {
  include rbenv

  if ! defined(Rbenv::Build[$version]) {
    rbenv::build { $version:
      ensure => $ensure,
    }
  }

  if $user and $user != 'root' {
    $_homedir = $user ? {
      'root'  => $::rbenv::params::root_homedir,
      default => "${::rbenv::params::user_homedir}/${user}"
    }

    $_group = $user ? {
      'root'  => '0',
      default => $user,
    }

    $user_group      = pick($group, $_group)
    $user_homedir    = pick($home, $_homedir)
    $user_rbenv_root = "${user_homedir}/.rbenv"

    if ! defined(Rbenv::User[$user]) {
      rbenv::user { $user:
        ensure     => $ensure,
        group      => $user_group,
        home       => $user_homedir,
        rbenv_root => $user_rbenv_root,
        require    => Rbenv::Build[$version],
      }
    }

    $link_ensure = $ensure ? {
      'absent' => 'absent',
      default  => 'link',
    }

    file { "${user_rbenv_root}/versions/${version}":
      ensure => $link_ensure,
      target => "${::rbenv::rbenv_root}/versions/${version}",
      owner  => $user,
      group  => $user_group,
      require => [
        Rbenv::Build[$version],
        Rbenv::User[$user],
      ]
    }

    if $global {
      $file_ensure = $ensure ? {
        'absent' => 'absent',
        default  => 'file',
      }

      file { "${user_rbenv_root}/version":
        ensure  => $file_ensure,
        content => "${version}\n",
        owner   => $user,
        group   => $user_group,
        mode    => '0644',
        require => File["${user_rbenv_root}/versions/${version}"],
      }
    }
  }
}
