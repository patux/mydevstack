Exec {
  path => "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin",
}

stage { 'pre': before => Stage['main'], }
stage { 'post': }
Stage['main'] -> Stage['post']

#--------------------------------------------
# Base

node basenode {

    if $::http_proxy_host {
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
        class { 'base':        stage => pre, require => Class['proxy']; }
    }
    else 
    {
        class { 'base':        stage => pre }
    }
}

#--------------------------------------------

node default inherits basenode {

    if $::install_devstack == "true" {
        case $::devstack_branch {
            /(stable\/grizzly|stable\/havana|master)/: {
                class { 'devstack':  devstack_branch => $::devstack_branch }
            }
            default: {
                class { 'devstack': devstack_branch => "master" }
            }
        }
    }

  group { 'vagrant': ensure => 'present'; } ->
  user  { 'vagrant': ensure => 'present'; } 

}
