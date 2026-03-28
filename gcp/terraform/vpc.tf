resource google_compute_network vpc_network {
    name                    = empath-dev-vpc
    auto_create_subnetworks = false
}

resource google_compute_subnetwork vpc_subnet {
    name          = empath-dev-subnet-01
    ip_cidr_range = 10.0.x.x/25
    region        = us-central1
    network       = google_compute_network.vpc_network_id 
}
