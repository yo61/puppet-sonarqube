# install sonarqube from packages
class sonarqube::install::package {

  # this class intended to be used from sonarqube::install class
  assert_private()

  $arch         = $::sonarqube::arch
  $installdir   = $::sonarqube::installdir
  $package_name = $::sonarqube::package_name
  $version      = $::sonarqube::version

  $arch_dir = "${installdir}/bin/${arch}"
  $sonar_script = "${arch_dir}/sonar.sh"
  $pid_file = "${arch_dir}/SonarQube.pid"

  package { $package_name:
    ensure => $version,
  }
  if $facts['service_provider'] == 'systemd' {
    Package[$package_name] ->
    file{ '/usr/lib/systemd/system/sonar.service':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/sonar.service.erb"),
    }~>
    exec { 'sonar systemd daemon-reload':
      command     => '/bin/systemctl daemon-reload',
      refreshonly => true,
    }
  }

}