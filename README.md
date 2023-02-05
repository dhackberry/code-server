# Code Server

## Use docker
```
mkdir -p $HOME/coder/workspace
docker run \
  --name code-server \
  --rm \
  -p 3000:3000 \
  -e PASSWORD=password  \
  -e PORT=3000 \
  -v $HOME/Workspace/code-server \
  codercom/code-server:latest
```

## Install k8s

## Use Docker Compose
Create .env file
```
CODEUSER=<username>
PASSWORD=<password>
PORT=<port>
TZ=Asia/Tokyo
PUID=1000
PGID=1000
```

```
docker compose up -d
```

## Deploy Azure App Service


## Deploy Helm
```
export KUBECONFIG=$HOME/Downloads/okteto-kube.config:${KUBECONFIG:-$HOME/.kube/config}
mkdir helm
git init
git config core.sparsecheckout true
git sparse-checkout init
git sparse-checkout set /ci/helm-chart
git sparse-checkout list
git remote add origin https://github.com/coder/code-server.git
git pull origin main
helm upgrade --install code-server ci/helm-chart --set persistence.enabled=false
echo $(kubectl get secret --namespace koooota code-server -o jsonpath="{.data.password}" | base64 --decode)
kubectl port-forward --namespace koooota service/code-server 8080:http
```

## 参考イメージ
https://github.com/linuxserver/docker-code-server
https://github.com/coder/code-server
