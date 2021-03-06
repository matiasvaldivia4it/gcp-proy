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
 
variable "billing_account_id" {
    description = "The ID of the billing account"
    type        = string
    default     = "01588D-50B302-F74B9E" 
}
 
variable "project_id" {
  description = "The ID of the project in which to provision resources and used for billing"
  type        = string
  default     = "useful-tempest-329712"
}
 
variable "domain" {
  description = "Domain of the organization to create the group in"
  type        = string
  default     = "pymesenlinea.com.ar"
}
 
variable "suffix" {
  description = "Suffix of the groups to create"
  type        = string
  default      = "pega"
}
 
variable "network_01_name" {
  description = "The name of the first VPC network being created"
  default     = "prd"
}
 
variable "network_02_name" {
  description = "The name of the second VPC network being created"
  default     = "dev"
}
