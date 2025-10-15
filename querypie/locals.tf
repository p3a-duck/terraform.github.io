locals {
  region_code_map = {
    "ap-northeast-3" = "apne3"
    "ap-southeast-1" = "apse1"
    "ap-northeast-2" = "apne2"
  }
  region_code = lookup(local.region_code_map, var.region, replace(var.region, "/-|east|west/", ""))
  name_prefix = "qp-${local.region_code}"
}
