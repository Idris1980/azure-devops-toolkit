# Enterprise Zero-Trust Azure Infrastructure Toolkit 🚀

Detta repository innehåller färdiga, produktionsredo DevOps-mallar för Azure, skapade med **Azure CLI (Bash)** och **Bicep (IaC)**. Syftet med arkitekturen är att implementera principen om **Zero Trust** samt automatisera molnresurser enligt Microsoft Well-Architected Framework.

---

## 🏛️ Arkitekturöversikt

Arkitekturen bygger på att **inga databaser eller lagringskonton exponeras publikt på Internet**. Kommunikationen mellan applikationstjänster och datalager sker via isolerade virtuella nätverk och privata tunnlar.

```text
[ INTERNET / KUND ]
       │  (HTTPS - Port 443)
       ▼
┌────────────────────────────────────────────────────────┐
│ AZURE VIRTUAL NETWORK (VNet)                           │
│                                                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │ Subnät A: "snet-webapp" (App Service Delegation) │  │
│  └──────────────────────────────────────────────────┘  │
│        │  (Intern tunnel - inget publikt API)          │
│        ▼                                               │
│  ┌──────────────────────────────────────────────────┐  │
│  │ Subnät B: "snet-database" (Private Endpoint)     │  │
│  └──────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────┘
       │
       ▼
 [ AZURE SQL DATABASE ]  <-- (Publik åtkomst: 100% AVSTÄNGD!)