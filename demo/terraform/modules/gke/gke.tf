# ----------------------------------------------------------------------------------------------------------------------
# CREATE GKE Cluster
# ----------------------------------------------------------------------------------------------------------------------
resource "google_container_cluster" "gke-cluster" {
    for_each = {for a_subnet in var.regions: a_subnet.region => a_subnet}
    provider  = google-beta
    name     = "${var.project_id}-${each.value.region}"
    location = "${each.value.region}"

    release_channel {
        channel = "RAPID"
    }
    
    network = var.vpc-name
    subnetwork = "${each.value.region}"

    ip_allocation_policy {
        cluster_ipv4_cidr_block  = ""
        services_ipv4_cidr_block = ""
    } 

    private_cluster_config {
        enable_private_nodes =  true
        enable_private_endpoint = false
        master_ipv4_cidr_block = "${each.value.management-cidr}"
        master_global_access_config {
            enabled = true
        }
    }

    workload_identity_config {
        workload_pool = "${var.project_id}.svc.id.goog"
    }

    node_pool {
        initial_node_count = var.gke-node-count  

        node_config {
            preemptible  = false
            machine_type = var.gke-node-type
            disk_size_gb = "100"
            disk_type    = "pd-standard"
            # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
            oauth_scopes = [
                "https://www.googleapis.com/auth/cloud-platform"
            ]
            labels = {}
            tags = []
            service_account = google_service_account.gke-node-sa.email

            shielded_instance_config {
                enable_secure_boot = true
                enable_integrity_monitoring = true
            }
        }
        
    }

    enable_shielded_nodes = true
    
    timeouts {
        create = "30m"
        update = "40m"
    }
    
        
    depends_on = [
        google_service_account.gke-node-sa
    ]
}