# manage firewall for sonarqube service
class sonarqube::firewall {

  # this class intended to be used from main sonarqube class
  assert_private()

  $manage_firewall = $sonarqube::manage_firewall
  $port            = $sonarqube::port

  if $manage_firewall {
    firewall { '00100 input accept http for sonarqube':
        ensure => 'present',
        action => 'accept',
        chain  => 'INPUT',
        dport  => [$port],
        proto  => 'tcp',
        state  => ['NEW'],
        table  => 'filter',
    }

  }

}