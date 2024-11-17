packer {
  required_plugins {
    vmware = {
      source  = "github.com/hashicorp/vmware"
      version = "~> 1"
    }
  }
}

variable "vmware_vmx_path" {
  type        = string
  default     = "~/vmware/packer-vms"
  description = "Path where VMware VMX files will be stored."
}



variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment to provision (dev, test, prod)."
}

source "vmware-iso" "ubuntu" {
  iso_checksum     = "e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9"
  iso_url          = "/mnt/data1/ubuntu.iso"
  output_directory = "output/vmware/${var.environment}"
  shutdown_timeout      = "10m" # Add this line here
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username     = "ubuntu"
  ssh_password     = "ubuntu"
  disk_size        = 10
  cd_files         = ["./cloud-init/${var.environment}/*"]
  cd_label         = "cidata"
  vm_name          = "${var.environment}-vmware.img"
  ssh_private_key_file = "~/.ssh/id_rsa"

  vmx_data = {
    "memsize"               = "2048"
    "numvcpus"              = "2"
    "cpuid.coresPerSocket"  = "2"
  }
  headless = false
}

build {
  sources = ["source.vmware-iso.ubuntu"]
}
