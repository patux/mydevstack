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
    'ftp_proxy_host' => nil,
    'ftp_proxy_port' => nil,
    'no_proxy_domains' => nil,
    'host_ip'          => '10.10.10.10',
    'ssh_dir'          => '~/.ssh/',
}

vd_conf = ENV.fetch('VD_CONF', 'etc/common.yaml')
if File.exist?(vd_conf)
    require 'yaml'
    user_conf = YAML.load_file(vd_conf)
    conf.update(user_conf)
end

host_ip    = conf['host_ip']
ssh_dir    = conf['ssh_dir']

Vagrant.configure("2") do |config|
  config.vm.hostname = "devstack.mylocalnet.com"
  config.vm.box = "precise64"
  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.provider :vmware_fusion do |v, override|
    override.vm.box = "precise64_vmware"
    override.vm.box_url = "http://files.vagrantup.com/precise64_vmware.box"
    v.vmx["memsize"] = "4096"
    v.vmx["numvcpus"] = "1"
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 4096 ]
    vb.customize ["modifyvm", :id, "--cpus", 1 ]
    # If you don’t have a modern computer with CPU supporting hardware virtualization 
    # Uncomment next line (Be aware it will run much slower)
    # vb.customize ["modifyvm", :id, “–hwvirtex”, “off”]
  end
  config.vm.network :private_network, ip: host_ip
  #config.vm.boot_mode='gui'
  
  if !Kernel.is_windows?
      config.vm.synced_folder ssh_dir, "/home/vagrant/.host_ssh"
  end

  config.vm.provision :puppet do |puppet|
  puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file = "vagrant-noproxy.pp"
    puppet.manifest_file = "vagrant-proxy.pp" if !conf['http_proxy_host'].nil? && !conf['http_proxy_port'].nil? && !conf['http_proxy_host'].to_s.empty? && !conf['http_proxy_port'].to_s.empty?
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
        }
    end
end
