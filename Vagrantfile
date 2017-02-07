# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.ssh.forward_x11 = true
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |v|
     v.memory = 4096
     v.cpus = 2
     v.customize ["modifyvm", :id, "--natdnshostresolver1", "on", "--name", "gocd"]
  end

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
    config.cache.synced_folder_opts = {
      type: :nfs,
      mount_options: ['rw', 'vers=3', 'tcp', 'nolock']
    }
  end

  config.vm.define "gocd", primary: true, autostart: true do |gocd|
    gocd.vm.synced_folder ".", "/vagrant"
    gocd.vm.box = "ubuntu/xenial64"
    gocd.vm.hostname = 'gocd.vagrant'
    gocd.vm.network :private_network, ip: "192.168.22.10"
    #gocd.vm.network "forwarded_port", guest: 8888, host: 8888, auto_correct: true
    gocd.vm.provision :hosts do |provisioner|
      provisioner.add_host '127.0.0.1', ['gocd.vagrant']
      provisioner.add_host '192.168.22.10', ['gocd.vagrant']
    end
    config.vm.provider :virtualbox do |v|
     v.customize ["modifyvm", :id, "--name", "gocd"]
    end
    gocd.vm.provision :shell, :inline => "echo 'Defaults    env_keep+=SSH_AUTH_SOCK' >> /etc/sudoers.d/ssh_auth_sock"
    gocd.vm.provision :shell, :inline => "cd /vagrant; make setup install"
  end

end
