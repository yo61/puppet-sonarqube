# sonarqube configuration
class sonarqube::config {

  # this class intended to be used from main sonarqube class
  assert_private()

  $config           = $::sonarqube::config
  $context_path     = $::sonarqube::context_path
  $crowd            = $::sonarqube::crowd
  $host             = $::sonarqube::host
  $http_proxy       = $::sonarqube::http_proxy
  $https            = $::sonarqube::https
  $installdir       = $::sonarqube::installdir
  $jdbc             = $::sonarqube::jdbc
  $ldap             = $::sonarqube::ldap
  $pam              = $::sonarqube::pam
  $port_ajp         = $::sonarqube::port_ajp
  $port             = $::sonarqube::port
  $search_host      = $::sonarqube::search_host
  $search_java_opts = $::sonarqube::search_java_opts
  $search_port      = $::sonarqube::search_port
  $updatecenter     = $::sonarqube::updatecenter
  $web_java_opts    = $::sonarqube::web_java_opts

  # Sonar configuration files
  if $config != undef {
    file { "${installdir}/conf/sonar.properties":
      source => $config,
      mode   => '0600',
    }
  } else {
    file { "${installdir}/conf/sonar.properties":
      content => template('sonarqube/sonar.properties.erb'),
      mode    => '0600',
    }
  }

}
