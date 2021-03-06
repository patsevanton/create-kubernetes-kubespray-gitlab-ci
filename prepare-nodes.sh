#!/bin/bash

declare -a listipnodes=("ip1" "ip2" "ip3")

for ip_node in "${listipnodes[@]}"
do
    ssh -i PathToYourPrivateKey user@$ip_node 'sudo useradd user_kuber'
    ssh -i PathToYourPrivateKey user@$ip_node 'echo random-password | sudo passwd user_kuber  --stdin'
    ssh -i PathToYourPrivateKey user@$ip_node 'sudo usermod -aG wheel user_kuber'
    ssh -i PathToYourPrivateKey user@$ip_node 'sudo sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/selinux/config'
    ssh -i PathToYourPrivateKey user@$ip_node 'sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/" /etc/ssh/sshd_config'
    ssh -i PathToYourPrivateKey user@$ip_node "echo 'user_kuber ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/user_kuber"
    ssh -i PathToYourPrivateKey user@$ip_node "curl -sSL https://get.docker.com/ | sh"
    ssh -i PathToYourPrivateKey user@$ip_node "sudo systemctl enable docker"
    ssh -i PathToYourPrivateKey user@$ip_node "sudo systemctl start docker"
    ssh -i PathToYourPrivateKey user@$ip_node "curl -L https://packages.gitlab.com/install/repositories/runner/gitlab-ci-multi-runner/script.rpm.sh | sudo bash"
    ssh -i PathToYourPrivateKey user@$ip_node "sudo yum -y install gitlab-ci-multi-runner"
    ssh -i PathToYourPrivateKey user@$ip_node "sudo /usr/sbin/reboot"
    sleep 20
    ssh -i PathToYourPrivateKey user@$ip_node "sudo rm -rf /var/lib/docker"
done
