provider "aws" {}


data "aws_availability_zones" "working" {}
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
data "aws_vpcs" "my_vpcs" {}


#************* Default vps ******************************************


resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}


resource "aws_default_subnet" "default_az0" {
  availability_zone = data.aws_availability_zones.working.names[0]

  tags = {
    Name = "Default subnet for eu-central-1a"
  }
}

resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.working.names[1]

  tags = {
    Name = "Default subnet for eu-central-1b"
  }
}

resource "aws_default_subnet" "default_az2" {
  availability_zone = data.aws_availability_zones.working.names[2]

  tags = {
    Name = "Default subnet for eu-central-1c"
  }
}
#**********************************************************************

resource "aws_security_group" "prod" {
  name          = "Prod Security Group"
  vpc_id        = aws_vpc.prod.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.prod.cidr_block]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   tags = {
    Name  = "Prod_SecurityGroup"
    Owner = "Andrei Shtanakov"
  }
}

resource "aws_security_group" "def" {
  name          = "DEf Security Group"
  vpc_id        = aws_default_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_default_vpc.default.cidr_block]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   tags = {
    Name  = "Def_SecurityGroup"
    Owner = "Andrei Shtanakov"
  }
}




resource "aws_security_group" "test" {
  name          = "Prod Security Group"
  vpc_id        = aws_vpc.test.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.test.cidr_block]
  }
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
   tags = {
    Name  = "Test_SecurityGroup"
    Owner = "Andrei Shtanakov"
  }
}




resource "aws_vpc" "prod" {
  cidr_block = "10.10.0.0/16"

  tags = {
    Name = "prod-vpc-10"
  }
  enable_dns_hostnames = true
}

resource "aws_vpc" "test" {
  cidr_block = "10.20.0.0/16"

  tags = {
    Name = "test-vpc-20"
  }
  enable_dns_hostnames = true
}


#***************** PROD SUBNETS **************************************

#***************** PROD public SUBNETS *******************************


resource "aws_subnet" "prod_public-a" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.10.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name    = "Sub-public-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}

resource "aws_subnet" "prod_public-b" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.10.2.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name    = "Sub-public-2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}


resource "aws_subnet" "prod_public-c" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[2]
  cidr_block        = "10.10.3.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name    = "Sub-public-3 in ${data.aws_availability_zones.working.names[2]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}


#***************** PROD private SUBNETS *******************************


