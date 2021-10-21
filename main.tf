/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
########################
#       check          #
########################
 
# Required if using User ADCs (Application Default Credentials) for Cloud Identity API.
# provider "google-beta" {
#   version               = "~> 3.0"
#   user_project_override = true
#   billing_project       = var.project_id
# }
 
##################################
#             Groups              #
##################################
 
module "group-organization-admins" {
  source = "terraform-google-modules/group/google"
 
  id           = "gcp-organization-admins${var.domain}" 
  display_name = "gcp-organization-admins"
  description  = "Organization admins"
  domain       = var.domain
  owners       = ["foo@example.com"]
  members      = ["another-group@example.com"]
}
 
module "group-network-admins" {
  source = "terraform-google-modules/group/google"
 
  id           = "gcp-network-admins@${var.domain}" 
  display_name = "gcp-network-admins"
  description  = "Network admins"
  domain       = var.domain
  owners       = ["foo@example.com"]
  members      = ["another-group@example.com"]
}
 
module "group-security-admins" {
  source = "terraform-google-modules/group/google"
 
  id           = "gcp-security-admins@${var.domain}"
  display_name = "gcp-security-admins"
  description  = "Security admins"
  domain       = var.domain
  owners       = ["foo@example.com"]
  members      = ["another-group@example.com"]
}
 
module "group-billing-admins" {
  source = "terraform-google-modules/group/google"
 
  id           = "gcp-billing-admins@${var.domain}" 
  display_name = "gcp-billing-admins"
  description  = "Billing admins"
  domain       = var.domain
  owners       = ["foo@example.com"]
  members      = ["another-group@example.com"]
}
 
module "group-devops" {
  source = "terraform-google-modules/group/google"
 
  id           = "gcp-devops@${var.domain}"
  display_name = "gcp-devops"
  description  = "Devops"
  domain       = var.domain
  owners       = ["foo@example.com"]
  members      = ["another-group@example.com"]
}
 
module "group-developers" {
  source = "terraform-google-modules/group/google"
 
  id           = "gcp-developers@${var.domain}"
  display_name = "gcp-developers"
  description  = "Developers"
  domain       = var.domain
  owners       = ["foo@example.com"]
  members      = ["another-group@example.com"]
}
 
##################################
#         Role Binding           #
##################################
 
module "organization-iam-bindings" {
  source        = "terraform-google-modules/iam/google//modules/organizations_iam"
  organizations = ["latamdc.com"]
  mode          = "authoritative"
 
  bindings = {
    "roles/resourcemanager.organizationAdmin" = [
      "group:gcp-organization-admins"
    ]
 
    "roles/iam.organizationRoleAdmin" = [
      "group:gcp-organization-admins"
    ]
 
    "roles/orgpolicy.policyAdmin" = [
      "group:gcp-organization-admins","group:gcp-security-admins"
    ]
 
    "roles/orgpolicy.policyViewer" = [
      "group:gcp-security-admins"
    ]
 
    "roles/iam.organizationRoleViewer" = [
      "group:gcp-security-admins"
    ]
 
    "roles/resourcemanager.organizationViewer" = [
      "group:gcp-billing-admins"
    ]
 
#check 
    "roles/resourcemanager.organizationViewer" = [
      "group:gcp-devops"
    ]
  }
}
 
module "projects_iam_binding" {
  source  = "terraform-google-modules/iam/google//modules/projects_iam"
    
  mode = "additive"
 
  bindings = {
    "roles/securitycenter.admin" = [
      "group:gcp-organization-admins","group:gcp-security-admins"
    ]
 
    "roles/cloudsupport.admin" = [
      "group:gcp-organization-admins"
    ]
 
    "roles/compute.networkAdmin" = [
      "group:gcp-network-admins"
    ]
 
    "roles/compute.xpnAdmin" = [
      "group:gcp-network-admins"
    ]
 
    "roles/compute.securityAdmin" = [
      "gcp-network-admins"
    ]
 
    "roles/iam.securityReviewer" = [
      "group:gcp-security-admins"
    ]
 
    "roles/logging.privateLogViewer" = [
      "group:gcp-security-admins"
    ]
 
    "roles/logging.configWriter" = [
      "group:gcp-security-admins"
    ]
 
    "roles/container.viewer" = [
      "group:gcp-security-admins"
    ]
 
    "roles/compute.viewer" = [
      "group:gcp-security-admins"
    ]
 
    "roles/bigquery.dataViewer" = [
      "group:gcp-security-admins"
    ]
 
 
  }
}
 
 
module "billing-account-iam" {
  source = "terraform-google-modules/iam/google//modules/billing_accounts_iam"
 
