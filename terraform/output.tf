output "kraeuterakademie_node-1-ip" {
    value = [for node in hcloud_server.kraeuterakademie_node[0].network: node.ip]
}