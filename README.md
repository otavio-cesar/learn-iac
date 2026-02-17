# Intro

Here is some scripts took during the lessons

## Comandos

- ssh-keygen

- terraform output

### Aws - Firs Steps

    sudo apt install awscli

    aws configure

    aws sts get-caller-identity

    aws configure list

    aws login --profile my-dev-profile

    aws ec2 describe-availability-zones --filters Name=zone-type,Values=availability-zone --region us-east-2 --query AvailabilityZones[].ZoneName

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

    zip -r desenvolvimento.zip Dockerrun.aws.json

### Criando imagem a partir do Dockerfile

    docker build . -t producao:V1
    
    docker run -p 8000:8000 producao:V1

### Repositorio api no github 

    git clone git@github.com:otavio-cesar/clientes-leo-api.git

### Configuring ECR

    docker images

#### Privado

    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 045444243386.dkr.ecr.us-east-1.amazonaws.com

    docker push 045444243386.dkr.ecr.us-east-1.amazonaws.com/ecs-repo:V1

    docker tag aa5c29b9d17d 045444243386.dkr.ecr.us-east-1.amazonaws.com/ecs-repo:V1
    
#### Publico 

    aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/n2a9h7x9/ecs-repo

    docker tag aa5c29b9d17d public.ecr.aws/n2a9h7x9/ecs-repo

    docker push public.ecr.aws/n2a9h7x9/ecs-repo

## 5 - iac - EKS

    aws eks describe-addon-versions   --addon-name vpc-cni   --region us-east-1   --query "addons[].addonVersions[].addonVersion"   --output text

    terraform state rm module.aws_dev.kubernetes_deployment_v1.Django_API-deployment

Configura o kubctl para conectar ao cluster eks dev

    aws eks update-kubeconfig --region us-east-1 --name eksdev

Delete pod

    kubectl delete pod django-api-deployment-6bcb446d9-5ngcd -n default

## Terraform 
Importar recurso:

    terraform import \
    module.aws_dev.aws_s3_bucket.beanstalk_deploys \
    desenvolvimento-deploys-123321

    terraform import module.aws_dev.aws_elastic_beanstalk_environment.ambiente_beanstalk ambiente-dev

Atualiza o ambiente:

    aws elasticbeanstalk update-environment \
    --environment-name clientes-api-ambiente-dev-v1 \
    --version-label clientes-api-ambiente-dev-v1-3d973bc1-b08d-a22e-26d0-85e9cfb2082e

Rodar para apagar imagens antes de excluir o repositorio:

    aws ecr batch-delete-image --repository-name repo-ecr-dev --image-ids imageTag=latest

# References

- https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/single-container-docker-configuration.html - Beanstalk container configuration

- https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#examples - TF Provider EKS

- https://github.com/hashicorp/terraform-provider-kubernetes/blob/main/_examples/eks/kubernetes-config/main.tf - Exemplo configuracao provider Kubernets

# Duvidas

- Como configurar sem o Kubernetes Auto Mode
- Como acessar registros privados de imagens a partir do ECS (Configurar autenticação dos serviços - https://docs.aws.amazon.com/pt_br/elasticbeanstalk/latest/dg/docker-configuration.remote-repo.html)