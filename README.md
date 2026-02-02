# Intro

Here is some scripts took during the lessons

## Comandos

- ssh-keygen

- terraform output

### Aws - Firs Steps

    aws sts get-caller-identity

    aws configure

    aws configure list

    sudo apt install awscli

    aws login --profile my-dev-profile

### Teste de Carga com Locust

    pip install locust
    
    locust -f carga.py

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

## 3 - iac - elastic beanstalk

### Conectar a máquina

    docker build . -t producao:V1
    
    docker run -p 8000:8000 producao:V1

### Repositorio api no github 

    git clone git@github.com:otavio-cesar/clientes-leo-api.git

### Configuring ECR

    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com

    docker images

    docker tag aa5c29b9d17d 045444243386.dkr.ecr.us-east-1.amazonaws.com/repo-ecr-dev:V1
    
    docker push 045444243386.dkr.ecr.us-east-1.amazonaws.com/repo-ecr-dev:V1

