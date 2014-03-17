define rbenv::plugin (
  $source,
  $ensure       = 'present',
  $revision     = 'master',
  $plugin_name  = $title,
  $rbenv_root   = $::rbenv::rbenv_root,
) {

  include rbenv

  $plugins_path = "${rbenv_root}/plugins"
  $install_path = "${plugins_path}/${plugin_name}"

  if $source !~ /^(git|https):/ {
    fail("Only git plugins are supported, unable to install from ${source}")
  }

  vcsrepo { $install_path:
    ensure    => $ensure,
    provider  => git,
    source    => $source,
    revision  => $revision,
  }
}
