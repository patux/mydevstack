Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
}

stage { 'pre': before => Stage['main'], }
stage { 'post': }
Stage['main'] -> Stage['post']

#--------------------------------------------
# Base

node basenode {

    class { 'updatekernel':        stage => pre }
}

#--------------------------------------------

node default inherits basenode {

  group { 'vagrant': ensure => 'present'; } ->
  user  { 'vagrant': ensure => 'present'; } 

}
