Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
}

stage { 'pre': before => Stage['main'], }
stage { 'post': }
Stage['main'] -> Stage['post']

#--------------------------------------------
# Base

node basenode {

    class { 'proxy':
        http_proxy_host  => $::http_proxy_host,
        http_proxy_port  => $::http_proxy_port,
        https_proxy_host => $::https_proxy_host,
        https_proxy_port => $::https_proxy_port,
        socks_proxy_host => $::socks_proxy_host,
        socks_proxy_port => $::socks_proxy_port,
        no_proxy_domains => $::no_proxy_domains,
        stage => pre;
    }
    class { 'updatekernel':        stage => pre, require => Class['proxy']; }
}

#--------------------------------------------

node default inherits basenode {

  group { 'vagrant': ensure => 'present'; } ->
  user  { 'vagrant': ensure => 'present'; } 

}
