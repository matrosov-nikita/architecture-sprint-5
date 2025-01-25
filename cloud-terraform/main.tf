terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
}

data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "yandex_compute_disk" "testvm" {
  name = "test-vm-disk"
  type = "network-ssd"
  zone = "ru-central1-a"
  image_id = data.yandex_compute_image.ubuntu.image_id
  size = 15
}

resource "yandex_compute_instance" "testvm" {
  name = "test-vm"

  zone = "ru-central1-a"

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    disk_id = yandex_compute_disk.testvm.id
  }

  network_interface {
    subnet_id = "e9b10j3k5h4idjitlcuh"
    nat = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}