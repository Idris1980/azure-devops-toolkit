#!/bin/bash
# ==============================================================================
# Arkitektur: Enterprise Security - Azure Key Vault & Entra ID RBAC
# Beskrivning: Skapar ett säkert Key Vault (kassaskåp), aktiverar RBAC-styrning
#              och ger vår Managed Identity behörighet att läsa hemligheter.
# ==============================================================================

# -- KONFIGURATION --
RG="rg-enterprise-demo"
REGION="northeurope"
IDENTITY_NAME="id-nordicrent-app"

# Key Vault-namn måste vara GLOBALT unika (3-24 tecken, endast små bokstäver/siffror/bindestreck)
KV_NAME="kv-nordicrent-$RANDOM"

echo "1. Skapar Azure Key Vault ($KV_NAME) med RBAC-autentisering..."
az keyvault create \
  --resource-group $RG \
  --name $KV_NAME \
  --location $REGION \
  --enable-rbac-authorization true

echo "2. Skapar en testhämlighet i kassaskåpet..."
az keyvault secret set \
  --vault-name $KV_NAME \
  --name "StripeApiKey" \
  --value "sk_test_hemlig_nyckel_12345" \
  --output none

echo "3. Hämtar Principal ID för vår Managed Identity ($IDENTITY_NAME)..."
PRINCIPAL_ID=$(az identity show --resource-group $RG --name $IDENTITY_NAME --query principalId --output tsv)

echo "4. Tilldelar appen rollen 'Key Vault Secrets User' (Endast läsrättigheter)..."
KV_ID=$(az keyvault show --resource-group $RG --name $KV_NAME --query id --output tsv)

az role assignment create \
  --assignee $PRINCIPAL_ID \
  --role "Key Vault Secrets User" \
  --scope $KV_ID

echo "------------------------------------------------------------------"
echo " KEY VAULT REDO FÖR PRODUKTION!"
echo " Kassaskåpets namn : $KV_NAME"
echo " Låst till App-ID  : $PRINCIPAL_ID"
echo "------------------------------------------------------------------"