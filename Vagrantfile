# -*- mode: ruby -*-
# vi: set ft=ruby :

def Kernel.is_windows?
    # Detect if we are running on Windows
    processor, platform, *rest = RUBY_PLATFORM.split("-")
    platform == 'mingw32'
end

proxy_host = "172.16.34.1"
proxy_port = "3128"
host_ip    = "10.10.10.10"
ssh_dir    = "~/.ssh/"

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

  # expose services
  config.vm.network :forwarded_port, guest: 80, host: 8888
  config.vm.network :forwarded_port, guest: 22, host: 2299
  config.vm.network :forwarded_port, guest: 3333, host: 3333
  config.vm.network :forwarded_port, guest: 35357, host: 35357
  config.vm.network :forwarded_port, guest: 5000, host: 5000
  config.vm.network :forwarded_port, guest: 8000, host: 8000
  config.vm.network :forwarded_port, guest: 8004, host: 8004
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.network :forwarded_port, guest: 8773, host: 8773
  config.vm.network :forwarded_port, guest: 8774, host: 8774
  config.vm.network :forwarded_port, guest: 8776, host: 8776
  config.vm.network :forwarded_port, guest: 8777, host: 8777
  config.vm.network :forwarded_port, guest: 9292, host: 9292
  config.vm.network :forwarded_port, guest: 9696, host: 9696
  config.vm.network :forwarded_port, guest: 27017, host: 27017
  config.vm.network :forwarded_port, guest: 3306, host: 3306
  config.vm.network :private_network, ip: host_ip
  #config.vm.boot_mode='gui'
  
  if !Kernel.is_windows?
      config.vm.synced_folder ssh_dir, "/home/vagrant/.host_ssh"
  end

  config.vm.provision :shell, :path => "bootstrap.sh" 
  config.vm.provision :puppet do |puppet|
  puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.manifest_file = "vagrant.pp"
    puppet.options = ["--verbose", "--node_name_value", config.vm.hostname, "--http_proxy_host", proxy_host, "--http_proxy_port", proxy_port ]
  end
end
