---
theme: gaia
_class: lead
paginate: false
backgroundColor: #e7252f
backgroundImage: url('./../../img/background-white.png')
color: #e7252f
marp: true
---
<!-- _backgroundImage: url('./../../img/background-red.png') -->
<!-- _color: white -->

# 4 Desplegando Contenedores

---
![bg opacity:.2](https://media1.tenor.com/images/6c558a6366d2967e6de4ad294c3c4b7f/tenor.gif)
# Canary

---
![bg auto](https://www.tigera.io/wp-content/uploads/2018/12/canary-deployment-74d9ceb259a7b87beb0b5fc3af0e3788-e9535-1.png)

---
# Canary

- Sin _downtime_
- Nos permite probar con tráfico real la versión en un % del tráfico.
- Rollback inmediato.

---
# Canary

```
vagrant up --provision-with microk8s
vagrant ssh
cp -a /vagrant/part-2/ .
cd part-2/2.2.5-canary
```

---
# Canary

Vamos a crear las imágenes de Docker necesarias primero:

- `sudo docker build -t myapp:v1 -f Dockerfile-myapp .`
- Modificamos `index.html` y:
- `sudo docker build -t myapp:v2 -f Dockerfile-myapp .`

---
# Canary

**ATENCIÓN**: Este paso únicamente es por usar `microk8s`.

Vamos a copiarle las imágenes de docker a kubernetes para que las "encuentre".

```
sudo docker save myapp:v1 > myapp:v1.tar
sudo docker save myapp:v2 > myapp:v2.tar
microk8s.ctr image import myapp:v1.tar
microk8s.ctr image import myapp:v2.tar
```

---
# Canary

Vamos a desplegar la infraestructura

`kubectl -n default apply -f myapp.yml`

---

# Canary

Tenemos ahora 3 réplicas de `v1` y 1 réplica de `v2`. Esto significa que:
- 75% del tráfico va a recibir `v1`
- 25% del tráfico va a recibir `v2`

---
# Canary

Para ver los pods que están en un `label`.

`kubectl get pod -l app=myapp`

```
vagrant@ubuntu-bionic:~/canary$ kubectl get pod -l app=myapp
NAME                        READY   STATUS    RESTARTS   AGE
myapp-v1-6d9ddff5c6-259dp   1/1     Running   0          3m1s
myapp-v1-6d9ddff5c6-btx74   1/1     Running   0          3m1s
myapp-v1-6d9ddff5c6-njndx   1/1     Running   0          3m1s
myapp-v2-6c45c99f45-f2w2k   1/1     Running   0          3m1s
```

---
# Canary
- `kubectl get service myapp`
- `watch -d -n 1 'curl -s serviceIP'`

---
# Canary

Ahora podemos jugar con los % de cada una de las versiones.

- `kubectl scale deployment myapp-v2 --replicas=2`
- `kubectl scale deployment myapp-v1 --replicas=2`

Con estos cambios lo balanceamos 50/50

---
# Canary

Hasta finalmente:

- `kubectl scale deployment myapp-v2 --replicas=4`
- `kubectl scale deployment myapp-v1 --replicas=0`

---
![bg opacity:.2](https://imagenes.20minutos.es/files/image_656_370/uploads/imagenes/2019/05/21/957237.jpg)
# Canary

---
# Canary
- Sin _downtime_
- Implementación más laboriosa.
- Requiere madurez en el equipo para hacerlo de forma eficiente y teniendo en cuenta feedback sobre la versión nueva.
    - Ratio de errores
    - Rendimiento
    - Latencias
    - ...
- Riesgo bajo y controlado frente a fallos.

---
# Canary

Ejercicio:

- Construir v3 y desplegarla.
- Transicionar desde v1 a v2 y de v2 a v3 sin downtime.
- Hacer _downgrade_ de la versión v3 a la v2 sin downtime.
