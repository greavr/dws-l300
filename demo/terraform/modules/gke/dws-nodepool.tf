# ----------------------------------------------------------------------------------------------------------------------
# CREATE GKE Cluster
# ----------------------------------------------------------------------------------------------------------------------
locals {
    primary_cluster = var.regions[0].region
}
resource "google_container_node_pool" "dws" {
    name       = "dws-a100"
    location     = local.primary_cluster
    cluster    = google_container_cluster.gke-cluster[local.primary_cluster].name

    # Magic
    queued_provisioning {
        enabled = true
    }

    initial_node_count = 0

    autoscaling {
        min_node_count = 0
        max_node_count = 6
        location_policy = "ANY"
    }

    node_config {
        machine_type = "a2-highgpu-1g"

        disk_size_gb = "100"
        disk_type    = "pd-standard"

        service_account = google_service_account.gke-node-sa.email
        oauth_scopes    = [
            "https://www.googleapis.com/auth/cloud-platform"
        ]

        # Add node taints
        taint {
            key    = "a100"
            value  = "TRUE"
            effect = "NO_SCHEDULE" # Options: NO_SCHEDULE, PREFER_NO_SCHEDULE, NO_EXECUTE
        }

        shielded_instance_config {
            enable_secure_boot = true
            enable_integrity_monitoring = true
        }
    }
    timeouts {
        create = "30m"
        update = "20m"
    }

    depends_on = [
        google_container_cluster.gke-cluster
    ]
}
