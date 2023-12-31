#!/bin/bash

set_hostname() {
    local ec2_host_name="minikube"

    if [ "$(hostnamectl --static)" != "$ec2_host_name" ]; then
        # if [[ $EUID -ne 0 ]]; then
        #     echo -e "\u274C  The initial execution of this script requires root privileges.\n\tPlease run it with elevated permissions."
        #     exit 1
        # else
            echo -e "\u2705  Setting up the host name..."
            hostnamectl set-hostname "$ec2_host_name"
        # fi
    # else
    #     install_cloud9_cli
    #     setup_minikube

    #     exit 0
    fi
}

install_packages() {
    local packages=("$@")

    # Check whether the OS is Amazon Linux.
    if [ "$(awk -F= '$1=="ID" { print $2 ;}' /etc/os-release | sed -e 's/^"//' -e 's/"$//')" == "amzn" ]; then
        echo -e "\u2705  Updating the system packages..."
        yum -y update

        for package in "${packages[@]}"; do
            if [ -x $(command -v "$package") ]; then
                echo -e "\n\u2705  Installing: $package...\n"
                yum -y install "$package"

                case $package in
                    "docker")
                        # Initiate Docker and grant permissions to the 'docker' group.
                        if ! systemctl start docker || ! systemctl enable docker; then
                            echo -e "Error:\tFailed to start or enable Docker."
                            exit 1
                        else
                            usermod -aG docker ec2-user
                        fi
                        ;;
                esac
            fi
        done
    else
        echo -e "Error:\tThis OS is not supported.\n\tPlease use it with Amazon Linux 2."
        exit 1
    fi
}

install_cloud9_cli() {
    local doc_dir="/home/ec2-user/environment/Kubernetes/"

    echo -e "\n\u2705  Installing the Cloud9 CLI...\n"

    # Install the Cloud9 CLI: https://cloud9-sdk.readme.io/docs/the-cloud9-cli
    npm install -g c9

    echo -e "\n\u2705  Setting up the IDE...\n"
    c9 open "$doc_dir/pod.yaml"
    c9 open "$doc_dir/node.yaml"
    c9 open "$doc_dir/cluster.yaml"
    c9 open "$doc_dir/minikube.yaml"
}

install_minikube() {
    # Check if minikube is already installed.
    if [ ! -f "/usr/local/bin/minikube" ]; then
        echo -e "\nMinikube not found.\n\n\u2705  Installing Minikube...\n"

        # Download and install the most recent version of Minikube.
        sudo curl -L https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64 -o /usr/local/bin/minikube \
            && sudo chmod +x /usr/local/bin/minikube

        # Create a symbolic link to minikube's binary named 'kubectl'.
        sudo ln -s -f /usr/local/bin/minikube /usr/local/bin/kubectl

        # echo -e "\nFinalizing the setup is almost complete. Simply press CTRL+D to finish."
        # newgrp docker

        echo -e "\n\u2705  Setup complete! Minikube is now ready.\n"

        if [[ $EUID -ne 0 ]]; then
            install_cloud9_cli
            setup_minikube
        else
            echo -e " Please execute: bash ./Kubernetes/init.sh"
            exit 0
        fi
    fi
}

setup_minikube() {
    read -p "Enter the Kubernetes cluster name: " k8s_name
    read -p "Enter the total number of nodes in the cluster: " k8s_node_count

    if [ -z "$k8s_name" ] || [ -z "$k8s_node_count" ]; then
        echo -e "Error:\tPlease provide valid input for both the cluster name and node count."
        exit 1
    else
        if [ "$(minikube profile list | grep -q "$k8s_name")" ]; then
            echo -e "Error:\tThe profile '$k8s_name' already exists.\n\tPlease choose a different name."
            exit 1
        else
            # Start Minikube as the current user.
            # https://minikube.sigs.k8s.io/docs/drivers/
            minikube start --nodes "$k8s_node_count" --profile "$k8s_name" --driver=docker
            minikube profile "$k8s_name"

            if [ "$k8s_node_count" -gt 1 ]; then
                for ((i = 1; i < k8s_node_count; i++)); do
                    worker_node_name="$k8s_name-m$(printf "%02d" $((i + 1)))"

                    echo -e "\n\u2139  Labeling worker node: $worker_node_name..."
                    kubectl label node "$worker_node_name" node-role.kubernetes.io/worker=worker
                done
            fi

            # Display Minikube cluster status.
            echo -e "\n Cluster status:\n"
            kubectl get nodes
        fi
    fi
}

set_hostname
# install_packages "docker" "conntrack" "git" "tmux" "jq"
install_minikube
