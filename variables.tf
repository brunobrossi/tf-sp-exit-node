variable "tenancy_ocid" {
  description = "OCI tenancy OCID"
  type        = string
  sensitive   = true
}

variable "user_ocid" {
  description = "OCI user OCID"
  type        = string
  sensitive   = true
}

variable "fingerprint" {
  description = "OCI API key fingerprint"
  type        = string
  sensitive   = true
}

variable "private_key_path" {
  description = "Path to OCI API private key file"
  type        = string
  default     = "~/.oci/oci_api_key.pem"
}

variable "region" {
  description = "OCI region"
  type        = string
  default     = "sa-saopaulo-1"
}

variable "compartment_id" {
  description = "OCI compartment OCID (use tenancy OCID for root compartment)"
  type        = string
  sensitive   = true
}

variable "availability_domain" {
  description = "OCI availability domain name (e.g. Uocm:SA-SAOPAULO-1-AD-1)"
  type        = string
}

variable "shape" {
  description = "OCI compute shape. Use VM.Standard.A1.Flex for the ARM Always Free tier (if capacity is available in your region); ocpus/memory_in_gbs only apply to Flex shapes. VM.Standard.E2.1.Micro is the fixed x86 Always Free fallback."
  type        = string
  default     = "VM.Standard.E2.1.Micro"
}

variable "ocpus" {
  description = "Number of OCPUs (free tier allows up to 4 total). Only applies when shape is a Flex shape."
  type        = number
  default     = 1
}

variable "memory_in_gbs" {
  description = "Memory in GB (free tier allows up to 24 total). Only applies when shape is a Flex shape."
  type        = number
  default     = 6
}

variable "ssh_public_key" {
  description = "SSH public key for the instance (OCI requires one; actual access is via Tailscale SSH)"
  type        = string
}

variable "hostname" {
  description = "Tailscale hostname for the exit node"
  type        = string
  default     = "brasil"
}

variable "tailscale_oauth_client_id" {
  description = "Tailscale OAuth client ID"
  type        = string
  sensitive   = true
}

variable "tailscale_oauth_client_secret" {
  description = "Tailscale OAuth client secret"
  type        = string
  sensitive   = true
}
