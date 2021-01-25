data "template_file" "user_data" {
  template = file("${path.module}/user-data.sh")

  vars = {
    server_port  = var.server_port
    cluster_name = var.cluster_name
    db_address   = var.db_address
    db_port      = var.db_port
    server_text  = var.server_text
  }
}
