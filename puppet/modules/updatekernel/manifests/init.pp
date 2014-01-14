class updatekernel {
  $kernel_packages = [ "linux-image-generic-lts-raring", "linux-headers-generic-lts-raring" ]

  exec {"update apt":
    command   => "/bin/bash -c 'source /etc/environment;/usr/bin/apt-get -y update'",
    #command  => "apt-get -y update",
    timeout   => 0,
    logoutput => true,
  }

  group { "puppet": ensure => "present"; }  ->

  class { "aptitude": require         => Exec['update apt'], } ->
  package { $kernel_packages: ensure => installed }
}
