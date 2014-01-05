stage { 'pre': before => Stage['main'], }
stage { 'post': }
Stage['main'] -> Stage['post']

#--------------------------------------------
# Base

node basenode {
  class { 'proxy': 
        http_proxy_host  => "172.16.34.1",
        http_proxy_port  => "3128", 
        https_proxy_host =>  "172.16.34.1",
        https_proxy_port => "3128", 
        socks_proxy_host =>  "", 
        socks_proxy_port => "", 
        no_proxy_domains => ".mylocalnet.com",
        stage => pre;
    }
  class { "base":        stage => pre, require => Class['proxy']; }
}

#--------------------------------------------

node default inherits basenode {

  class { "devstack": devstack_branch => "master"; }

  group { "vagrant": ensure => "present"; } ->
  user  { "vagrant": ensure => "present"; } 

}
