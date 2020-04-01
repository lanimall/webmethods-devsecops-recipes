
###### API GATEWAY ###### 
resource "aws_security_group" "apigateway" {
  name        = "${local.name_prefix_short}-apigw"
  description = "Software AG API Gateway Server"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port = 5555
    to_port   = 5555
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block,
        data.aws_subnet.COMMON_DMZ.*.cidr_block,
        data.aws_subnet.COMMON_WEB.*.cidr_block
      ]
    )
  }

  ingress {
    from_port = 9999
    to_port   = 9999
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block,
        data.aws_subnet.COMMON_WEB.*.cidr_block
      ]
    )
  }

  ingress {
    from_port = 9072
    to_port   = 9073
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block,
        data.aws_subnet.COMMON_DMZ.*.cidr_block,
        data.aws_subnet.COMMON_WEB.*.cidr_block
      ]
    )
  }

  ##SPM communication
  ingress {
    from_port   = 8092
    to_port     = 8093
    protocol    = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block
      ]
    )
  }

  ### TODO: Need to figure out what exact port to allow in egress
  ### likely the elastic search node to node communication
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      data.aws_vpc.main.cidr_block
    ]
  }

  //  Use our common tags and add a specific name.
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix_long}-apigateway"
      "az"   = "all"
    },
  )
}

###### API GATEWAY INTERNAL DATASTORE ###### 
resource "aws_security_group" "apigateway_internaldatastore" {
  name        = "${local.name_prefix_short}-apigw-es"
  description = "Software AG API Gateway Internal Data Store"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port = 9240
    to_port   = 9240
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block,
        data.aws_subnet.COMMON_WEB.*.cidr_block
      ]
    )
  }

  ingress {
    from_port = 9340
    to_port   = 9340
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block,
        data.aws_subnet.COMMON_WEB.*.cidr_block
      ]
    )
  }

  ##SPM communication
  ingress {
    from_port   = 8092
    to_port     = 8093
    protocol    = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block
      ]
    )
  }

  ### TODO: Need to figure out what exact port to allow in egress
  ### likely the elastic search node to node communication
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      data.aws_vpc.main.cidr_block
    ]
  }

  //  Use our common tags and add a specific name.
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix_long}-apigateway-elastic-search"
      "az"   = "all"
    },
  )
}

###### TERRACOTTA FOR APIGATEWAY ###### 
resource "aws_security_group" "apigateway_terracotta" {
  name        = "${local.name_prefix_short}-apigw-tc"
  description = "Terracotta for Api Gateway Clustering"
  vpc_id      = data.aws_vpc.main.id

  ## Terracotta ports
  ingress {
    from_port = 9510
    to_port   = 9510
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block,
        data.aws_subnet.COMMON_WEB.*.cidr_block
      ]
    )
  }

  ingress {
    from_port = 9520
    to_port   = 9520
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block,
        data.aws_subnet.COMMON_WEB.*.cidr_block
      ]
    )
  }

  ingress {
    from_port = 9530
    to_port   = 9530
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block,
        data.aws_subnet.COMMON_WEB.*.cidr_block
      ]
    )
  }

  ingress {
    from_port = 9540
    to_port   = 9540
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block,
        data.aws_subnet.COMMON_WEB.*.cidr_block
      ]
    )
  }

  ## TMC ports
  ingress {
    from_port = 9443
    to_port   = 9443
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block
      ]
    )
  }

  ingress {
    from_port = 9889
    to_port   = 9889
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block
      ]
    )
  }

  ##SPM communication
  ingress {
    from_port   = 8092
    to_port     = 8093
    protocol    = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block
      ]
    )
  }

  ### TODO: Need to figure out what exact port to allow in egress
  ### likely the elastic search node to node communication
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block,
        data.aws_subnet.COMMON_WEB.*.cidr_block
      ]
    )
  }

  //Use our common tags and add a specific name.
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix_long}-apigateway-terracotta"
      "az"   = "all"
    },
  )
}

###### API PORTAL ###### 
resource "aws_security_group" "apiportal" {
  name        = "${local.name_prefix_short}-apiportal"
  description = "Software AG API Portal Server"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port = 18101
    to_port   = 18102
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block,
        data.aws_subnet.COMMON_DMZ.*.cidr_block
      ]
    )
  }

  ## that's for ACC agent (port is not always the same accross versions)
  ingress {
    from_port = 18000
    to_port   = 18020
    protocol  = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block,
      ]
    )
  }

  ##SPM communication
  ingress {
    from_port   = 8092
    to_port     = 8093
    protocol    = "tcp"
    cidr_blocks = flatten(
      [
        data.aws_subnet.COMMON_MGT.*.cidr_block
      ]
    )
  }

  ### TODO: Need to figure out what exact port to allow in egress
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [
      data.aws_vpc.main.cidr_block
    ]
  }

  //  Use our common tags and add a specific name.
  tags = merge(
    local.common_tags,
    {
      "Name" = "${local.name_prefix_long}-apiportal"
      "az"   = "all"
    },
  )
}