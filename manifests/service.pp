# manage sonarqube service
class sonarqube::service {

  # this class intended to be used from main sonarqube class
  assert_private()

  $service = $::sonarqube::service

  service { 'sonarqube':
    ensure     => running,
    name       => $service,
    hasrestart => true,
    hasstatus  => true,
    enable     => true,
  }

}
