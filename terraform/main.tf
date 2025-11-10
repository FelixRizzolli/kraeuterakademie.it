resource "hcloud_server" "kraeuterakademie_node" {
    count = 1
    name = "kraeuterakademie-node"
    image = "debian-12"
    server_type = "cx23"
    datacenter = "nbg1-dc3"
    ssh_keys = ["terraform-ssh-key"]
    public_net {
        ipv4_enabled = true
        ipv6_enabled = true
    }

    network {
        network_id = hcloud_network.kraeuterakademie_network.id
        ip = "172.16.0.100"
    }

    depends_on = [ 
        hcloud_network_subnet.kraeuterakademie_subnet,
    ]
}

resource "hcloud_network" "kraeuterakademie_network" {
    name = "kraeuterakademie-network"
    ip_range = "172.16.0.0/24"
}

resource "hcloud_network_subnet" "kraeuterakademie_subnet" {
    type = "cloud"
    network_id = hcloud_network.kraeuterakademie_network.id
    network_zone = "eu-central"
    ip_range = "172.16.0.0/24"
}

resource "hcloud_ssh_key" "default" {
    name = "terraform-ssh-key"
    public_key = file("~/.ssh/id_ed25519.pub")
}

resource "hcloud_volume" "kraeuterakademie_volume" {
    name        = "kraeuterakademie-volume"
    size        = 10
    server_id   = hcloud_server.kraeuterakademie_node[0].id
    automount   = true
    format      = "ext4"
}