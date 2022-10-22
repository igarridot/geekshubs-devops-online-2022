# Construir un Devops pipeline

## Levantar la máquina virtual (con vagrant)

`vagrant up --provision-with microk8s`

## Instalar software que necesitaremos

1) `vagrant ssh`
2) `cp -ar /vagrant/part-3/manifests .`
3) `cp -ar /vagrant/part-3/acme-inc .`
4) `kubectl apply -f manifests/gogs.yml`
5) `kubectl apply -f manifests/jenkins-sa.yml`
6) `kubectl apply -f manifests/jenkins.yml`


## Configurar GOGS

URL -> http://192.168.56.10:3000

Seguir el wizard y crear un repositorio.
- Seleccionar SQLlite
- Como IP la que obteneis de `kubectl get svc`

## Configurar Jenkins

URL -> http://192.168.56.10:8000

1) `kubectl get pods`
2) `kubectl logs -f jenkins-xxxxx`
Extraer el token

Seguir el wizard.

Plugins adicionales:

- kubernetes
- blueocean (opcional)

### Configurar Kubernetes

Jenkins > Configuration

Add cloud:
- Kubernetes Namespace: default
- Jenkins URL: http://jenkins.default:8000

### Crear job

Crear nuevo _Multibranch pipeline_

