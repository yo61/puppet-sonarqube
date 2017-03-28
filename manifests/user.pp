# manage the sonar user, if required
class sonarqube::user {

  # this class intended to be used from sonarqube::install class
  assert_private()

  $group        = $::sonarqube::group
  $manage_user  = $::sonarqube::manage_user
  $real_home    = $::sonarqube::real_home
  $user         = $::sonarqube::user
  $user_system  = $::sonarqube::user_system

  if $manage_user {
    user { $user:
      ensure     => present,
      home       => $real_home,
      managehome => false,
      system     => $user_system,
    }
    ->
    group { $group:
      ensure => present,
      system => $user_system,
    }
  }

}
