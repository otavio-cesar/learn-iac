# Comandos 

Verifica versões de add disponivies. No automode isso é automatico.

    aws eks describe-addon-versions \
    --addon-name vpc-cni \
    --region us-east-1 \
    --query "addons[].addonVersions[].addonVersion" \
    --output text

Remove modulo do state.

    terraform state rm module.aws_dev.kubernetes_deployment_v1.Django_API-deployment

Configura o kubctl para conectar ao cluster eks dev

    aws eks update-kubeconfig --region us-east-1 --name eksdev

Delete pod

    kubectl delete pod django-api-deployment-6bcb446d9-5ngcd -n default

# Outros comandos

    kubectl get pods -n default
    kubectl delete pod django-api-deployment-6bcb446d9-lvpnw -n default
    kubectl describe pod django-api-deployment-6bcb446d9-lvpnw -n default

    kubectl logs django-api-deployment-55565b55b6-tsbx9  -n default
    kubectl logs django-api-deployment-6bcb446d9-lvpnw  -n default --previous

    kubectl exec -it django-api-deployment-6bcb446d9-lvpnw -n default -- netstat -tlnp
    kubectl exec -it django-api-deployment-6bcb446d9-lvpnw  -n default -- ss -tlnp
    kubectl exec -it django-api-deployment-55565b55b6-tsbx9 -n default -- curl http://localhost:8000/clientes
    kubectl exec -it django-api-deployment-6bcb446d9-lvpnw -n default -- ps aux

    kubectl port-forward django-api-deployment-55565b55b6-tsbx9 8000:8000 -n default -v=6

    kubectl describe svc load-balancer-django-api
    kubectl edit svc load-balancer-django-api
    kubectl delete svc load-balancer-django-api

    kubectl apply -f service.yaml

    kubectl debug node/i-003df0cd399471395 -it --image=busybox -- sh
    # Inside the debug pod:
    nslookup public.ecr.aws
    wget -O- --timeout=10 https://public.ecr.aws/v2/
