provider "google" {
  version = "4.51.0"
  project = var.project_id
  region  = var.region
}

resource "google_compute_instance" "telegram_bot" {
  name         = "telegram-bot"
  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }

  network_interface {
    network = "default"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y python3-pip",
      "sudo apt-get install -y git",
      "git clone https://github.com/strobil/tg-bot.git",
      "cd gt-bot",
      "pip3 install -r requirements.txt",
      "python3 bot.py &"
    ]
  }
}
