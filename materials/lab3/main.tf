terraform {
  # Declare and pin the provider
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0"
    }
  }
}

provider "google" {
  project = "xxxxxxxxx"
  zone    = "us-central1-a"
}

# Select OS
data "google_compute_image" "base" {
  family  = "ubuntu-2404-lts-amd64"
  project = "ubuntu-os-cloud"
}

resource "google_compute_instance" "hello" {
  name = "adpd-hello"

  # Select hardware: an allocation from a catalogue, not a share of a host
  machine_type = "e2-medium"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.base.self_link
    }
  }

  network_interface {
    network = "default"

    # An external address is needed to reach the apt repositories.
    # Removing it is the exercise in Lab 2.
    access_config {}
  }

  service_account {
    scopes = ["cloud-platform"]
  }
}

