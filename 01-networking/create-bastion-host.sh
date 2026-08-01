#!/bin/bash
# ==============================================================================
# Arkitektur: Secure Remote Access (Azure Bastion)
# Beskrivning: Skapar ett dedikerat Bastion-subnät och en Bastion Host för att
#              nätverkssäkert ansluta till VMs direkt via webbläsaren.
# ==============================================================================

RG="rg-enterprise-demo"
REGION="northeurope"
VNET="vnet-nordicrent"
BASTION_NAME="bastion-nordicrent"
PUBLIC_IP_NAME="pip-bastion"

echo "1. Skapar subnätet AzureBastionSubnet (måste heta exakt så)..."
az network vnet subnet create \
  --resource-group $RG \
  --vnet-name $VNET \
  --name "AzureBastionSubnet" \
  --address-prefixes 10.0.3.0/26

echo "2. Skapar publik IP-adress för Bastion-tjänsten..."
az network public-ip create \
  --resource-group $RG \
  --name $PUBLIC_IP_NAME \
  --sku Standard \
  --location $REGION

echo "3. Rullar ut Azure Bastion Host (Detta kan ta 5-10 minuter för Azure)..."
az network bastion create \
  --resource-group $RG \
  --name $BASTION_NAME \
  --public-ip-address $PUBLIC_IP_NAME \
  --vnet-name $VNET \
  --location $REGION

echo "Bastion rullar ut i bakgrunden! Redo för säker RDP/SSH-anslutning."