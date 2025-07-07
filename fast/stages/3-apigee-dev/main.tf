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

locals {
  folder_id = var.folder_ids[var.stage_config.name]
}

moved {
  from = module.apigee-project-0
  to   = module.project
}

module "project" {
  source            = "../../../modules/project"
  billing_account   = var.billing_account.id
  name              = "dev-apigee-core-0"
  parent            = local.folder_id
  prefix            = var.prefix
  iam               = var.iam
  iam_by_principals = var.iam_by_principals
  labels = {
    environment = lower(
      var.environments[var.stage_config.environment].name
    )
  }
  services = var.project_services
}

module "vpc" {
  source                          = "../../../modules/net-vpc"
  project_id                      = module.project.project_id
  name                            = "default"
  mtu                             = 1500
  delete_default_routes_on_create = true
  factories_config = {
    context = {
      regions = merge(var.regions, var.factories_config.context.regions)
    }
    subnets_folder = var.factories_config.vpc_subnets
  }
  create_googleapis_routes = {
    private    = true
    restricted = true
  }
  # TODO: add variable-based customization if needed
  routes = var.vpc_config.create_default_route != true ? {} : {
    default = {
      dest_range    = "0.0.0.0/0",
      priority      = 100
      next_hop_type = "gateway",
      next_hop      = "default-internet-gateway"
    }
  }
}

module "addresses" {
  source     = "../../../modules/net-address"
  project_id = module.project.project_id
  psc_addresses = {
    apigee = {
      # address          = "10.0.16.32"
      subnet_self_link = var.subnet.self_link
      region           = var.region
      service_attachment = {
        psc_service_attachment_link = module.cloudsql-instance.psc_service_attachment_link
      }
    }
  }
}
