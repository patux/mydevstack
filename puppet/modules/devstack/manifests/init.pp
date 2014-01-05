class devstack ($devstack_branch = "stable/grizzly") {
  file {"/home/vagrant/install_devstack.sh":
    owner => vagrant,
    group => vagrant,
    mode => '0740',
    replace => false,
    content => template('devstack/install_devstack.sh.erb'),
  } ~>
  exec { "su - vagrant -c '/home/vagrant/install_devstack.sh | tee -a /tmp/devstack_install.log&'":
    provider => shell,
    cwd => "/home/vagrant/",
    #user => vagrant,
    #group => vagrant,
    refreshonly => true,   
    timeout   => 0,
    logoutput => true,
  }
}
