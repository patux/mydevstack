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
        stage            => pre;
    }
    class { 'base':        stage => pre, require => Class['proxy']; }
}

#--------------------------------------------

node default inherits basenode {

    if $::stackuser != "nil" {
        $stackuser = $::stackuser
    }
    else {
        $stackuser = "stack" 
    }

    file_line { 'stackuser_rule':
       path => '/etc/sudoers',
       line => "${stackuser} ALL=(ALL) NOPASSWD:ALL"
    } ->
    group {  $stackuser : ensure => 'present'; } ->
    user  {  $stackuser : ensure => 'present'; }

    if $::install_devstack == "true"  {
        case $::devstack_branch {
            /(stable\/grizzly|stable\/havana|master)/: {
                class { 'devstack':  devstack_branch => $::devstack_branch, stackuser => $stackuser }
            }
            default: {
                class { 'devstack': stackuser => $stackuser }
            }
        }
    }
}
