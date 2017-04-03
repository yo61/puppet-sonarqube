# install plugin from source
define sonarqube::plugin::source(
  $version,
  $ensure,
  $groupid,
) {

  assert_private()

  $plugin_name = "${name}-${version}.jar"
  $plugin      = "${sonarqube::plugin_dir}/${plugin_name}"
  # Install plugin
  if $ensure == present {
    # copy to a temp file as Maven can run as a different
    # user and not have rights to copy to sonar plugin folder
    maven { "/tmp/${plugin_name}":
      groupid    => $groupid,
      artifactid => $name,
      version    => $version,
      before     => File[$plugin],
      require    => File[$sonarqube::plugin_dir],
    }
    ~> exec { "remove-old-versions-of-${name}":
      command     => "/tmp/cleanup-old-plugin-versions.sh ${sonarqube::plugin_dir} ${name} ${version}",
      path        => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin',
      refreshonly => true,
    }
    -> file { $plugin:
      ensure => $ensure,
      source => "/tmp/${plugin_name}",
      owner  => $sonarqube::user,
      group  => $sonarqube::group,
      notify => Service[$sonarqube::service],
    }
  } else {
    # Uninstall plugin if absent
    file { $plugin:
      ensure => $ensure,
      notify => Service[$sonarqube::service],
    }
  }

}