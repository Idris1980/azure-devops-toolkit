#!/bin/bash
# ==============================================================================
# Arkitektur: Enterprise Zero-Trust Nätverk
# Beskrivning: Skapar VNet med isolerade subnät för App Service och Private Link
# ==============================================================================

# -- KONFIGURATION --
RG="rg-enterprise-demo"
REGION="northeurope"
VNET="vnet-nordicrent"

echo "1. Skapar resursgrupp och Virtual Network (VNet)..."
az group create --name $RG --location $REGION

az network vnet create \
  --resource-group $RG \
  --name $VNET \
  --address-prefix 10.0.0.0/16 \
  --location $REGION

echo "2. Skapar subnät för Webbappen (med stöd för VNet Integration)..."
az network vnet subnet create \
  --resource-group $RG \
  --vnet-name $VNET \
  --name "snet-webapp" \
  --address-prefixes 10.0.1.0/24 \
  --delegations "Microsoft.Web/serverFarms"

echo "3. Skapar subnät för Databasens Private Endpoint..."
az network vnet subnet create \
  --resource-group $RG \
  --vnet-name $VNET \
  --name "snet-database" \
  --address-prefixes 10.0.2.0/24

echo "4. Skapar Private DNS Zone för Azure SQL..."
az network private-dns zone create \
  --resource-group $RG \
  --name "privatelink.database.windows.net"

echo "5. Kopplar DNS-zonen till vårt VNet..."
az network private-dns link vnet create \
  --resource-group $RG \
  --zone-name "privatelink.database.windows.net" \
  --name "dns-link-nordicrent" \
  --virtual-network $VNET \
  --registration-enabled false

echo "Klart! Lista över skapade subnät:"
az network vnet subnet list --resource-group $RG --vnet-name $VNET --output table