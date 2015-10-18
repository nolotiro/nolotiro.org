# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.box = "precise32"

  config.vm.provision :shell, :path => "bin/bootstrap.sh"

  config.vm.network :forwarded_port, guest: 3000, host: 8080
  config.vm.network :forwarded_port, guest: 1080, host: 8081

end