resource "aws_subnet" "prod_private-a" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.10.5.0/24"
  tags = {
    Name    = "Sub-private-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}

resource "aws_subnet" "prod_private-b" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.10.6.0/24"
  tags = {
    Name    = "Sub-private-2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}


resource "aws_subnet" "prod_private-c" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[2]
  cidr_block        = "10.10.7.0/24"
  tags = {
    Name    = "Sub-private-3 in ${data.aws_availability_zones.working.names[2]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}



#***************** PROD DB SUBNETS ***********************************


resource "aws_subnet" "prod_dbase-a" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[0]
  cidr_block        = "10.10.9.0/24"
  tags = {
    Name    = "Sub-db-1 in ${data.aws_availability_zones.working.names[0]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}

resource "aws_subnet" "prod_dbase-b" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[1]
  cidr_block        = "10.10.10.0/24"
  tags = {
    Name    = "Sub-db-2 in ${data.aws_availability_zones.working.names[1]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}


resource "aws_subnet" "prod_dbase-c" {
  vpc_id            = aws_vpc.prod.id
  availability_zone = data.aws_availability_zones.working.names[2]
  cidr_block        = "10.10.11.0/24"
  tags = {
    Name    = "Sub-db-3 in ${data.aws_availability_zones.working.names[2]}"
    Account = "Subnet in Account ${data.aws_caller_identity.current.account_id}"
    Region  = data.aws_region.current.description
  }
}


#*************** Internet Gareway ************************************

resource "aws_internet_gateway" "prod-gw" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "prod-gw"
  }
}

resource "aws_route_table_association" "prod-a" {
  subnet_id      = aws_subnet.prod_public-a.id
  route_table_id = aws_route_table.prod-route.id
}

resource "aws_route_table_association" "prod-b" {
  subnet_id      = aws_subnet.prod_public-b.id
  route_table_id = aws_route_table.prod-route.id
}

resource "aws_route_table_association" "prod-c" {
  subnet_id      = aws_subnet.prod_public-c.id
  route_table_id = aws_route_table.prod-route.id
}



resource "aws_route_table" "prod-route" {
  vpc_id = aws_vpc.prod.id

  tags = {
    Name = "prod-route"
  }
  depends_on = [aws_internet_gateway.prod-gw]
}

resource "aws_route" "r" {
  route_table_id            = aws_route_table.prod-route.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.prod-gw.id
  depends_on                = [aws_route_table.prod-route]
}



#*************** NAT    Gateway ************************************

#resource "aws_eip" "prod-a" {
#  vpc = true
#  depends_on                = [aws_internet_gateway.prod-gw]
#}

#resource "aws_eip" "prod-b" {
#  vpc = true
#  depends_on                = [aws_internet_gateway.prod-gw]
#}

#resource "aws_eip" "prod-c" {
#  vpc = true
#  depends_on                = [aws_internet_gateway.prod-gw]
#}

#************** A ***************************
#resource "aws_nat_gateway" "prod-nat-a" {
#  allocation_id = aws_eip.prod-a.id
#  subnet_id     = aws_subnet.prod_public-a.id
#  tags = {
#    Name = "gw NAT-a"
#  }
#  depends_on = [aws_internet_gateway.prod-gw]
#}

#3resource "aws_route_table_association" "prod-n-a" {
#  subnet_id      = aws_subnet.prod_private-a.id
#  route_table_id = aws_route_table.prod-route-private-a.id
#}
#resource "aws_route_table" "prod-route-private-a" {
#  vpc_id = aws_vpc.prod.id
#  tags = {
#    Name = "prod-route-private-a"
#  }
#  depends_on = [aws_nat_gateway.prod-nat-a]
#}

#resource "aws_route" "r-private-a" {
#3  route_table_id            = aws_route_table.prod-route-private-a.id
#  destination_cidr_block    = "0.0.0.0/0"
#  nat_gateway_id            = aws_nat_gateway.prod-nat-a.id
#  depends_on                = [aws_route_table.prod-route-private-a]
#}
#************** B ***************************
#resource "aws_nat_gateway" "prod-nat-b" {
#  allocation_id = aws_eip.prod-b.id
#  subnet_id     = aws_subnet.prod_public-b.id
#  tags = {
#    Name = "gw NAT-b"
#  }
#  depends_on = [aws_internet_gateway.prod-gw]
#}

#resource "aws_route_table_association" "prod-n-b" {
#  subnet_id      = aws_subnet.prod_private-b.id
#  route_table_id = aws_route_table.prod-route-private-b.id
#}
#resource "aws_route_table" "prod-route-private-b" {
#  vpc_id = aws_vpc.prod.id
#  tags = {
#    Name = "prod-route-private-b"
#  }
#  depends_on = [aws_nat_gateway.prod-nat-b]
#}

#resource "aws_route" "r-private-b" {
#3  route_table_id            = aws_route_table.prod-route-private-b.id
#  destination_cidr_block    = "0.0.0.0/0"
#  nat_gateway_id            = aws_nat_gateway.prod-nat-b.id
#3  depends_on                = [aws_route_table.prod-route-private-b]
#}

#************** C ***************************
#resource "aws_nat_gateway" "prod-nat-c" {
#  allocation_id = aws_eip.prod-c.id
#  subnet_id     = aws_subnet.prod_public-c.id
#  tags = {
#    Name = "gw NAT-c"
#  }
#  depends_on = [aws_internet_gateway.prod-gw]
#}


#resource "aws_route_table_association" "prod-n-c" {
#  subnet_id      = aws_subnet.prod_private-c.id
#  route_table_id = aws_route_table.prod-route-private-c.id
#}

#resource "aws_route_table" "prod-route-private-c" {
#  vpc_id = aws_vpc.prod.id
#  tags = {
#    Name = "prod-route-private-c"
#  }
#  depends_on = [aws_nat_gateway.prod-nat-c]
#}

#resource "aws_route" "r-private-c" {
#  route_table_id            = aws_route_table.prod-route-private-c.id
#  destination_cidr_block    = "0.0.0.0/0"
#  nat_gateway_id            = aws_nat_gateway.prod-nat-c.id
#  depends_on                = [aws_route_table.prod-route-private-c]
#}


#*************** END NAT Gateway ************************************


#*********************************************************************

resource "aws_key_pair" "test" {
  key_name   = "test"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCfk1mG0oYySWFG0/GQLjKAc4dC/ZlIvL5rHlZqQEfmDBt2Tr5iXwBbiQTv29QPglcDbRB/JlTt9GzjSnsGRh05YIUW1mGflgngNtgq+dDZOEBKZj++A1w5vj63Vltd5PIkgx3++1sKR3PsVZLV0gfj/v+n1g7REZQRVmukJfpdKRBOUk3O0nUxVxo4tXMp2irbUDdwZI4Z/QM1ugoTRKUQcB5V5KfnkaCbZ3GuHigV3aLdjEb1j2UI6feL1aQVwMJw/7nfyWlwuJ4x7r6+hKktb1SopmNRXPl7kKiKQb+AObUQEkfvXdOqdXnpcldJX/SyYxcYGtf5pShzJD7/FOm+TlhJ/Jum13ExL3ga79h4TzFelUsQNVCDFYJxqPLK26PvRPRHCZvVhiRi44FPsZiBY6EbU8M5qbymh44TKmHVQ8gg0Ii2rTeVH6l7HpLP6IE2pX83jUxKJ6egOjVhAtJDUMHq3vF8RW4FnlSDx9oLQ4I/sVOpHhA0RZa+qUwQnDc= user@epam2"
  tags = {
    Name    = "Key-test"
  }
}


output "aws_vpcs" {
  value = data.aws_vpcs.my_vpcs.id
}



