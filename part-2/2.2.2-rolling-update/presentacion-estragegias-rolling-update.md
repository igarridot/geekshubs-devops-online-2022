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
![bg opacity:.2](https://media.giphy.com/media/Aff4ryYiacUO4/giphy.gif)
# Rolling Update

---
# Rolling Update

Reemplazo progresivo de la versión.

Tengo 3 réplicas. Cambio una de las _antiguas_ por una de la nueva.
Luego otra y así hasta tener todas reemplazadas.

```
AAA
BAA
BBA
BBB
```

---
# Rolling Update

- Si nuestra aplicación está preparada para trabajar con múltiples réplicas.
- Si los cambios introducidos no _rompen_ y ambas versiones pueden convivir.

---
# Rolling Update

- Sin _downtime_
- Cambio incremental, menos riesgo.
- Poder parar el cambio sin afectar al 100% de los usuarios.

---
# Rolling Update

`vagrant up --provision-with microk8s`

`vagrant ssh`

---
![bg auto opacity:.2](https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Kubernetes_logo_without_workmark.svg/1200px-Kubernetes_logo_without_workmark.svg.png)
# Rolling Update

---
# Rolling Update

_if_ vagrant -> Vamos a copiar los ficheros a la carpeta `/home` dentro de la máquina virtual.

```
cp -a /vagrant/part-2/ .
```

Y cambiamos al directorio de este apartado:

```
cd part-2/2.2.2-rolling-update
```

---
# Rollig Update

Vamos a crear las imágenes de Docker necesarias primero:

- `sudo docker build -t lb:v1 -f Dockerfile-lb .`
- `sudo docker build -t myapp:v1 -f Dockerfile-myapp .`
- Modificamos `index.html` y:
- `sudo docker build -t myapp:v2 -f Dockerfile-myapp .`

Y comprobamos con:

`sudo docker images`

---
# Rolling Update

**ATENCIÓN**: Este paso únicamente es por usar `microk8s`.

Vamos a copiarle las imágenes de docker a kubernetes para que las "encuentre".

```
sudo docker save myapp:v1 > myapp:v1.tar
sudo docker save myapp:v2 > myapp:v2.tar
sudo docker save lb:v1 > lb:v1.tar
sudo microk8s.ctr image import myapp:v1.tar
sudo microk8s.ctr image import myapp:v2.tar
sudo microk8s.ctr image import lb:v1.tar
```

---
# Rolling Update

Es hora de desplegar nuestra aplicación. Primero la `v1`.

`kubectl -n default apply -f myapp.yml`

Y luego exponerla mediante el balanceador:

`kubectl apply -f lb.yml`

---
# Rolling Update

`kubectl get services`
`kubectl get pod`
`kubectl get deployment`

---
# Rolling Update

Ahora vamos a deplegar nuestra versión `v2`.

- `kubectl edit deploy myapp`

y sustituimos `v1` por `v2` en el `tag` de la imagen del contenedor.

---
![bg opacity:.2](https://imagenes.20minutos.es/files/image_656_370/uploads/imagenes/2019/05/21/957237.jpg)
# Rolling Update

---
# Rolling Update

- Sin _downtime_
- Implementación de moderada dificultad.

---
# Rolling Update

Ejercicio:

- Construir v3 y desplegarla.
