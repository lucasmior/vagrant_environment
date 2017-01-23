# -*- mode: ruby -*-
# vi: set ft=ruby :

use_proxy = true
url_proxy = ENV['http_proxy'] || 'http://web-proxy.corp.hp.com:8080/'
not_proxy = 'localhost,127.0.0.1,.hpicorp.net,15.0.0.0/8,16.0.0.0/8'

private_key = File.expand_path(File.join(Dir.home, '.ssh/id_rsa'))
public_key = File.expand_path(File.join(Dir.home, '.ssh/id_rsa.pub'))

Vagrant.configure('2') do |config|
  # Proxy configuration:
  #
  if use_proxy
    if Vagrant.has_plugin?('vagrant-proxyconf')
      config.proxy.http     = url_proxy
      config.proxy.https    = url_proxy
      config.proxy.no_proxy = not_proxy
    else
      puts '.'
      puts 'ERROR: Could not find vagrant-proxyconf plugin.'
      puts 'INFO: This plugin is required to use this box inside HPinc network.'
      puts 'INFO: $ vagrant plugin install vagrant-proxyconf'
      puts 'ERROR: Bailing out.'
      puts '.'
      exit 1
    end
  end

  # VB Guest Additions configuration:
  #
  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_reboot = true
  else
    puts '.'
    puts 'WARN: Could not find vagrant-vbguest plugin.'
    puts 'INFO: This plugin is highly recommended as it ensures that your VB guest additions are up-to-date.'
    puts 'INFO: $ vagrant plugin install vagrant-vbguest'
    puts '.'
  end

  # Official Ubuntu 16.04 LTS (Xenial Xerus)
  config.vm.box = 'ubuntu/xenial64'
  config.vm.define "george-devenv"
  config.vm.hostname = "george-devenv"

  # SSH configuration:
  # Ensures the vagrant user is configured to use your keypair.
  #
  if File.exist?(private_key) && File.exist?(public_key)
    puts '.'
    puts 'INFO: Configuring the vagrant box to use your own keypair.'
    puts "INFO: * [private key]: #{private_key}"
    puts "INFO: * [public  key]: #{public_key}"
    puts '.'
    config.ssh.insert_key = false
    config.ssh.private_key_path = [private_key, '~/.vagrant.d/insecure_private_key']
    config.vm.provision 'file', source: public_key, destination: '~/.ssh/authorized_keys'
    config.vm.provision 'file', source: private_key, destination: '~/.ssh/id_rsa'
  else
    puts '.'
    puts 'WARN: Could not find either your private or public keys in the default locations.'
    puts "INFO: * [private key]: #{private_key}"
    puts "INFO: * [public  key]: #{public_key}"
    puts 'WARN: The vagrant box is going to be configured with its own self-created keypair.'
    puts '.'
  end

  # Port Forwarding:
  # Use ~/.vagrant.d/Vagrantfile for adding your service custom ports.
  #
  config.vm.network :forwarded_port, guest: 8000, host: 8000, auto_correct: true # debug
  config.vm.network :forwarded_port, guest: 8001, host: 8001, auto_correct: true # kube proxy
  config.vm.network :forwarded_port, guest: 8080, host: 8080, auto_correct: true # http
  config.vm.network :forwarded_port, guest: 8443, host: 8443, auto_correct: true # https

  # Box configuration. Configures the development environment with all required tools:
  config.vm.provision :shell, path: 'bootstrap.sh'
  custom_provisioner = File.expand_path('~/.george-devenv')
  george_profile = File.expand_path('~/.devenv_profile')
  config.vm.provision 'file', source: george_profile, destination: '~/.devenv_profile' if File.exists?(george_profile)
  config.vm.provision 'file', source: 'bash_profile', destination: '~/.bash_profile'
  config.vm.provision :shell, path: custom_provisioner if File.exists?(custom_provisioner)
  config.vm.synced_folder Dir.home, '/home/ubuntu/shared', create: true
  config.vm.network :public_network, bridge: 'eth0'

  config.vm.provider :virtualbox do |vb|
    vb.name = 'george-devenv'
    vb.customize ['modifyvm', :id, '--memory', '2048']
    vb.customize ['modifyvm', :id, '--cpus', '1']
    vb.customize ['modifyvm', :id, '--ioapic', 'on']
  end
end
