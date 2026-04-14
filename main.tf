# -------------------------
# DATA SOURCES
# -------------------------
data "aws_availability_zones" "available" {
  state = "available"
}

# -------------------------
# EC2 INSTANCE
# -------------------------
resource "aws_instance" "runner" {
  ami                    = local.ami_id
  instance_type          = "t3.micro"

  #subnet_id              = "subnet-058fe80eded348a6b"   # Your subnet
  vpc_security_group_ids = [aws_security_group.main.id]

  # ❌ DO NOT USE availability_zone when subnet_id is used
  availability_zone = data.aws_availability_zones.available.names[0]

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
  }

  user_data = file("runner.sh")

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-runner"
    }
  )
}

# -------------------------
# SECURITY GROUP
# -------------------------
resource "aws_security_group" "main" {
  name        = "${var.project}-${var.environment}-runner"
  description = "Security group for runner"

  # ✅ Allow SSH (restrict in real projects)
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # ⚠️ Change to your IP for security
  }

  # ✅ Allow HTTP (optional)
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ✅ Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    local.common_tags,
    {
      Name = "${var.project}-${var.environment}-runner-sg"
    }
  )
}