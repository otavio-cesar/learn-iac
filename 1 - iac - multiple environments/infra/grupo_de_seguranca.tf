resource "aws_security_group" "sg" {
  name        = "allow_web_traffic"
  description = "Allow web traffic"
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
  tags = {
    name = "acesso_geral"
  }
}
 