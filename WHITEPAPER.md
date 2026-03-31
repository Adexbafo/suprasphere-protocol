SupraSphere Protocol
A Decentralized Identity-Native Social Infrastructure on Supra
1. Abstract
SupraSphere Protocol is a decentralized identity‑native social infrastructure built on the Supra blockchain using Move.

It introduces:

SSIN‑01 (SupraSphere Identity Number) — one wallet, one identity.
A fee‑based registration mechanism using SUPRA.
Upgrade-compatible modular architecture.
A treasury-driven economic model.
A foundation for future MiniApps and intelligent agents.
SupraSphere is not just an application — it is a protocol layer for decentralized social coordination.

2. Problem Statement
Modern social platforms suffer from:

Centralized identity control
Account duplication and spam
Data ownership opacity
Monetization capture by corporations
Closed platform ecosystems
SupraSphere solves these by:

Making identity on-chain
Enforcing economic anti‑Sybil registration
Designing for upgrade compatibility
Enabling modular expansion
3. Identity Model (SSIN‑01)
Core Principles
One wallet → One profile
Identity is wallet‑bound
Profile creation requires economic commitment
Reputation accumulates over time
Upgrade-safe storage model
SSIN Structure
struct SSIN {
    id: u64
}
Profile Structure
struct Profile {
    username: vector<u8>,
    reputation: u64,
    created_at: u64
}
Registry Structure
struct Registry {
    counter: u64
}
4. Economic Registration Model
Registration Fee
Fixed: 1000 SUPRA
Paid before calling
register()
Recorded via
treasury::record_fee()
Anti-Sybil Mechanism
The registration fee creates:

Economic cost per identity
Natural deterrence against spam
Scarcity of identity
5. Treasury Model
struct Treasury {
    total_collected: u64
}
Treasury tracks:

Total SUPRA collected from registrations
Future uses:

Protocol-owned liquidity
Governance incentives
SSOC ecosystem funding
6. Upgrade Policy
SupraSphere uses:

upgrade_policy: compatible
This ensures:

No storage-breaking upgrades
Struct layout preservation
Predictable protocol evolution
Future modules are added additively.

7. Username & Domain Model
Current version:

Username stored as
vector<u8>
One profile per wallet
Future extension:

struct Profile {
    username: vector<u8>,
    domain: vector<u8>, // .supra support
    reputation: u64,
    created_at: u64
}
Domain ownership validation handled at application layer.

8. Future Extensions
8.1 SuperTinyApp Framework
A modular MiniApp ecosystem allowing:

Third‑party social extensions
On-chain app registration
Staked app deployment
Revenue sharing
8.2 Sphere Agent
An off-chain intelligence engine:

Monitors posts
Calculates reputation
Flags spam
Feeds governance metrics
9. Roadmap
Phase 1:

Identity core ✅
Treasury accounting ✅
Registration economics ✅
Phase 2:

Username uniqueness (table-based)
Space (Channel) module
Staking model
Phase 3:

SSOC token
Governance
MiniApp registry
Phase 4:

Sphere AI Agent
Full mobile client
10. Vision
SupraSphere aims to become:

Supra’s identity layer
Supra’s social graph
Supra’s MiniApp platform
A decentralized social coordination infrastructure

