# Nomad, CSI & NFS — Research

## What is Nomad?

Nomad is a **workload orchestrator and scheduler** built by HashiCorp. You give it a declarative job spec (HCL or JSON) and it decides which nodes in a cluster should run the work, then keeps it running.

- Runs almost any workload type — Docker/Podman containers, raw binaries, Java, even QEMU VMs — via pluggable task drivers (broader than Kubernetes, which is container-only).
- Ships as a single, self-contained binary: one process acts as a **server** (scheduling decisions) or a **client** (runs tasks). No external DB needed for state.
- Uses **bin packing** to place jobs efficiently across CPU/memory, and self-heals by rescheduling failed tasks.
- Supports zero-downtime deploys (rolling, blue/green, canary) and spans multiple datacenters/regions/clouds in one cluster.
- Integrates naturally with Consul (service discovery) and Vault (secrets).

**In short:** simpler to operate than Kubernetes, at the cost of a smaller ecosystem — a common pick for mixed containerized + legacy workloads.

## What is CSI?

**CSI = Container Storage Interface**, an industry-standard gRPC API that lets any storage backend plug into any orchestrator that supports it (originally built for Kubernetes; Nomad adopted it too).

- Each provider (AWS EBS, AWS EFS, GCP Persistent Disk, Ceph, Portworx, etc.) ships its own **CSI plugin**. Because the interface is standardized, most Kubernetes CSI plugins also work with Nomad.
- Plugins run as Nomad jobs, in one of three roles:
  - **Controller** — calls the storage provider's API to create/attach/detach volumes (e.g., attach an EBS volume to the right EC2 instance).
  - **Node** — runs on every client node and does the actual mount/unmount (needs privileged/root access).
  - **Monolith** — does both.
- Volumes are registered/created as objects with an ID, a `plugin_id`, capacity, and `capability` blocks defining `access_mode` (single-node-writer, multi-node-multi-writer, etc.) and `attachment_mode` (file-system or block-device).
- Nomad's scheduler only places workloads needing a volume onto nodes that have the matching node plugin healthy and running.
- **Volumes can be added or removed from the cluster dynamically** — no Nomad client config changes or restarts required.

## What is NFS?

**NFS (Network File System)** is a client-server protocol that lets a machine mount a directory that physically lives on a remote server and use it as if it were local disk.

- An NFS server **exports** a directory; clients **mount** it over the network.
- Multiple hosts can mount the **same share concurrently** — the main reason it's useful for shared, multi-writer storage.
- Common in orchestration contexts (Nomad, Kubernetes) as the backing store for volumes, since a rescheduled allocation can reach the same data from a different node.
- Trade-offs: slower than local disk (network-bound), and a shared NFS server is a single point of failure/performance bottleneck for everything mounting it. Mount options should stay consistent across all clients.
- AWS EFS is essentially "NFS as a managed service" — it's exposed to Nomad/Kubernetes through a CSI plugin.

## Why CSI Instead of Host Volumes?

| | Host Volumes | CSI Volumes |
|---|---|---|
| Lifecycle management | Static host volumes are declared in the Nomad client's config file — adding or changing one means **editing config and restarting the client** | Created/removed on the fly via `nomad volume create`/`register` — **no client restart needed** |
| Nomad's visibility | Nomad just sees a path exists; it has **no idea** what backs it (local disk, NFS, GlusterFS, etc.) | Nomad tracks capacity, health, and capabilities through the plugin API |
| Portability across nodes | Tied to specific node(s) unless manually replicated | Provider-agnostic — same workflow for EBS, EFS, GCP PD, Ceph, Portworx |
| Migration on reschedule | Not native — the volume has to already exist on wherever the allocation lands | The controller plugin can attach the volume to whichever node the allocation is rescheduled to |
| Concurrency | Simple access modes, host-volume-specific | Rich `access_mode`/`attachment_mode` capability model, including shared multi-writer volumes |
| Operational cost | Low to set up, but inflexible to change; needs coordination between whoever configures Nomad clients and whoever owns the storage | Higher upfront (plugins must run continuously, need privileged access + provider credentials), but far more flexible long-term |

**Bottom line:** host volumes are fine for simple, static, node-local (or pre-mounted network) storage. CSI is the better choice once you need Nomad to **dynamically provision, attach, resize, or migrate** storage — which matters most in cloud environments and clusters where storage needs change often.

## Real-World Use Cases

- **Stateful databases (MySQL/Postgres) on AWS EBS** — HashiCorp's own reference tutorial deploys the AWS EBS CSI plugin, registers an EBS volume, and runs a MySQL container against it; data survives job restarts and can follow the allocation if it's rescheduled onto a different EC2 instance in the same AZ.
- **Shared persistent home directories via AWS EFS (NFS-backed)** — a documented pattern registers an EFS volume with `access_mode = "multi-node-multi-writer"` and mounts it into a Jenkins job as `/var/jenkins_home`; because EFS is NFS under the hood, config and job history persist across job purges/recreations, and multiple nodes could mount it at once.
- **CI/CD tooling with persistent state** — Jenkins, artifact repositories, or similar tools that need their working directory to survive redeploys are classic CSI candidates, since the volume outlives any single allocation.
- **Multi-cloud or hybrid storage strategies** — teams running Nomad across AWS, GCP, and on-prem can standardize storage operations across GCP Persistent Disks, EBS, and Ceph through the same CSI job-spec pattern, instead of hand-rolling per-provider mounting logic.
- **Environments with frequently changing storage needs** — CSI is explicitly recommended (over static host volumes) when persistent-storage requirements are added/removed often, since volumes attach/detach without touching Nomad client configuration.

*Sources: HashiCorp Developer docs (Nomad overview, CSI architecture & volume specs, Considerations for Stateful Workloads), HashiCorp CSI beta announcement blog, AWS EFS/EBS CSI plugin integration guides.*