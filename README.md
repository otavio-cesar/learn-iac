# Intro

Here is some scripts took during the lessons

## Comandos

- ssh-keygen

- terraform output

## Rodar servidor dentro da instancia

    python ./tcc/manage.py runserver 0.0.0.0:8000


## 0 - iac - intro

### Conectar a máquina

    ssh -i "par-chaves.pem" ubuntu@3.94.202.135

### Executar playbook
 
    ansible-playbook playbook.yml -u ubuntu --private-key par-chaves.pem -i hosts.yml

## 1 - iac - multiple environments

### Executar playbook em ambiente dev
 
    ansible-playbook env/Dev/playbook.yml -u ubuntu --private-key env/Dev/IaC-DEV -i infra/hosts.yml

### Executar playbook em ambiente Prod
 
    ansible-playbook env/Prod/playbook.yml -u ubuntu --private-key env/Prod/IaC-PROD -i infra/hosts.yml

### Conectar a máquina

    ssh -i "env/Dev/IaC-DEV" ubuntu@13.217.128.94

## Teste de Carga

    pip install locust
    
    locust -f carga.py
