Vagrant.configure("2") do |config|
  config.vm.box = "jacqinthebox/windowsserver2016core"
  # config.vm.guest = :windows
  # config.vm.communicator = :winrm
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"

  config.vm.provision "chef_zero" do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.data_bags_path = "data_bags"
    chef.nodes_path = "nodes"
    chef.roles_path = "roles"

    chef.add_recipe "windows-core-as-code::default"
  end
end
