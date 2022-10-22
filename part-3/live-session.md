# Construir un Devops pipeline

## Levantar un nuevo clúster de Kubernetes (con Kind)

:warning: Lanza el comando desde la raíz del repositorio :warning:

`./kind/cluster.sh`

## Instalar software que necesitaremos

:warning: Cambia al directorio del ejercicio :warning:
```
cd part-3/
```

1) `kubectl apply -f manifests/gogs.yml`
2) `kubectl apply -f manifests/jenkins-sa.yml`
3) `kubectl apply -f manifests/jenkins.yml`


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

