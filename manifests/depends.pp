class rbenv::depends {
  include stdlib

  ensure_packages(['autoconf', 'automake', 'openssl', 'git', 'curl'])

  case $::osfamily {
    FreeBSD: {
      ensure_packages(['bash', 'gmake', 'libffi', 'libexecinfo'])
    }
    Debian: {
      ensure_packages(['build-essential', 'libtool', 'bison', 'libssl-dev', 'libreadline6', 'libreadline6-dev', 'libc6-dev'])
    }
    default: {
      warn("rbenv::depends not defined for ${::osfamily}, building of rubies may fail")
    }
  }
}
