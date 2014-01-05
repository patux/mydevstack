Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
}

stage { 'pre': before => Stage['main'], }
stage { 'post': }
Stage['main'] -> Stage['post']

#--------------------------------------------
# Base

node basenode {

    class { 'base':        stage => pre }
}

#--------------------------------------------

node default inherits basenode {

  class { 'devstack': devstack_branch => 'master'; }

  group { 'vagrant': ensure => 'present'; } ->
  user  { 'vagrant': ensure => 'present'; } 

}
