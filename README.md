# Nomad CSI NFS Volume Implementation

## Overview

This project explores the implementation of Nomad CSI (Container Storage Interface) volumes using Network File System (NFS) as shared storage. The objective is to understand how Nomad provisions and manages persistent storage for containerized workloads using a network-attached storage backend.

The project includes research, environment setup, implementation, validation, troubleshooting, and documentation.

---

## Objectives

- Understand Nomad CSI architecture
- Configure an NFS server as shared storage
- Integrate NFS with Nomad CSI
- Deploy workloads using persistent volumes
- Validate volume attachment and persistence
- Document the implementation process and findings

---

## Technology Stack

- Ubuntu 24.04 LTS
- Nomad v1.11.2
- Docker
- NFS Server
- NFS Client
- Git
- GitHub

---

## Project Structure

```
nomad-csi-nfs-volume-implementation/
│
├── documentation/
│   ├── research.md
│   ├── implementation-report.md
│   └── troubleshooting.md
│
├── nomad-project/
│   ├── nginx.nomad
│   ├── volume.hcl
│   └── jobs/
│
├── screenshots/
│
└── README.md
```

---

## Progress

### Phase 1 — Research 

- Studied Nomad CSI architecture
- Reviewed CSI plugins
- Compared storage backends
- Selected NFS for implementation

---

### Phase 2 — Environment Setup 

Completed:

- Installed Ubuntu 24.04
- Installed Docker
- Installed Nomad
- Verified Nomad installation
- Started Nomad development agent

Verified:

```
nomad version
nomad server members
```

---

### Phase 3 — NFS Configuration 

Completed:

- Installed NFS server
- Installed NFS client
- Created shared directory
- Configured `/etc/exports`
- Exported NFS share
- Restarted NFS services
- Verified NFS server status

Example:

```
sudo systemctl status nfs-server
cat /etc/exports
```

---

### Phase 4 — Nomad Project Setup 

Completed:

- Created Nomad project directory
- Created job specification
- Created CSI volume configuration
- Initialized Git repository
- Connected GitHub repository
- Organized project documentation

---

### Phase 5 — CSI Volume Integration 🚧

Current work:

- Creating CSI volume
- Registering volume with Nomad
- Deploying workload
- Mounting NFS storage inside containers
- Troubleshooting Nomad CSI configuration

---

### Phase 6 — Validation (Upcoming)

Planned:

- Verify CSI volume registration
- Verify NFS mounts
- Deploy application
- Test persistent storage
- Restart allocation
- Validate data persistence

---

## Challenges Encountered

- WSL2 limitations for NFS server
- Nomad API connectivity troubleshooting
- Git authentication using GitHub Personal Access Token
- Remote repository synchronization
- CSI volume registration troubleshooting

---

## Lessons Learned

- Understanding Nomad CSI architecture
- Difference between host volumes and CSI volumes
- NFS server configuration
- Persistent storage concepts
- Nomad job lifecycle
- Git repository management
- Infrastructure troubleshooting

---

## Current Status

**Project Status:** In Progress

Completed:

- Research
- Environment Setup
- Nomad Installation
- Docker Installation
- NFS Server Configuration
- Git Repository Setup

Currently Working On:

- CSI Volume Creation
- Volume Registration
- Workload Deployment
- Storage Validation

---

## Next Steps

- Complete CSI volume registration
- Deploy application using NFS-backed storage
- Validate persistence after restart
- Capture implementation screenshots
- Complete final report
- Push completed project to GitHub

---

## References

- https://developer.hashicorp.com/nomad
- https://developer.hashicorp.com/nomad/docs/other-specifications/volume/csi
- https://developer.hashicorp.com/nomad/docs/job-specification
- https://kubernetes-csi.github.io/docs/

---

## Author

**Oluwaferanmi Dada**

DevOps Engineer 

GitHub: https://github.com/feranzeey