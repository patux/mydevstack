class base {
  $base_packages = [ "curl", "git-core", "vim", "wget", "libssl0.9.8", "build-essential", "libsqlite3-dev", "libffi-dev", "git-review", "python-dev" ]

  exec {"hold kernel":
    command   => "/usr/bin/apt-mark hold linux-image-`uname -r`; echo ",
    timeout   => 0,
    logoutput => true,
  }
  exec {"hold cloudinit":
    command   => "/usr/bin/apt-mark hold cloud-init; echo ",
    logoutput => true, 
    onlyif    => "dpkg -la | grep cloud-init | awk '{print $2}'",
  }

  exec {"update apt":
    command   => "/bin/bash -c 'source /etc/environment;/usr/bin/apt-get -y update;/usr/bin/apt-get -y dist-upgrade'",
    #command  => "apt-get -y update",
    timeout   => 0,
    logoutput => true,
    require => Exec["hold kernel","hold cloudinit"],
  }

  group { "puppet": ensure => "present"; }  ->

  class { "aptitude": require         => Exec['update apt'], } ->
  package { $base_packages: ensure => installed }
    file { '/tmp/setuptools-1.1.tar.gz':
      ensure  => file,
      owner   => root,
      group   => root,
      mode    => 600,
      source  => 'puppet:///modules/base/setuptools-1.1.tar.gz',
  } ->
  exec { "/bin/bash -c 'source /etc/environment;cd /tmp;/bin/tar zxvf setuptools-1.1.tar.gz;cd setuptools-1.1 && sudo python setup.py install;sudo easy_install pip'":
    timeout   => 0,
    logoutput => true,
    require   => Package[$base_packages],
  }


}