  billing_account_ids = [var.billing_account_id]
 
  mode = "additive"
 
  bindings = {
    "roles/billing.user" = [
      "group:gcp-organization-admins"
    ]
 
    "roles/billing.admin" = [
      "group:gcp-billing-admins"
    ]
 
    "roles/billing.creator" = [
      "group:gcp-billing-admins"
    ]
  }
}
 
module "folder-iam" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  
  mode = "additive"
 
  bindings = {
    "roles/resourcemanager.folderIamAdmin" = [
      "group:gcp-security-admins"
    ]
 
    "roles/resourcemanager.folderViewer" = [
      "group:gcp-network-admins","group:gcp-devops"
    ]
 
    "roles/resourcemanager.folderAdmin" = [
      "group:gcp-organization-admins"
    ]
  }
}
# Permissions for developers, only npd environment
module "folder-iam-npd" {
  source  = "terraform-google-modules/iam/google//modules/folders_iam"
  folders = ["fld-np-folder"]
 
  mode = "additive"
 
  bindings = {
    "roles/compute.admin" = [
      "group:gcp-developers"
    ]
 
    "roles/container.admin" = [
      "group:gcp-developers"
    ]
  }
}
 
/**
### MULTI VPC ###
*/
 
#module "network_multi_vpc" {
#  source  = "terraform-google-modules/network/google//examples/multi_vpc"
#  version = "0.3.0"
  # insert the 1 required variable here
 
locals {
  network_01_subnet_01 = "${var.network_01_name}-subnet-01"
  network_01_subnet_02 = "${var.network_01_name}-subnet-02"
  network_01_subnet_03 = "${var.network_01_name}-subnet-03"
  network_02_subnet_01 = "${var.network_02_name}-subnet-01"
  network_02_subnet_02 = "${var.network_02_name}-subnet-02"
 
  network_01_routes = [
    {
      name              = "${var.network_01_name}-egress-inet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]
 
  network_02_routes = [
    {
      name              = "${var.network_02_name}-egress-inet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
    {
      name              = "${var.network_02_name}-testapp-proxy"
      description       = "route through proxy to reach app"
      destination_range = "10.50.10.0/24"
      tags              = "app-proxy"
      next_hop_ip       = "10.10.40.10"
    }
  ]
}
 
module "test-vpc-module-01" {
  source       = "terraform-google-modules/network/google"
  project_id   = var.project_id
  network_name = var.network_01_name
 
  subnets = [
    {
      subnet_name           = local.network_01_subnet_01
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "false"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = local.network_01_subnet_02
      subnet_ip             = "10.10.20.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "false"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = local.network_01_subnet_03
      subnet_ip             = "10.10.30.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "false"
      subnet_flow_logs      = "true"
    },
  ]
 
  secondary_ranges = {
    "${local.network_01_subnet_01}" = [
      {
        range_name    = "${local.network_01_subnet_01}-01"
        ip_cidr_range = "192.168.64.0/24"
      },
      {
        range_name    = "${local.network_01_subnet_01}-02"
        ip_cidr_range = "192.168.65.0/24"
      },
    ]
 
    "${local.network_01_subnet_02}" = [
      {
        range_name    = "${local.network_02_subnet_01}-01"
        ip_cidr_range = "192.168.74.0/24"
      },
    ]
  }
 
  routes = local.network_01_routes
}
 
module "test-vpc-module-02" {
  source       = "terraform-google-modules/network/google"
  #source       = "terraform-google-modules/network/google//modules/subnets"
  project_id   = var.project_id
  network_name = var.network_02_name
 
  subnets = [
    {
      subnet_name           = "${local.network_02_subnet_01}"
      subnet_ip             = "10.10.40.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "false"
      subnet_flow_logs      = "true"
    },
    {
      subnet_name           = "${local.network_02_subnet_02}"
      subnet_ip             = "10.10.50.0/24"
      subnet_region         = "us-west1"
      subnet_private_access = "false"
      subnet_flow_logs      = "true"
    },
  ]
 
  secondary_ranges = {
    "${local.network_02_subnet_01}" = [
      {
        range_name    = "${local.network_02_subnet_02}-01"
        ip_cidr_range = "192.168.75.0/24"
      },
    ]
  }
 
  routes = local.network_02_routes
}
