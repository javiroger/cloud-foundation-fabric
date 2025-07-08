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

variable "apigee_config" {
  description = "Apigee configuration."
  type = object({
    addons_config = optional(object({
      advanced_api_ops    = optional(bool, false)
      api_security        = optional(bool, false)
      connectors_platform = optional(bool, false)
      integration         = optional(bool, false)
      monetization        = optional(bool, false)
    }), {})
    dns_zones = optional(map(object({
      domain            = string
      description       = string
      target_project_id = string
      target_network_id = string
    })), {})
    envgroups = optional(map(list(string)), {})
    environments = optional(map(object({
      api_proxy_type    = optional(string)
      description       = optional(string, "Terraform-managed")
      display_name      = optional(string)
      deployment_type   = optional(string)
      envgroups         = optional(list(string), [])
      forward_proxy_uri = optional(string)
      iam               = optional(map(list(string)), {})
      iam_bindings = optional(map(object({
        role    = string
        members = list(string)
      })), {})
      iam_bindings_additive = optional(map(object({
        role   = string
        member = string
      })), {})
      node_config = optional(object({
        min_node_count = optional(number)
        max_node_count = optional(number)
      }))
      type = optional(string)
    })), {})
    instances = optional(map(object({
      consumer_accept_list          = optional(list(string))
      description                   = optional(string, "Terraform-managed")
      disk_encryption_key           = optional(string)
      display_name                  = optional(string)
      enable_nat                    = optional(bool, false)
      activate_nat                  = optional(bool, false)
      environments                  = optional(list(string), [])
      name                          = optional(string)
      runtime_ip_cidr_range         = optional(string)
      troubleshooting_ip_cidr_range = optional(string)
    })), {})
    organization = optional(object({
      analytics_region                 = optional(string)
      api_consumer_data_encryption_key = optional(string)
      api_consumer_data_location       = optional(string)
      authorized_network               = optional(string)
      billing_type                     = optional(string)
      control_plane_encryption_key     = optional(string)
      database_encryption_key          = optional(string)
      description                      = optional(string, "Terraform-managed")
      disable_vpc_peering              = optional(bool, true)
      display_name                     = optional(string)
      properties                       = optional(map(string), {})
      runtime_type                     = optional(string, "CLOUD")
      retention                        = optional(string)
    }))
  })
  nullable = false
  default = {
    envgroups = {
      apis = ["apigee.example.com"]
    }
    environments = {
      test = {
        envgroups = ["apis"]
      }
    }
    instances = {
      # TODO: interpolate regions
      primary = {
        environments = ["test"]
        # regional
        # disk_encryption_key =
      }
      secondary = {
        environments = ["test"]
      }
    }
    organization = {
      # regional TBD: check
      # database_encryption_key = xxx

    }
  }
}

variable "factories_config" {
  description = "Configuration for resource factories."
  type = object({
    context = optional(object({
      regions = optional(map(string), {})
    }), {})
    vpc_subnets = optional(string, "data/subnets")
  })
  default  = {}
  nullable = false
}

variable "iam" {
  description = "Project-level authoritative IAM bindings for users and service accounts in  {ROLE => [MEMBERS]} format."
  type        = map(list(string))
  default     = {}
  nullable    = false
}

variable "iam_by_principals" {
  description = "Authoritative IAM binding in {PRINCIPAL => [ROLES]} format. Principals need to be statically defined to avoid cycle errors. Merged internally with the `iam` variable."
  type        = map(list(string))
  default     = {}
  nullable    = false
}

variable "project_services" {
  description = "Services activated in the Apigee project."
  type        = list(string)
  nullable    = false
  default = [
    "apigee.googleapis.com",
    "dns.googleapis.com",
    "logging.googleapis.com",
    "monitoring.googleapis.com",
    "servicenetworking.googleapis.com",
  ]
}

variable "stage_config" {
  description = "FAST stage configuration used to find resource ids. Must match name defined for the stage in resource management."
  type = object({
    environment = string
    name        = string
  })
  default = {
    environment = "dev"
    name        = "apigee-dev"
  }
}

variable "vpc_config" {
  description = "Network-level configuration."
  type = object({
    apigee_endpoint_address_index = optional(number, 3)
    create_default_route          = optional(bool, true)
  })
  nullable = false
  default  = {}
}
