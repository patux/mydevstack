class aptitude {
  exec { "aptitude-update":
    command => "bash -c 'source /etc/environment;/usr/bin/apt-get update'",
    refreshonly => false;
  }

  cron { "aptitude-update":
    command => "bash -c 'source /etc/environment;/usr/bin/aptitude update'",
    user    => root,
    hour    => 23,
    minute  => 59;
  }
}
