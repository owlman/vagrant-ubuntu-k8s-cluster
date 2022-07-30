 vm_list = [
    {
        :name => "k8s-master",
        :eth1 => "192.168.100.21",
        :mem => "2048",
        :cpu => "2",
        :sshport => 22230
    },
    {
        :name => "k8s-worker1",
        :eth1 => "192.168.100.22",
        :mem => "2048",
        :cpu => "2",
        :sshport => 22231
    },
    {
        :name => "k8s-worker2",
        :eth1 => "192.168.100.23",
        :mem => "2048",
        :cpu => "2",
        :sshport => 22232
    }
]

Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu-server-2004"
    config.vm.box_check_update = false
    Encoding.default_external = 'UTF-8'
    vm_list.each do |item|
        config.vm.define item[:name] do |config|
            config.vm.hostname = item[:name]
            config.vm.network "private_network", ip: item[:eth1]
            config.vm.network "forwarded_port", guest: 22, host: 2222, id: "ssh", disabled: "true"
            config.vm.network "forwarded_port", guest: 22, host: item[:sshport]
            config.vm.provider "virtualbox" do |v|
                v.memory = item[:mem];
                v.cpus = item[:cpu];
                v.name = item[:name];
            end
            config.vm.provision "shell", path: "scripts/common.sh"
            if item[:name] == "k8s-master"
                config.vm.provision "shell", path: "scripts/master.sh"
            else
                config.vm.provision "shell", path: "scripts/worker.sh"
            end
        end
    end
end
