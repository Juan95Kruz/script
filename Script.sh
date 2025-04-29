#!/bin/bash

# -------------------------------------------
# Script: deploy.sh
# Despliegue automatico - 0505AT - Script de Despliegue - ITU UNCuyo
# Autor: Juan Cruz (Con ayudita de ChanguITU)
# Fecha: 2025-04-28
# Descripcion: Automatiza el despliegue de una web estatica en Minikube
# -------------------------------------------

# --- Fail fast ---
set -euo pipefail

# --- Configuracion ---
WORKDIR="${1:-$HOME/Trabajo-Cloud}"
REPO_WEB="https://github.com/Juan95Kruz/static-website.git"
REPO_INFRA="https://github.com/Juan95Kruz/Infraestructura.git"
MOUNT_SOURCE="$WORKDIR/static-website"
MOUNT_TARGET="/mnt/web"
MANIFESTS_DIR="$WORKDIR/Infraestructura/k8s-manifiestos"

# --- Funciones auxiliares ---
function validar_dependencias() {
    echo "🔍 Validando dependencias..."
    for cmd in git minikube kubectl; do
        if ! command -v "$cmd" &>/dev/null; then
            echo "❌ Error: '$cmd' no encontrado. Instalalo antes de continuar."
            exit 1
        fi
    done
}

function clonar_repositorios() {
    echo "📥 Clonando repositorios..."
    mkdir -p "$WORKDIR"
    cd "$WORKDIR"

    if [ ! -d "static-website" ]; then
        git clone "$REPO_WEB"
    else
        echo "📂 Repositorio 'static-website' ya existe, omitiendo clonado."
    fi

    if [ ! -d "Infraestructura" ]; then
        git clone "$REPO_INFRA"
    else
        echo "📂 Repositorio 'Infraestructura' ya existe, omitiendo clonado."
    fi
}

function iniciar_minikube() {
    echo "🚀 Iniciando Minikube..."
    if ! minikube status &>/dev/null; then
        minikube start --driver=docker --mount --mount-string="$MOUNT_SOURCE:$MOUNT_TARGET"
    else
        echo "⚙️ Minikube ya está corriendo."
    fi
}

function aplicar_manifiestos() {
    echo "📜 Aplicando manifiestos de Kubernetes..."
    kubectl apply -f "$MANIFESTS_DIR/volumenes/pv.yaml"
    kubectl apply -f "$MANIFESTS_DIR/volumenes/pvc.yaml"
    kubectl apply -f "$MANIFESTS_DIR/deployment/deployment.yaml"
    kubectl apply -f "$MANIFESTS_DIR/service/service.yaml"
    kubectl apply -f "$MANIFESTS_DIR/ingress/ingress.yaml"
}

function habilitar_ingress() {
    echo "🌐 Verificando estado del addon Ingress..."

    if minikube addons list | grep ingress | grep -q enabled; then
        echo "✅ El addon 'ingress' ya está habilitado."
    else
        echo "🚀 Habilitando el addon 'ingress' en Minikube..."
        minikube addons enable ingress
    fi
}

function esperar_ingress_ready() {
    echo "⏳ Esperando que el Ingress Controller esté listo..."

    # Esperar hasta que el deployment del Ingress esté disponible
    kubectl rollout status deployment ingress-nginx-controller -n ingress-nginx --timeout=120s

    echo "✅ Ingress Controller listo."
}

function mostrar_url() {
    echo "🌐 Configurando acceso a sitio.local..."

    IP_MINIKUBE=$(minikube ip)

    # Verificar si ya existe una entrada para sitio.local
    if grep -q "sitio.local" /etc/hosts; then
        echo "⚙️ 'sitio.local' ya existe en /etc/hosts. No se modifica."
    else
        echo "🔧 Agregando 'sitio.local' a /etc/hosts..."
        echo "$IP_MINIKUBE sitio.local" | sudo tee -a /etc/hosts
        echo "✅ Agregado exitosamente."
    fi

    echo ""
    echo "🔗 Tu sitio web estatico esta disponible en:"
    echo "👉 http://sitio.local/"
}

# --- Ejecucion ---

echo "🌟 Script de despliegue iniciado..."

validar_dependencias
clonar_repositorios
iniciar_minikube
habilitar_ingress
esperar_ingress_ready
aplicar_manifiestos
mostrar_url

echo "✅ Despliegue completado exitosamente. ¡Listo para navegar!"

