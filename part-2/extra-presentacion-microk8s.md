---
theme: gaia
_class: lead
paginate: false
backgroundColor: #e7252f
backgroundImage: url('./../img/background-white.png')
color: #e7252f
marp: true
---
<!-- _backgroundImage: url('./../img/background-red.png') -->
<!-- _color: white -->
---
![bg opacity:.2](https://repository-images.githubusercontent.com/132732601/e3882d80-e367-11e9-8177-a6d5ec3eaff3)

---
# MicroK8s

- Micro distribución de Kubernetes by Canonical (Ubuntu)

---
# Instalación

`sudo snap install microk8s --classic`

---
# Comandos útiles

- `kubectl` -> Herramienta de control de Kuberntes

Kubectl cheatsheet -> https://kubernetes.io/docs/reference/kubectl/cheatsheet/

---
# Demo con vagrant

`vagrant up --provision-with microk8s`
