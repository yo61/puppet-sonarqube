# install sonarqube from source
class sonarqube::install::source {

  # this class intended to be used from sonarqube::install class
  assert_private()

  $arch           = $::sonarqube::arch
  $config         = $::sonarqube::config
  $download_dir   = $::sonarqube::download_dir
  $download_url   = $::sonarqube::download_url
  $extensions_dir = $::sonarqube::extensions_dir
  $group          = $::sonarqube::group
  $installdir     = $::sonarqube::installdir
  $installroot    = $::sonarqube::installroot
  $package_name   = $::sonarqube::package_name
  $plugin_dir     = $::sonarqube::plugin_dir
  $real_home      = $::sonarqube::real_home
  $service        = $::sonarqube::service
  $user           = $::sonarqube::user
  $user_system    = $::sonarqube::user_system
  $version        = $::sonarqube::version

  validate_absolute_path($download_dir)
  Exec {
    path => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin',
  }
  File {
    owner => $user,
    group => $group,
  }

  # wget from https://github.com/maestrodev/puppet-wget
  include ::wget

  Sonarqube::Move_to_home {
    home => $real_home,
  }

  $tmpzip = "${download_dir}/${package_name}-${version}.zip"
  $script = "${installdir}/bin/${arch}/sonar.sh"

  if ! defined(Package[unzip]) {
    package { 'unzip':
      ensure => present,
      before => Exec[untar],
    }
  }

  wget::fetch { 'download-sonar':
    source      => "${download_url}/${package_name}-${version}.zip",
    destination => $tmpzip,
  }
  # ===== Create folder structure =====
  # so uncompressing new sonar versions at update time use the previous sonar home,
  # installing new extensions and plugins over the old ones, reusing the db,...

  # Sonar home
  -> file { $real_home:
    ensure => directory,
    mode   => '0700',
  }
  -> file { "${installroot}/${package_name}-${version}":
    ensure => directory,
  }
  -> file { $installdir:
    ensure => link,
    target => "${installroot}/${package_name}-${version}",
    notify => Service['sonarqube'],
  }
  -> sonarqube::move_to_home { 'data': }
  -> sonarqube::move_to_home { 'extras': }
  -> sonarqube::move_to_home { 'extensions': }
  -> sonarqube::move_to_home { 'logs': }
  # ===== Install SonarQube =====
  -> exec { 'untar':
    command => join(
      [
        "unzip -o ${tmpzip} -d ${installroot}",
        "chown -R ${user}:${group} ${installroot}/${package_name}-${version}",
        "chown -R ${user}:${group} ${real_home}",
      ],
      ' && '
    ),
    creates => "${installroot}/${package_name}-${version}/bin",
    notify  => Service['sonarqube'],
  }
  -> file { $script:
    mode    => '0755',
    content => template('sonarqube/sonar.sh.erb'),
  }
  -> file { "/etc/init.d/${service}":
    ensure => link,
    target => $script,
  }

  file { '/tmp/cleanup-old-plugin-versions.sh':
    content => template("${module_name}/cleanup-old-plugin-versions.sh.erb"),
    mode    => '0755',
  }
  -> file { '/tmp/cleanup-old-sonarqube-versions.sh':
    content => template("${module_name}/cleanup-old-sonarqube-versions.sh.erb"),
    mode    => '0755',
  }
  -> exec { 'remove-old-versions-of-sonarqube':
    command     => "/tmp/cleanup-old-sonarqube-versions.sh ${installroot} ${version}",
    path        => '/usr/bin:/usr/sbin:/bin:/sbin:/usr/local/bin',
    refreshonly => true,
    subscribe   => File["${installroot}/${package_name}-${version}"],
  }

  # The plugins directory. Useful to later reference it from the plugin definition
  file { $plugin_dir:
    ensure => directory,
  }

}
