#!/bin/bash

# Executar o Terraform para criar a instância EC2
echo "Iniciando o Terraform..."
cd terraform
terraform init
terraform apply -auto-approve

# Verificar se o Terraform foi executado com sucesso
if [ $? -eq 0 ]; then
    echo "Terraform finalizado com sucesso."
else
    echo "Terraform falhou. Verifique o erro."
    exit 1
fi

ec2_ip=$(terraform output -raw ec2_public_ip)
rds_endpoint=$(terraform output -raw rds_endpoint)
echo "RDS Endpoint: $rds_endpoint"
cd ..
cd ansible

rm -f ./hosts.ini

# Atualizar o arquivo hosts.ini com o IP público correto
echo "[ec2]" > ./hosts.ini
echo "$ec2_ip ansible_user=ubuntu ansible_python_interpreter=/usr/bin/python3 ansible_ssh_common_args='-o StrictHostKeyChecking=no'" >> ./hosts.ini

# Executar o Ansible Playbook usando o arquivo hosts.ini gerado pelo Terraform
echo "Executando o Ansible Playbook..."
ansible-playbook -i hosts.ini playbook.yml --extra-vars "rds_endpoint=$rds_endpoint"

# Verificar se o Ansible foi executado com sucesso
if [ $? -eq 0 ]; then
    echo "Ansible Playbook finalizado com sucesso."
else
    echo "Ansible Playbook falhou. Verifique o erro."
    exit 1
fi
