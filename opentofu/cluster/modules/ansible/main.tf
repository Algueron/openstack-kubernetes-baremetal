 resource "local_file" "ansible_inventory" {
    content = templatefile("${path.module}/inventory.ini.tftpl",
    {
        control_nodes           = range(var.number_control_nodes),
        control_plane_hostname  = var.control_plane_hostname,
        control_plane_ip        = var.control_plane_ip,
        worker_nodes            = range(var.number_worker_nodes),
        worker_hostname         = var.worker_hostname,
        worker_ip               = var.worker_ip
    }
  )
  filename = "${path.root}/../../kubespray/inventory/mycluster/inventory.ini"
}
