# CampusNetShield — Secure Campus Network Using Cisco Packet Tracer

A mini-project that designs and secures a small campus network using **Cisco Packet Tracer**. The simulated topology connects two IPv4 LANs through a Cisco router and applies basic device and switch-port security controls.

## Project Objectives

- Design a two-subnet campus network with router and switch connectivity.
- Configure IPv4 addresses and default gateways.
- Protect device access using console passwords and `enable secret`.
- Enable SSH version 2 for encrypted remote administration.
- Configure switch port security using sticky MAC address learning.
- Disable unused switch ports and inspect security-related configurations.

## Network Topology

The design uses **one Cisco 2911 router (R1), two Cisco 2960 switches (S1 and S2), and six PCs**.

```text
                       R1 (Cisco 2911)
                      /               \
         G0/0: 192.168.10.1     G0/1: 192.168.20.1
                   |                       |
             S1 (Cisco 2960)        S2 (Cisco 2960)
              /    |    \             /    |    \
            PC1   PC2   PC3          PC4   PC5   PC6

             LAN 1: 192.168.10.0/24   LAN 2: 192.168.20.0/24
```

Each switch connects to its three PCs via `Fa0/1`–`Fa0/3`. Router-to-switch links use `G0/0` → `S1 G0/1` and `G0/1` → `S2 G0/1`.

## IP Addressing Plan

| Device / Interface | IP Address | Default Gateway |
|---|---|---|
| R1 G0/0 | `192.168.10.1/24` | — |
| R1 G0/1 | `192.168.20.1/24` | — |
| S1 VLAN 1 | `192.168.10.2/24` | `192.168.10.1` |
| S2 VLAN 1 | `192.168.20.2/24` | `192.168.20.1` |
| PC1 | `192.168.10.10/24` | `192.168.10.1` |
| PC2 | `192.168.10.11/24` | `192.168.10.1` |
| PC3 | `192.168.10.12/24` | `192.168.10.1` |
| PC4 | `192.168.20.10/24` | `192.168.20.1` |
| PC5 | `192.168.20.11/24` | `192.168.20.1` |
| PC6 | `192.168.20.12/24` | `192.168.20.1` |

All PCs use the subnet mask `255.255.255.0`.

## Security Features

| Feature | Purpose |
|---|---|
| Console password | Restricts local console login |
| `enable secret` | Protects privileged EXEC access |
| `service password-encryption` | Obfuscates applicable plaintext passwords in the configuration; **not strong cryptographic security** |
| SSH v2 | Encrypts remote device administration |
| Sticky MAC port security | Learns and restricts the allowed MAC address on a switch port |
| Violation mode `shutdown` | Disables a port when a port-security violation occurs |
| Unused-port shutdown | Reduces opportunities for unauthorized device connections |

## Implementation Overview

1. **Build the topology:** Add the router, switches, and six PCs; connect them using copper straight-through cables.
2. **Configure R1:** Set the hostname, assign IP addresses to `G0/0` and `G0/1`, and enable the interfaces with `no shutdown`.
3. **Secure device access:** Configure console access, `enable secret`, and password obfuscation.
4. **Enable SSH:** Set domain `campus.local`, create a local administrator account, generate RSA keys, enable SSH v2, and configure VTY lines with `login local` and `transport input ssh`.
5. **Configure S1 and S2:** Set hostnames, management IPs on VLAN 1, default gateways, login security, and SSH access.
6. **Apply port security:** On PC-facing ports (`Fa0/1`–`Fa0/3`), use access mode, a maximum of one secure MAC address, sticky learning, and shutdown on violation.
7. **Configure the PCs:** Assign static IPv4 addresses and default gateways as shown above.
8. **Inspect and save:** Review connectivity and security, shut down unused `Fa0/4`–`Fa0/24` ports, and save configurations with `copy running-config startup-config`.

### Example verification commands

```cisco
show ip interface brief
show port-security
show port-security address
show running-config
copy running-config startup-config
```

## Testing Checklist

The project report identifies these checks. **Record pass/fail results after running each test**; not all results are confirmed by the available screenshots.

- [ ] Ping R1 (`192.168.10.1`) from PC1.
- [ ] Ping PC4 (`192.168.20.10`) from PC1 to check inter-LAN connectivity.
- [ ] Test SSH from PC1 to S1 (`192.168.10.2`).
- [ ] Test SSH from PC1 to R1 (`192.168.10.1`).
- [ ] Test SSH from PC4 to S2 (`192.168.20.2`).
- [ ] Inspect switch port security and learned MAC addresses.
- [ ] Demonstrate an unauthorized MAC-address port-security violation.
- [ ] Confirm unused switch ports are shut down.

## Implementation Evidence

The project report includes screenshots of:

- Switch interface status
- A port-security violation and recovery commands
- The Packet Tracer topology
- Router interface configuration and status
- Additional router and switch status output

These screenshots document configuration activity, but do not independently establish that every ping or SSH test succeeded.

> **Tip:** If you add screenshots to your repository, place them under an `images/` folder and link them here. You can also include your `.pkt` simulation file so others can inspect the topology.

## Tools and Technologies

- Cisco Packet Tracer
- Cisco 2911 router and Cisco 2960 switches
- IPv4 routing and addressing
- Cisco IOS CLI
- SSH v2 and switch port security

## Conclusion

CampusNetShield demonstrates how to design a small two-LAN campus network while applying foundational network-device security. It combines IPv4 connectivity, secure remote administration, access protection, switch port security, and practical configuration verification.

## Disclaimer

This is an **educational simulation** for learning networking and security fundamentals, not a production-ready campus security architecture.
