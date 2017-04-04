# install sonarqube
class sonarqube::install {

  # this class intended to be used from main sonarqube class
  assert_private()

  if $::sonarqube::use_packages {
    contain ::sonarqube::install::package
  }
  else {
    contain ::sonarqube::install::source
  }

}
