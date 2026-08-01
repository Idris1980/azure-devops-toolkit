#!/bin/bash
# ==============================================================================
# Arkitektur: Centralized Observability & Logging
# Beskrivning: Skapar ett Log Analytics Workspace dit alla servrar, appar och
#              brandväggar skickar loggar för övervakning och felsökning.
# ==============================================================================

RG="rg-enterprise-demo"
REGION="northeurope"
WORKSPACE_NAME="law-nordicrent-$RANDOM"

echo "1. Skapar centralt Log Analytics Workspace ($WORKSPACE_NAME)..."
az monitor log-analytics workspace create \
  --resource-group $RG \
  --workspace-name $WORKSPACE_NAME \
  --location $REGION \
  --sku PerGB2018

echo "2. Hämtar Workspacets unika ID för koppling av framtida servrar..."
LAW_ID=$(az monitor log-analytics workspace show --resource-group $RG --workspace-name$WORKSPACE_NAME --query id --output tsv)

echo "------------------------------------------------------------------"
echo " LOG ANALYTICS REDO!"
echo " Workspace ID : $LAW_ID"
echo "------------------------------------------------------------------"