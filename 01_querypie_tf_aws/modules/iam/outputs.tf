output "image_id" {
    value = var.image_id
}

output "availability_zone_names" {
    value = var.availability_zone_names
}

output "ami_id_maps" {
    value = var.ami_id_maps
}

output "first_availability_zone_names" {
    value = var.availability_zone_names[0]
}