# Mior development environment

Ubuntu environment to run scripts and build projects based in a Vagrant box.
Mior environment is the place where we can build, test and run scripts and projects fast and easily.

In order to ensure an uniform development environment, we maintain our development environment under version control using [Vagrant](http://vagrantup.com) (version 1.8.5 or up). Take a look on the [requirements](./requirements.md)

* To create the development environment, simply run `vagrant up` at the root level of this repository.
* To update an existing development environment with latest changes from this Git repository, either run `vagrant provision` (if VM already running) or `vagrant up --provision` (to bring it up and re-provision it).
* To recreate VM from scratch, run `vagrant destroy` and then `vagrant up`

> **Notes:**
> 1. If you did not already, you SHOULD also run `vagrant plugin install vagrant-proxyconf` and `vagrant plugin install vagrant-vbguest` before `vagrant up`.
> 2. When asked which network interface you want to use, choose `bridge0` on Linux & OSX.

##### Features:
* if you have an `id_rsa` and `id_rsa.pub` keypair at ~/.ssh, the vagrant box is provisioned with your keys instead of dynamically creating its own keypair.
* if you have AWS profiles configured at `~/.aws`, they are copied into the vagrant box home dir.
* if you have `~/.mior-devenv` it will allow personalized shell commands to extend the vagrant provisioner
* if you have `~/.devenv_profile` it will allow a personalized extension to `~/.bash_profile`.

##### Commands:
* Use `vagrant up` to start or provision the vagrant box for the first time.
* Use `vagrant ssh` to log in the vagrant box.
* Use `vagrant halt` to stop your vagrant box.

> **Note:** Use `vagrant halt` instead of suspend to stop your vagrant box. When resuming a suspended VM, date and time may not synchronize correctly.

##### Port Forwarding:
By default, this vagrant box exposes the most used ports:

| port: | purpose: |
| ---- | ---- |
| `8000` |  for java debugging |
| `8080` |  for http |
| `8443` |  for https |

If you need to add custom ports for your service, create a `Vagrantfile` at your home directory (`~/.vagrant.d/Vagrantfile`):

More info at: https://www.vagrantup.com/docs/vagrantfile/#load-order-and-merging

```
Vagrant.configure('2') do |config|
  # Cassandra
  config.vm.network :forwarded_port, guest: 9042, host: 9042, auto_correct: true
  # Proxy
  config.vm.network :forwarded_port, guest: 8081, host: 8081, auto_correct: true
  config.vm.network :forwarded_port, guest: 8444, host: 8444, auto_correct: true
  # RabbitMQ
  config.vm.network :forwarded_port, guest: 15672, host: 15672, auto_correct: true
  # MySQL
  config.vm.network :forwarded_port, guest: 3306, host: 3306, auto_correct: true
  # Consul-UI
  config.vm.network :forwarded_port, guest: 8500, host: 8500, auto_correct: true
  # MongoDB
  config.vm.network :forwarded_port, guest: 27017, host: 27017, auto_correct: true
end
```
