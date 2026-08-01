// =============================================================================
// Arkitektur: Enterprise Zero-Trust Network i Bicep (Declarative IaC)
// Beskrivning: Mall som rullar ut VNet, subnät för Web/DB samt Private DNS.
// =============================================================================

param location string = 'northeurope'
param vnetName string = 'vnet-nordicrent-bicep'

// 1. Skapa det Virtuella Nätverket och Subnäten i ett svep
resource vnet 'Microsoft.Network/virtualNetworks@2023-09-01' = {
  name: vnetName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'snet-webapp'
        properties: {
          addressPrefix: '10.0.1.0/24'
          delegations: [
            {
              name: 'delegation-appservice'
              properties: {
                serviceName: 'Microsoft.Web/serverFarms'
              }
            }
          ]
        }
      }
      {
        name: 'snet-database'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}

// 2. Skapa Privat DNS-zon för Azure SQL
resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.database.windows.net'
  location: 'global'
}

// 3. Länka DNS-zonen till VNet
resource dnsLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: 'link-to-vnet'
  location: 'global'
  properties: {
    virtualNetwork: {
      id: vnet.id
    }
    registrationEnabled: false
  }
}