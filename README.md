# Nomad CSI NFS Volume Implementation

## Project Overview

This project demonstrates the implementation of persistent storage for HashiCorp Nomad workloads using the CSI (Container Storage Interface) NFS plugin.

The implementation provisions an NFS-backed CSI volume, deploys an NGINX application that consumes the volume, and validates persistent storage by confirming that data survives application restarts.

---

## Objectives

- Deploy HashiCorp Nomad
- Configure Docker runtime
- Configure an NFS server
- Deploy the Nomad CSI NFS plugin
- Register an NFS-backed CSI volume
- Deploy an application using persistent storage
- Validate data persistence after application restart

---

## Technologies Used

- HashiCorp Nomad
- Docker
- NFS Server
- CSI (Container Storage Interface)
- Ubuntu (WSL2)
- Linux CLI
- Git
- GitHub

---

## Project Structure

```
nomad-project/
│
├── app.nomad
├── nginx.nomad
├── nginx2.nomad
├── nfs-csi-plugin.nomad
├── volume.hcl
├── screenshots/
└── README.md
```

---

## Implementation Steps

### 1. Installed Nomad

Configured the Nomad server and client for local development.

---

### 2. Installed Docker

Configured Docker as the container runtime for Nomad.

---

### 3. Configured NFS Server

Created the shared directory:

```
/srv/nomad-storage
```

Configured exports and verified successful NFS mounting.

---

### 4. Deployed CSI Plugin

Registered the NFS CSI plugin with Nomad.

Verified:

- Healthy controller
- Healthy node plugin

---

### 5. Registered CSI Volume

Created an NFS-backed CSI volume using:

```
volume.hcl
```

Volume capability:

- multi-node-multi-writer
- file-system

---

### 6. Deployed NGINX

Configured Nomad job:

- CSI volume
- Volume mount
- Docker driver
- NGINX container

---

### 7. Storage Validation

Created a file inside the mounted volume:

```
echo "Persistent Data" > /usr/share/nginx/html/test.txt
```

Stopped the application.

Redeployed the application.

Verified:

```
cat /usr/share/nginx/html/test.txt

Persistent Data
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

### Phase 5 — CSI Volume Integration 

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

This confirmed successful persistent storage.
952013d (Update README, documentation, screenshots and project files)

---

## Challenges Encountered

### Volume Max Claims Reached

Initially the deployment failed because the CSI volume was configured as:

```
single-node-writer
```

which prevented additional allocations from claiming the volume.

### Resolution

Updated the volume configuration to:

```
access_mode = "multi-node-multi-writer"
```

Recreated the volume and successfully redeployed the workload.

---

## Validation Results

| Test | Status |
|------|--------|
| Nomad Installation |  Passed |
| Docker Runtime |  Passed |
| NFS Server | Passed |
| CSI Plugin Deployment | Passed |
| Volume Registration |  Passed |
| Application Deployment | Passed |
| Volume Mount |  Passed |
| Persistent Storage Validation |  Passed |

---

## Screenshots

Include screenshots for:

- Nomad server running
- CSI plugin healthy
- Volume registration
- NGINX deployment
- Persistent Storage Validation Success
- GitHub repository

---

## Repository

GitHub:

https://github.com/feranzeey/nomad-csi-nfs-volume-implementation

---

## Outcome

Successfully implemented persistent storage for Nomad workloads using the NFS CSI plugin and validated data persistence across workload redeployments.

---

## Author

**Oluwaferanmi Emmanuel**

DevOps Engineer 

GitHub: https://github.com/feranzeey

DevOps Engineer
952013d (Update README, documentation, screenshots and project files)
