# container-ansible-playbook

docker pull examplecom/shared:ansible-playbook

docker run --rm -it -v ~/.ssh/id_rsa:/root/.ssh/id_rsa -v ~/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub -v $(pwd):/ansible examplecom/shared:ansible-playbook <your-playbook.yml>
