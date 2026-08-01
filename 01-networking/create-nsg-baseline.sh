#!/bin/bash
# ==============================================================================
# Arkitektur: Enterprise Network Security Group (NSG) Baseline
# Beskrivning: Skapar en standardbrandvägg som blockerar obehörig Internet-
#              trafik men tillåter HTTPS (port 443) och intern VNet-trafik.
# ==============================================================================

RG="rg-enterprise-demo"
REGION="northeurope"
NSG_NAME="nsg-enterprise-baseline"

echo "1. Skapar brandvägg (NSG: $NSG_NAME)..."
az network nsg create \
  --resource-group $RG \
  --name $NSG_NAME \
  --location $REGION

echo "2. Skapar regel: Tillåt inkommande HTTPS (port 443) från Internet..."
az network nsg rule create \
  --resource-group $RG \
  --nsg-name $NSG_NAME \
  --name "Allow-HTTPS-Inbound" \
  --priority 100 \
  --source-address-prefixes "Internet" \
  --destination-port-ranges 443 \
  --access Allow \
  --protocol Tcp \
  --description "Tillater webbtrafik utifraan"

echo "3. Skapar regel: Blockera ALL annan inkommande trafik från Internet..."
az network nsg rule create \
  --resource-group $RG \
  --nsg-name $NSG_NAME \
  --name "Deny-All-Internet-Inbound" \
  --priority 4096 \
  --source-address-prefixes "Internet" \
  --destination-port-ranges "*" \
  --access Deny \
  --protocol "*" \
  --description "Zero Trust - blockera allt som inte ar explicit tillatet"

echo "Klart! Säkerhetsregler i brandväggen:"
az network nsg rule list --resource-group $RG --nsg-name$NSG_NAME --output table