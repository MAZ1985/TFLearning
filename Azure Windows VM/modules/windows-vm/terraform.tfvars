security_rules = [
    {
        name = "Allow-RDP"
        priority = 100
        direction = "Inbound"
        protocol = "Tcp"
        port = 3389
    },
    {
        name = "Allow-HTTP"
        priority = 101
        direction = "Inbound"
        protocol = "Tcp"
        port = 80
    },
    {
        name = "Allow-HTTPS"
        priority = 100
        direction = "Inbound"
        protocol = "Tcp"
        port = 443
    },
    {
        name = "Allow-HTTP"
        priority = 200
        direction = "Outbound"
        protocol = "Tcp"
        port = 80
    },
    {
        name = "Allow-HTTPS"
        priority = 201
        direction = "Inbound"
        protocol = "Tcp"
        port = 443
    }    
]