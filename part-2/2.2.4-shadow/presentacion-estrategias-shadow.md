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
![bg opacity:.2](https://66.media.tumblr.com/35767e66058164ec09bcd823c2a0868a/tumblr_n78rw4FsRC1tebgrfo2_500.gif)
# Shadow

---
# Shadow
![bg h:500](https://image.slidesharecdn.com/wso2conasia2018microservicescontainersandbeyond-180810094628/95/wso2con-asia-2018-microservices-containers-and-beyond-19-638.jpg?cb=1533894559)

---
# Shadow

- No afecta al tráfico de producción.
- No es exactamente un despliegue.

---
# Shadow

```
vagrant up --provision-with microk8s
vagrant ssh
cp -a /vagrant/part-2/ .
cd part-2/2.2.4-shadow/
```

---
# Shadow

Vamos a crear las imágenes de Docker necesarias primero:

- `sudo docker build -t fourth-lb:v1 -f Dockerfile-fourth-lb .`
- `sudo docker build -t fourth-app:v1 -f Dockerfile-fourth-app .`
- Modificamos `index.html` y:
- `sudo docker build -t fourth-app:v2 -f Dockerfile-fourth-app .`

---
# Shadow

**ATENCIÓN**: Este paso únicamente es por usar `microk8s`.

Vamos a copiarle las imágenes de docker a kubernetes para que las "encuentre".

```
sudo docker save fourth-app:v1 > fourth-app:v1.tar
sudo docker save fourth-app:v2 > fourth-app:v2.tar
sudo docker save fourth-lb:v1 > fourth-lb:v1.tar
microk8s.ctr image import fourth-app:v1.tar
microk8s.ctr image import fourth-app:v2.tar
microk8s.ctr image import fourth-lb:v1.tar
```

---
# Shadow

Vamos a desplegar la infraestructura

`kubectl -n default apply -f fourth-app.yml`

Y luego exponerla mediante el balanceador:

`kubectl apply -f fourth-lb.yml`

---
# Shadow

Utilizamos `goreplay` como _sidecar_ de nginx para hacer _forward_ de las requests a `v2`.

```
- name: goreplay
    image: iam404/goreplay:v1.0.0_x64
    args: ["--input-raw", ":80",  "--output-http", "fourth-app-v2.default:9000"]
```

---
# Shadow

Veamos el shadow en acción:

- `kubectl logs -f fourth-app-v2-xxxx`
- `kubectl logs -f fourth-app-v1-xxxx`

y hagamos peticiones:

- `curl -s serviceIP`

---
![bg opacity:.2](https://imagenes.20minutos.es/files/image_656_370/uploads/imagenes/2019/05/21/957237.jpg)
# Shadow

---
# Shadow

- Para pruebas en las que no queramos comprometer al usuario.
- Implementación algo más elaborada.
- Requiere de software extra (goreplay en nuestro ejemplo).

---
# Shadow

Ejercicio:

- Construir v3 y hacer shadow de `v1` a `v2` y `v3`
