provider "google" {
  version = "3.51.0"
  project = "<PROJECT_ID>"
  region  = "<REGION>"
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
      "pip3 install python-telegram-bot",
      "sudo apt-get install -y git",
      "git clone https://github.com/<GITHUB_USERNAME>/<TELEGRAM_BOT_REPO>.git",
      "cd <TELEGRAM_BOT_REPO>",
      "python3 bot.py &"
    ]
  }
}
