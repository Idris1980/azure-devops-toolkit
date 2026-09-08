#!/bin/bash
# ==============================================================================
# Arkitektur: Enterprise SQL Database med Private Endpoint
# Beskrivning: Skapar Azure SQL Server + DB, stänger av publik brandvägg
#              och ansluter via Private Endpoint i snet-database.
# ==============================================================================
#Detta är ett test för min nya branch. Jag vill se om jag kan pusha ändringar till den.
# -- KONFIGURATION --
RG="rg-enterprise-demo"
REGION="northeurope"
VNET="vnet-nordicrent"
SUBNET="snet-database"
DNS_ZONE="privatelink.database.windows.net"

# För Azure SQL måste servernamnet vara helt unikt i hela världen (små bokstäver/siffror)
SQL_SERVER_NAME="sql-nordicrent-$RANDOM"
DB_NAME="rentalsdb"
ADMIN_USER="nordicadmin"
ADMIN_PASS="ProffsEnterprise2026!"

echo "1. Skapar Azure SQL Server ($SQL_SERVER_NAME)..."
az sql server create \
  --resource-group $RG \
  --name $SQL_SERVER_NAME \
  --location $REGION \
  --admin-user $ADMIN_USER \
  --admin-password $ADMIN_PASS \
  --enable-public-network false

echo "2. Skapar själva databasen ($DB_NAME)..."
az sql db create \
  --resource-group $RG \
  --server $SQL_SERVER_NAME \
  --name $DB_NAME \
  --service-objective Basic \
  --backup-storage-redundancy Local

echo "3. Skapar Private Endpoint i ditt subnät ($SUBNET)..."
az network private-endpoint create \
  --resource-group $RG \
  --name "pe-$SQL_SERVER_NAME" \
  --vnet-name $VNET \
  --subnet $SUBNET \
  --private-connection-resource-id $(az sql server show --resource-group $RG --name $SQL_SERVER_NAME --query id --output tsv) \
  --group-id "sqlServer" \
  --connection-name "conn-$SQL_SERVER_NAME" \
  --location $REGION

echo "4. Kopplar Private Endpoint till den privata DNS-zonen..."
az network private-endpoint dns-zone-group create \
  --resource-group $RG \
  --endpoint-name "pe-$SQL_SERVER_NAME" \
  --name "zone-group-sql" \
  --private-dns-zone $DNS_ZONE \
  --zone-name sql

echo "Klart! Databasens privata nätverkskonfiguration:"
az network private-endpoint show --resource-group $RG --name "pe-$SQL_SERVER_NAME" --query "customDnsConfigs" --output table