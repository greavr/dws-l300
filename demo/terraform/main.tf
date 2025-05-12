#----------------------------------------------------------------------------------------------------------------------
# Main modules
# ----------------------------------------------------------------------------------------------------------------------

# ----------------------------------------------------------------------------------------------------------------------
# Enable APIs
# ----------------------------------------------------------------------------------------------------------------------
resource "google_project_service" "enable-services" {
  for_each = toset(var.services_to_enable)

  project = var.project_id
  service = each.value
  disable_on_destroy = false
}

# ----------------------------------------------------------------------------------------------------------------------
# Configure VPC
# ----------------------------------------------------------------------------------------------------------------------
module "vpc" {
  source  = "./modules/vpc"
  project_id = var.project_id
  regions = var.regions
  vpc-name = var.vpc-name
  
  depends_on = [
    google_project_service.enable-services,
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Configure GKE
# ----------------------------------------------------------------------------------------------------------------------
module "gke" {
  source  = "./modules/gke"

  project_id = var.project_id
  vpc-name = var.vpc-name
  regions = var.regions
  gke_service_account_roles = var.gke_service_account_roles
  gke-node-count = var.gke-node-count
  gke-node-type = var.gke-node-type
  
  depends_on = [
    module.vpc
  ]
}