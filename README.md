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
