# container-ansible-playbook

docker pull examplecom/ansible-playbook

docker run --rm -it -v ~/.ssh/id_rsa:/root/.ssh/id_rsa -v ~/.ssh/id_rsa.pub:/root/.ssh/id_rsa.pub -v $(pwd):/ansible examplecom/ansible-playbook <your-playbook.yml>


git clone https://github.com/examplecom/container-ansible-playbook.git
sudo docker build -t examplecom/ansible-playbook -f Dockerfile .
sudo docker push examplecom/ansible-playbook
