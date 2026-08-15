#!/usr/bin/env bash

set -e

echo "========================================"
echo " STT-DB - SQL Server Provisioning"
echo "========================================"

export DEBIAN_FRONTEND=noninteractive

echo "[1/5] Ubuntu aktualisieren..."
apt-get update || true

echo "[2/5] Benoetigte Pakete installieren..."
apt-get install -y \
    curl \
    wget \
    gnupg \
    apt-transport-https \
    software-properties-common

echo "[3/5] Microsoft Repository-Key installieren..."

rm -f /usr/share/keyrings/microsoft-prod.gpg
rm -f /etc/apt/trusted.gpg.d/microsoft.asc

curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
    -o /etc/apt/trusted.gpg.d/microsoft.asc

echo "[4/5] SQL Server 2022 Repository hinzufuegen..."

rm -f /etc/apt/sources.list.d/mssql-server-2022.list

curl -fsSL \
    https://packages.microsoft.com/config/ubuntu/22.04/mssql-server-2022.list \
    -o /etc/apt/sources.list.d/mssql-server-2022.list

echo "[5/5] SQL Server 2022 installieren..."

apt-get update
apt-get install -y mssql-server

echo
echo "========================================"
echo " SQL Server Paket wurde installiert."
echo "========================================"