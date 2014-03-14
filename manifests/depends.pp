class rbenv::depends {
  include stdlib

  ensure_rbenv_dependency(['autoconf', 'automake', 'openssl', 'curl', 'git'])

  case $::osfamily {
    FreeBSD: {
      ensure_rbenv_dependency(['bash', 'gmake', 'libffi', 'libexecinfo'])
    }
    Debian: {
      ensure_rbenv_dependency(['build-essential', 'libtool', 'bison', 'libssl-dev', 'libreadline6', 'libreadline6-dev', 'libc6-dev'])
    }
    default: {
      warn("rbenv::depends not defined for ${::osfamily}, building of rubies may fail")
    }
  }
}
