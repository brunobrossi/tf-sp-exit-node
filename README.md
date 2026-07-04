# terraform-sp

VM on Oracle Cloud São Paulo (`sa-saopaulo-1`) with Tailscale (exit node, hostname `brasil`).

Uses the Always Free tier — no cost.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) installed
- Oracle Cloud account with an API key configured
- A [Tailscale](https://tailscale.com) account on your tailnet

## Setup

### 1. Oracle Cloud API key

1. Log in to [Oracle Cloud Console](https://cloud.oracle.com)
2. Top-right → Profile → **My profile** → **API keys** → **Add API key**
3. Generate a new key pair, download the private key
4. Save the private key to `~/.oci/oci_api_key.pem` (`chmod 600`)
5. Note the **fingerprint** shown after adding the key
6. Collect your OCIDs from **Profile → Tenancy** and **Profile → My profile**

### 2. Tailscale ACL

The policy is defined in `acl.json` and **replaces your entire tailnet ACL on apply**. If you have existing rules:

1. Export your current policy from the [Tailscale admin console](https://login.tailscale.com/admin/acls/file) (top-right → **Download**).
2. Merge its contents into `acl.json`.
3. Make sure the following are present — they are required for the exit node to work:

```json
"tagOwners": {
  "tag:exit-node": []
},
"autoApprovers": {
  "exitNode": ["tag:exit-node"]
}
```

### 3. Tailscale OAuth client

Create an OAuth client once:

1. Open [Tailscale → Settings → OAuth clients](https://login.tailscale.com/admin/settings/oauth).
2. Click **Generate OAuth client**.
3. Grant the **Devices** (`write`) and **ACL** (`write`) scopes.
4. Copy the client ID and secret.

### 4. Variables

Copy the example and fill in your own values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

`terraform.tfvars` is gitignored — it holds real OCI OCIDs, the API key fingerprint, and the
Tailscale OAuth client secret. Never commit it (or `terraform.tfstate`, which also contains the
live Tailscale auth key in plaintext). If any of these ever leak, rotate the OCI API key and
regenerate the Tailscale OAuth client immediately.

### 5. Deploy

```bash
terraform init
terraform apply
```

Confirm the plan, then type `yes`.

## SSH into the instance

SSH goes through Tailscale — no key file, no public IP needed:

```bash
tailscale ssh proxy@brasil
```

`proxy` is created by cloud-init with passwordless sudo. `root` also works
(`tailscale ssh root@brasil`); both are permitted by the SSH rule in `acl.json`.

## What gets created

- VCN, public subnet, internet gateway, and route table in `sa-saopaulo-1`
- Ubuntu 24.04 VM (`VM.Standard.E2.1.Micro`, x86, 1/8 OCPU / 1 GB) — Always Free
- Only Tailscale UDP (41641) open inbound; no public SSH
- `proxy` user with passwordless sudo, provisioned via cloud-init for Tailscale SSH
- Tailscale auth key (pre-authorized, tagged `tag:exit-node`) generated at apply time
- Tailscale ACL replaced with the contents of `acl.json`
- Exit node route auto-approved — no manual step in the admin console
- Node key expiry disabled

After deploy, the instance appears in the [Tailscale admin console](https://login.tailscale.com/admin/machines) as `brasil` with exit node active.
