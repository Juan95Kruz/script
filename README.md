
# Script de Despliegue Automático

## Descripción

Este script automatiza el despliegue de una página web estática en Minikube, utilizando Kubernetes para gestionar el entorno. Con este script puedes clonar los repositorios necesarios, configurar Minikube, habilitar el Ingress y aplicar los manifiestos de Kubernetes para que tu sitio web esté disponible de forma rápida y sencilla.

## Requerimientos

Este script requiere que tengas instaladas las siguientes dependencias:

- **git**: para clonar los repositorios de los proyectos.
- **minikube**: para iniciar el entorno local de Kubernetes.
- **kubectl**: para interactuar con el clúster de Kubernetes.

Puedes verificar si las tienes instaladas ejecutando el siguiente comando:

```bash
git --version
minikube version
kubectl version
```

### Puedes instalarlos con los siguientes comandos:

```bash
# Para instalar git
sudo apt-get install git

# Para instalar minikube
curl -Lo minikube.deb https://storage.googleapis.com/minikube/releases/latest/minikube_$(uname -m).deb
sudo dpkg -i minikube.deb

# Para instalar kubectl
sudo apt-get update && sudo apt-get install -y kubectl
```

## Instrucciones

1. **Dar permisos de ejecución**: Asegúrate de estar en el directorio donde se encuentra el archivo `Script.sh` y ejecuta el siguiente comando para otorgarle permisos de ejecución:

    ```bash
    chmod +x Script.sh
    ```

2. **Ejecutar el script**: Una vez que el archivo tenga permisos de ejecución, corre el script con el siguiente comando:

    ```bash
    ./Script.sh
    ```

   El script realizará lo siguiente:
   - Validará que las dependencias necesarias estén instaladas.
   - Clonará los repositorios `static-website` y `Infraestructura`.
   - Iniciará Minikube y configurará un entorno local.
   - Aplicará los manifiestos de Kubernetes para configurar los volúmenes, despliegue, servicio e ingreso.
   - Habilitará el addon de Ingress en Minikube, si no está habilitado.
   - Esperará que el Ingress Controller esté listo.
   - Configurará el acceso al sitio web a través de `sitio.local` en tu archivo `/etc/hosts`.

   Finalmente, el script te mostrará la URL para acceder a tu página web estática: `http://sitio.local/`.

## Nota

Este script está pensado para ser utilizado en un entorno de desarrollo local, con Minikube como clúster Kubernetes y la dirección `sitio.local` configurada en el archivo `hosts` de tu máquina.

---

¡Listo para desplegar tu sitio web estático en Minikube de forma rápida y sencilla! 🌐
