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
  regions = merge(var.regions, var.factories_config.context.regions)
  subnets = {
    for k, v in module.vpc.subnets : replace(k, "/", "-") => {
      name   = split("/", k)[1]
      region = v.region
      id     = v.id
      key    = k
    }
  }
}
output "foo" { value = local.subnets }
module "vpc" {
  source                          = "../../../modules/net-vpc"
  project_id                      = module.project.project_id
  name                            = "default"
  mtu                             = 1500
  delete_default_routes_on_create = true
  factories_config = {
    context        = { regions = local.regions }
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
    # for k, v in local.subnets : split("/", k)[1] => {
    #   subnet_self_link = v.id
    #   region           = v.region
    #   service_attachment = {
    #     apigee = module.apigee.0.instances[v.region].service_attachment
    #   }
    # }
  }
}
