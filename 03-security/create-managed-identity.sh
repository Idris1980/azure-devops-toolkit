#!/bin/bash
# ==============================================================================
# Arkitektur: Enterprise Security & IAM (Entra ID / RBAC)
# Beskrivning: Skapar en User-Assigned Managed Identity som fungerar som en
#              lösenordslös "ID-bricka" för webbappar mot interna resurser.
# ==============================================================================

# -- KONFIGURATION --
RG="rg-enterprise-demo"
REGION="northeurope"
IDENTITY_NAME="id-nordicrent-app"

echo "1. Skapar en User-Assigned Managed Identity ($IDENTITY_NAME)..."
az identity create \
  --resource-group $RG \
  --name $IDENTITY_NAME \
  --location $REGION

echo "2. Hämtar identitetens unika ID-uppgifter från Microsoft Entra ID..."
CLIENT_ID=$(az identity show --resource-group $RG --name $IDENTITY_NAME --query clientId --output tsv)
PRINCIPAL_ID=$(az identity show --resource-group $RG --name $IDENTITY_NAME --query principalId --output tsv)
ID_RESOURCE=$(az identity show --resource-group $RG --name $IDENTITY_NAME --query id --output tsv)

echo "------------------------------------------------------------------"
echo " IDENTITET SKAPAD MED FRAMGÅNG!"
echo " Client ID    : $CLIENT_ID"
echo " Principal ID : $PRINCIPAL_ID"
echo " Resource ID  : $ID_RESOURCE"
echo "------------------------------------------------------------------"

# ==============================================================================
# ARKITEKT-NOTERING: HUR DU KOPPLAR DENNA ROLLER I FRAMTIDEN (RBAC)
# ==============================================================================
# I Azure tilldelar vi behörigheter med kommandot "az role assignment create".
#
# Exempel: Ge denna identitet rollen "Reader" på hela resursgruppen:
#
# az role assignment create \
#   --assignee $PRINCIPAL_ID \
#   --role "Reader" \
#   --scope "/subscriptions/<din-prenumeration>/resourceGroups/$RG"
#
# I SQL Database lägger du sedan till denna identitet via SQL:
#   CREATE USER [id-nordicrent-app] FROM EXTERNAL PROVIDER;
#   ALTER ROLE db_datareader ADD MEMBER [id-nordicrent-app];
# ==============================================================================