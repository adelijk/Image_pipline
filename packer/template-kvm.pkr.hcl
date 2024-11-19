packer {
  required_plugins {
    qemu = {
      source  = "github.com/hashicorp/qemu"
      version = "~> 1"
    }
  }
}

variable "qemu_accelerator" {
  type        = string
  default     = "kvm"
  description = "Qemu accelerator to use. On Linux, use kvm."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment to provision (dev, test, prod)."
}

source "qemu" "ubuntu" {
  accelerator      = var.qemu_accelerator
  cd_files         = ["./cloud-init/${var.environment}/*"]
  cd_label         = "cidata"
  disk_image       = true
  disk_size        = "11G"
  iso_checksum     = "e240e4b801f7bb68c20d1356b60968ad0c33a41d00d828e74ceb3364a0317be9"
  iso_url          = "/mnt/data1/ubuntu.iso"
  output_directory = "output/kvm/${var.environment}"
  shutdown_command = "echo 'packer' | sudo -S shutdown -P now"
  ssh_username     = "ubuntu"
  ssh_password     = "ubuntu"
  ssh_private_key_file = "~/.ssh/id_rsa"
  vm_name          = "${var.environment}-kvm.img"
  qemuargs = [
    ["-m", "2048M"],
    ["-smp", "2"],
    ["-serial", "mon:stdio"]
  ]
}

build {
  sources = ["source.qemu.ubuntu"]
}
