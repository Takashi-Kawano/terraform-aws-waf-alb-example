# terraform-aws-waf-alb-sample

Sample ALB-EC2 simple configuration to try out the WAF settings.

## Usage example

```
module "sample" {
    source  = "Takashi-Kawano/waf-alb-sample/aws"
    version = "1.0.2"

    alb_name    = "test"
    alb_tg_name = "test"
    alb_sg_name = "test_alb_sg"

    ec2_ami           = "ami-0f02b24005e4aec36"
    ec2_instance_type = "t3.micro"
    ec2_name          = "test_ec2"
    ec2_sg_name       = "test_ec2_sg"

    vpc_cidr_block            = "10.1.0.0/16"

    public1_subnet_cidr_block = "10.1.0.0/24"
    public2_subnet_cidr_block = "10.1.1.0/24"
    private_subnet_cidr_block = "10.1.2.0/24"

    public1_subnet_availability_zone = "ap-southeast-1a"
    public2_subnet_availability_zone = "ap-southeast-1c"
    private_subnet_availability_zone = "ap-southeast-1a"


    allow_ip = "127.0.0.1/32"
}

output "dns_name" {
    value = "${module.sample.dns_name}"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb\_name | The resource name of the alb. | string | n/a | yes |
| alb\_sg\_name | The resource name of the alb's security group. | string | n/a | yes |
| alb\_tg\_name | The resource name of the alb's target group. | string | n/a | yes |
| allow\_ip | IP allowd in waf rule | string | n/a | yes |
| ec2\_ami | AMI of the ec2. | string | n/a | yes |
| ec2\_instance\_type | instance type of the ec2. | string | n/a | yes |
| ec2\_name | Name tag of the ec2. | string | n/a | yes |
| ec2\_sg\_name | The resource name of the ec2's security group'. | string | n/a | yes |
| private\_subnet\_availability\_zone | AZ used in private subnet | string | n/a | yes |
| private\_subnet\_cidr\_block | This is a network for placing a ec2. | string | n/a | yes |
| public1\_subnet\_availability\_zone | AZ used in public1 subnet. | string | n/a | yes |
| public1\_subnet\_cidr\_block | This is a network for placing a NAT gateway. Also used for ALB's Multi-AZ. | string | n/a | yes |
| public2\_subnet\_availability\_zone | AZ used in public2 subnet. Specify something diffrent from public1\_subnet\_availability\_zone | string | n/a | yes |
| public2\_subnet\_cidr\_block | Used for ALB's Multi-AZ. | string | n/a | yes |
| vpc\_cidr\_block | cidr block of vpc'. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dns\_name | The DNS name of the alb. |

## License
MIT
