# -*- mode: ruby -*-
# vi: set ft=ruby :

def Kernel.is_windows?
    # Detect if we are running on Windows
    processor, platform, *rest = RUBY_PLATFORM.split("-")
    platform == 'mingw32'
end

conf = {
    'http_proxy_host'  => nil,
    'http_proxy_port'  => nil,
    'https_proxy_host' => nil,
    'https_proxy_port' => nil,
    'socks_proxy_host' => nil,
    'socks_proxy_port' => nil,
    'ftp_proxy_host'   => nil,
    'ftp_proxy_port'   => nil,
    'no_proxy_domains' => nil,
    'host_ip'          => "10.10.10.5",
    'ssh_dir'          => '~/.ssh/',
    'memory'           => 4096,
    'http_port_map'    => 8888,
    'ssh_port_map'     => 2022,
    'install_devstack' => true,
    'devstack_branch'  => 'master',
    'stackuser'       => 'vagrant',
}

vd_conf = ENV.fetch('VD_CONF', 'etc/common.yaml')
if File.exist?(vd_conf)
    require 'yaml'
    user_conf = YAML.load_file(vd_conf)
    conf.update(user_conf)
end

host_ip        = conf['host_ip']
ssh_dir        = conf['ssh_dir']
memory         = conf['memory']
http_port_map  = conf['http_port_map']
ssh_port_map   = conf['ssh_port_map']

Vagrant.configure("2") do |config|
  config.vm.hostname = "devstack.mylocalnet.com"
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  if Vagrant.has_plugin?("vagrant-proxyconf")
      config.proxy.http     = "#{conf['http_proxy_host']}:#{conf['http_proxy_port']}"
      config.proxy.https    = "#{conf['https_proxy_host']}:#{conf['https_proxy_port']}"
      config.proxy.no_proxy = conf['no_proxy_domains']
      config.apt_proxy.http = "#{conf['http_proxy_host']}:#{conf['http_proxy_port']}"
  end

  config.vm.provider :vmware_fusion do |v, override|
    override.vm.box = "precise64_vmware"
    override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
    v.vmx["memsize"] = memory 
    v.vmx["numvcpus"] = "4"
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", memory ]
    vb.customize ["modifyvm", :id, "--cpus", 4 ]
    # If you don’t have a modern computer with CPU supporting hardware virtualization 
    # Uncomment next line (Be aware it will run much slower)
    # vb.customize ["modifyvm", :id, “–hwvirtex”, “off”]
  end
  config.vm.network :private_network, ip: host_ip
  #config.vm.boot_mode='gui'

  if !Kernel.is_windows?
      config.vm.synced_folder ssh_dir, "/home/vagrant/.host_ssh"
  end

  config.vm.network :forwarded_port, guest: 80, host: http_port_map
  config.vm.network :forwarded_port, guest: 22, host: ssh_port_map
  #config.vm.provision :shell, :path => "bootstrap.sh"
  config.vm.provision :puppet do |puppet|
  puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    #puppet.manifest_file = "updatekernel.pp"
    puppet.manifest_file = "vagrant.pp"
    puppet.options = ["--verbose", "--node_name_value", config.vm.hostname] 
    puppet.options = puppet.options + ["--http_proxy_host", conf['http_proxy_host'], "--http_proxy_port", conf['http_proxy_port']] if !conf['http_proxy_host'].nil? && !conf['http_proxy_port'].nil? && !conf['http_proxy_host'].to_s.empty? && !conf['http_proxy_port'].to_s.empty?
    puppet.facter = {
        "http_proxy_host" => conf['http_proxy_host'],
        "http_proxy_port" => conf['http_proxy_port'],
        "https_proxy_host" => conf['https_proxy_host'],
        "https_proxy_port" => conf['https_proxy_port'],
        "socks_proxy_host" => conf['socks_proxy_host'],
        "socks_proxy_port" => conf['socks_proxy_port'],
        "ftp_proxy_host" => conf['ftp_proxy_host'],
        "ftp_proxy_port" => conf['ftp_proxy_port'],
        "no_proxy_domains" => conf['no_proxy_domains'],
        "vm_type" => "vagrant",
        "install_devstack" => conf['install_devstack'], 
        "devstack_branch"  => conf['devstack_branch'],
        "stackuser"  => conf['stackuser'],
        }
  end
end
