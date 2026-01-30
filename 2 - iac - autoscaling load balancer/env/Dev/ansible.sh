#!/bin/bash
cd /home/ubuntu
sudo apt update
sudo apt install -y python3.12-venv
python3 -m venv /home/ubuntu/ansible
. /home/ubuntu/ansible/bin/activate
pip install --upgrade pip
pip install ansible-core==2.13.13
pip install --upgrade pip setuptools wheel
tee -a playbook.yml > /dev/null <<EOT
- hosts: localhost
  tasks:
    - name: Install Python3 and virtualenv
      apt:
        pkg:
          - python3
          - virtualenv
        update_cache: yes
      become: yes
    - name: Git Clone
      ansible.builtin.git:
        repo: "https://github.com/guilhermeonrails/clientes-leo-api.git"
        dest: /home/ubuntu/tcc
        version: master
        force: yes
    - name: Alterando alterando versao asgiref no requirements.txt
      lineinfile:
        path: /home/ubuntu/tcc/requirements.txt
        regexp: "^asgiref==.*"
        line: "asgiref==3.6.0"
        backrefs: yes
    - name: Alterando alterando versao djangorestframework no requirements.txt
      lineinfile:
        path: /home/ubuntu/tcc/requirements.txt
        regexp: "^Django==.*"
        line: "Django==4.2.7"
        backrefs: yes
    - name: Alterando alterando versao djangorestframework no requirements.txt
      lineinfile:
        path: /home/ubuntu/tcc/requirements.txt
        regexp: "^djangorestframework==.*"
        line: "djangorestframework==3.14"
        backrefs: yes
    - name: Instalando pacotes via requirements.txt
      pip:
        virtualenv: /home/ubuntu/tcc/venv
        requirements: /home/ubuntu/tcc/requirements.txt
    - name: Alterando host do settings.py para aceitar todas as requisições
      lineinfile:
        path: /home/ubuntu/tcc/setup/settings.py
        regexp: "^ALLOWED_HOSTS =.*"
        line: "ALLOWED_HOSTS = ['*']"
        backrefs: yes
    - name: Configurando o banco de dados
      shell: ". /home/ubuntu/tcc/venv/bin/activate; python /home/ubuntu/tcc/manage.py migrate"
    - name: Carregando dados iniciais
      shell: ". /home/ubuntu/tcc/venv/bin/activate; python /home/ubuntu/tcc/manage.py loaddata clientes.json"
    - name: Iniciando servidor
      shell: ". /home/ubuntu/tcc/venv/bin/activate; nohup python /home/ubuntu/tcc/manage.py runserver 0.0.0.0:8000 &"

EOT
ansible-playbook playbook.yml