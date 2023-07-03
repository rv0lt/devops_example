provider "google" {
  project = "global-shard-391615"
  credentials = "./global-shard-391615-970a65630c3a.json"
  region = "us-east1"
  zone = "us-east1-b"
}

resource "google_compute_instance" "instance-example" {
    name         = "instance-example"
    machine_type = "e2-micro"

    boot_disk {
        initialize_params {
        image = "ubuntu-os-cloud/ubuntu-2004-lts"
        }
    }

    can_ip_forward = "true"

    metadata = {
    ssh-keys = "rv0lt:${file("~/.ssh/gcloud_key.pub")}"
    }


    network_interface {
        network = "default"

        access_config {
        # Include this section to give the VM an external IP address

        }
    }
    service_account {
        scopes = ["compute-rw","storage-ro","service-management","service-control","logging-write","monitoring"]
    }
}

output "ip-address" {
  value = "${google_compute_instance.instance-example.network_interface.0.access_config.0.nat_ip}"
}