# ----------------------------------------------------------------------------------------------------------------------
# CTD Required
# ----------------------------------------------------------------------------------------------------------------------
variable "project_id" {
  type        = string
  description = "project id required"
}
variable "project_name" {
  type        = string
  description = "project name in which demo deploy"
  default = ""
}
variable "project_number" {
  type        = string
  description = "project number in which demo deploy"
  default = ""
}
variable "gcp_account_name" {
  description = "user performing the demo"
  default = ""
}
variable "deployment_service_account_name" {
  description = "Cloudbuild_Service_account having permission to deploy terraform resources"
  default = ""
}
variable "org_id" {
  description = "Organization ID in which project created"
  default = ""
}
variable "data_location" {
  type        = string
  description = "Location of source data file in central bucket" 
  default = ""
}
variable "secret_stored_project" {
    type        = string
    description = "Project where secret is accessing from"
    default = ""
}

# Service to enable
variable "services_to_enable" {
    description = "List of GCP Services to enable"
    type    = list(string)
    default =  [
        "compute.googleapis.com",
        "iap.googleapis.com",  
        "cloudresourcemanager.googleapis.com",
        "container.googleapis.com",
        "gkeconnect.googleapis.com",
        "gkehub.googleapis.com",
        "iam.googleapis.com",
        "logging.googleapis.com",
        "monitoring.googleapis.com",
        "opsconfigmonitoring.googleapis.com",
        "serviceusage.googleapis.com",
        "stackdriver.googleapis.com",
        "servicemanagement.googleapis.com",
        "servicecontrol.googleapis.com",
        "storage.googleapis.com",
        "run.googleapis.com"
    ]
}

variable "vpc-name" {
    type = string
    description = "DWS VPC"
    default = "dws"
}

# List of regions (support for multi-region deployment)
variable "regions" { 
    type = list(object({
        region = string
        cidr = string
        management-cidr = string
        })
    )
    default = [{
            region = "us-central1"
            cidr = "10.0.0.0/20"
            management-cidr = "192.168.10.0/28"
        }]
}

# Extra GKE SA Roles
variable "gke_service_account_roles" {
    description = "GKE Service Account Roles"
    type        = list(string)
    default     = [
        "gkehub.connect",
        "gkehub.admin",
        "logging.logWriter",
        "monitoring.metricWriter",
        "monitoring.dashboardEditor",
        "stackdriver.resourceMetadata.writer",
        "opsconfigmonitoring.resourceMetadata.writer",
        "multiclusterservicediscovery.serviceAgent",
        "multiclusterservicediscovery.serviceAgent",
        "compute.networkViewer",
        "container.admin",
        "source.reader"
    ]
}

# GKE Settings
variable "gke-node-count" {
    description = "GKE Inital Node Count"
    type = number
    default = 1
}

variable "gke-node-type" {
    description = "GKE Node Machine Shape"
    type = string
    default = "e2-standard-4"
}

# Deployment Info
variable "k8-namespace" {
    description = "Default name space to provision into"
    type = string
    default = "dws-demo"
}

# GKE Application Service account
variable "ksa_name" {
    description = "Kubernetes Service Account Name"
    type = string
    default = "dws-ksa"
}

variable "iam_ksa" {
    description = "IAM user for KSA"
    type = string
    default = "dws-gsa"
}