// =============================================================================
// Arkitektur: Azure Kubernetes Service (AKS)
// Beskrivning: Skapar ett grundläggande K8s-kluster för test och utveckling
// =============================================================================

param location string = 'northeurope'
param clusterName string = 'aks-nordicrent-test'

resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-10-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned' // Azure hanterar säkerhetsidentiteten automatiskt
  }
  properties: {
    dnsPrefix: 'aks-nordic'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1 // Vi startar med en enda server (nod) i klustret
        vmSize: 'Standard_B2s' // Liten och billig storlek för labbmiljö
        mode: 'System'
      }
    ]
  }
}
