# mission-accomplished-2
AWS EKS cluster with Terraform

## Configuration


### Terraform

You need to run the following commands to create the resources with Terraform:

```bash
terraform init
terraform plan -out eks-demo
terraform apply "eks-demo"
```

### Setup kubectl

Setup your `KUBECONFIG`

```bash
terraform output kubeconfig > ${HOME}/.kube/config-eks-demo
export KUBECONFIG=$KUBECONFIG:~/.kube/config-eks-demo
echo 'export KUBECONFIG=$KUBECONFIG:~/.kube/config-eks-demo' >> ~/.bash_profile
```

### Authorize worker nodes

Get the config from terraform output, and save it to a yaml file:

```bash
terraform output config-map > config-map-aws-auth.yaml
```

### set the env for kubectl to communicate to EKS

```
env:
- name: AWS_PROFILE
  value: aws_profile_value
```


Apply the config map to EKS:

```bash
kubectl apply -f config-map-aws-auth.yaml
```

### Create role  to map user
```
```

### Create role binding to map user
```
```



### Cleaning up

You can destroy this cluster and vpc entirely by running:

```bash
terraform destroy
```

###configuration file for the RDS service

### RDS username and password into the Kubernetes cluster
username and password is a base64 encoded string generated
```
echo -n ${RDS_TEMP_CREDENTIALS} | base64
```

### Ingress
```
kubectl run nginx --image=nginx --replicas=1 --port=80
kubectl expose deployment nginx --port=80 --target-port=80 --type=LoadBalancer
```
Route53 mapping
```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/route53-mapper/v1.3.0.yml
```
