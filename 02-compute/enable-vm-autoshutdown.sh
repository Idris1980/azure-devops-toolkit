#!/bin/bash
# ==============================================================================
# Arkitektur: FinOps / Automation (Cost Optimization)
# Beskrivning: Konfigurerar automatisk avstängning på en virtuell dator
#              klockan 18:00 UTC varje dag för att spara pengar.
# ==============================================================================

RG="rg-windows11-test"
VM_NAME="win11-anstalld"
SHUTDOWN_TIME="1800" # Klockan 18:00 UTC
TIMEZONE="W. Europe Standard Time" # Stockholm/Paris time

echo "Aktiverar Auto-Shutdown kl 18:00 för datorn: $VM_NAME..."
az vm auto-shutdown \
  --resource-group $RG \
  --name $VM_NAME \
  --time $SHUTDOWN_TIME \
  --email "idris@nordicrent.se" \
  --webhook ""

echo "Auto-shutdown konfigurerat! En varning skickas via e-post innan avstängning."