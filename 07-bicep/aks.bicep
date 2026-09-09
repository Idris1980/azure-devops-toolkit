param location string = 'swedencentral'
param clusterName string = 'aks-nordicrent-test'

resource aksCluster 'Microsoft.ContainerService/managedClusters@2023-10-01' = {
  name: clusterName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    dnsPrefix: 'aks-nordic'
    agentPoolProfiles: [
      {
        name: 'agentpool'
        count: 1
        vmSize: 'Standard_B4as_v2'
        mode: 'System'
      }
    ]
  }
}
