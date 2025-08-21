### Enable Dynamic Provisioning In Self-hosted/On-prem K8s Cluster With `aws-ebs-csi-driver` 
- Install [helm](https://helm.sh/docs/intro/install/)
- Add [aws-ebs-csi-driver](https://artifacthub.io/packages/helm/aws-ebs-csi-driver/aws-ebs-csi-driver) helm repo locally and update the repo
  
  ```bash
  helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver/
  helm repo update 
  ```
- Download `aws-ebs-csi-driver` helm chart

```bash
helm pull aws-ebs-csi-driver/aws-ebs-csi-driver --version 2.48.0 --untar
```

- Deploy `aws-ebs-csi-driver` driver to your cluster
```bash 
helm install aws-ebs-csi-driver -n kube-system aws-ebs-csi-driver/
```
- Deploy `storageclass` and test Dynamic provisioning
