class devstack ($devstack_branch = "master", $stackuser = "stack") {
  file {"/home/$stackuser/install_devstack.sh":
    owner => $stackuser,
    group => $stackuser,
    mode => '0740',
    replace => false,
    content => template('devstack/install_devstack.sh.erb'),
  } ~>
  exec { "su - $stackuser -c '/home/$stackuser/install_devstack.sh | tee -a /tmp/devstack_install.log&'":
    provider => shell,
    cwd => "/home/$stackuser/",
    #user => $stackuser,
    #group => $stackuser,
    refreshonly => true,   
    timeout   => 0,
    logoutput => true,
  }
}
