#!/bin/bash
# ==============================================================================
# Arkitektur: Virtual Desktop / Compute
# Beskrivning: Skapar en Windows 11 Pro-dator i North Europe med RDP-åtkomst
# ==============================================================================

RG="rg-windows11-test"
REGION="northeurope"
VM_NAME="win11-anstalld"

echo "1. Skapar resursgruppen..."
az group create --name $RG --location $REGION

echo "2. Skapar Windows 11-datorn..."
az vm create \
  --resource-group $RG \
  --name $VM_NAME \
  --image "MicrosoftWindowsDesktop:windows-11:win11-24h2-pro:latest" \
  --size "Standard_B2s" \
  --admin-username nordicadmin \
  --admin-password "ProffsDator2026!" \
  --public-ip-sku Standard

echo "3. Öppnar porten för Fjärrskrivbord (3389)..."
az vm open-port --resource-group $RG --name $VM_NAME --port 3389

echo "Klart! IP-adress för inloggning:"
az vm list-ip-addresses --resource-group $RG --name $VM_NAME --output table