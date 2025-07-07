/**
 * Copyright 2025 Google LLC
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

# module "apigee" {
#   for_each = {}
#   count    = var.apigee_configs.dev.enabled ? 1 : 0
#   providers = {
#     google-beta = google-beta.datares
#   }
#   source     = "../modules/apigee"
#   project_id = var.apigee_projects.dev.project_id
#   organization = {
#     display_name = var.apigee_configs.dev.organization_name
#     description  = var.apigee_configs.dev.organization_description
#     runtime_type = "CLOUD"
#     billing_type = var.apigee_billing_type
#     # Parameters for no Data Residency
#     analytics_region = var.apigee_configs.dev.apigee_ax_region
#     # Parameters for Data Residency
#     api_consumer_data_location            = var.apigee_configs.dev.api_consumer_data_location
#     runtime_database_encryption_key_name  = try(module.kms-org-db[0].key_ids["org-db"], null)
#     api_consumer_data_encryption_key_name = try(module.kms-org-cp[0].key_ids["org-cp"], null)
#     control_plane_encryption_key_name     = try(module.kms-org-cd[0].key_ids["org-cd"], null)

#     disable_vpc_peering = true
#   }
#   envgroups            = local.envgroups
#   environments         = var.apigee_configs.dev.environments
#   instances            = local.instances
#   endpoint_attachments = var.endpoint_attachments

#   depends_on = [
#     google_project_service.apigee_project_services_dev
#   ]
# }
