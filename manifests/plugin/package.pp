# install plugin from package
define sonarqube::plugin::package(
  $version,
  $ensure,
) {

  assert_private()

  # Install plugin
  if $ensure == present {
    package{ $name:
      ensure => $version,
    }
  } else {
    # Uninstall plugin if absent
    package { $name:
      ensure => $ensure,
    }
  }

}
