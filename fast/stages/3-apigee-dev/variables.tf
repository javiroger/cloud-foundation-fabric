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
