# Will attempt to run/install two variants of this VM by activating/deactivating several lines in this file

# Running the CorePlusGA variant is still a two step process, vagrant up then vagrant provision
# testing: `vagrant up && vagrant provision`

Vagrant.configure("2") do |config|
  # These two lines are not required with the jacqinthebox variant
  # Although, they probably would not hurt
  config.vm.guest = :windows
  config.vm.communicator = :winrm
  
  # jacqinthebox variant is bare bones 2012 core
  # CorePlusGA installs the latest Guest Additions
  config.vm.box = "CorePlusGA"
  # config.vm.box = "jacqinthebox/windowsserver2016core"

  # Setting a hostname is not required at this time??
  # config.vm.hostname = "CorePlusGA"
    
  config.winrm.username = "vagrant"
  config.winrm.password = "vagrant"

  config.vm.provider "virtualbox" do |vb|
    # install a DVD drive and insert the GA iso
    # it seems to persist even when this line is commented out?
    # vb.customize [ "storageattach", :id, "--storagectl", "IDE Controller", "--port", 1, "--device", 0, "--type", "dvddrive", "--medium", "/usr/share/virtualbox/VBoxGuestAdditions.iso"]
    
    # not necessary for jacqinthebox, but probably would not change anything
    # required for CorePlusGA
    vb.gui = true
  end

  config.vm.provision "chef_zero" do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.data_bags_path = "data_bags"
    chef.nodes_path = "nodes"
    chef.roles_path = "roles"

    chef.add_recipe "windows-core-as-code::default"
  end
end
