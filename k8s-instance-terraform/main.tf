resource "aws_instance" "main" {
    ami = local.ami_id
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.main.id]
    tags = {
        Name = "${var.project}-${var.environment}-k8s"
    }
    root_block_device {
        volume_size = 50
        volume_type = "gp3" # or "gp2", depending on your preference
    }

    user_data = file("configure.sh")
}

resource "aws_security_group" "main" {
    name = "roboshop-k8s"

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_route53_record" "main" {
    name = "k8s.pavithra.sbs"
    zone_id = "Z0034753Q3D37U6HFEYZ"
    type = "A"
    ttl = 1
    records = [aws_instance.main.public_ip]
    allow_overwrite = true
}