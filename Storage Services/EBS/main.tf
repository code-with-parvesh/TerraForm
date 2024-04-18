terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.45.0"
    }
  }
}
provider "aws" {

    region = "us-east-1"
    profile = "default"

}

resource "aws_instance" "instance-1"{

    ami= "ami-010aff33ed5991201"
    instance_type = "t2.micro"

    tags = {

        Name = "For Testing Attach Vol"

    }
}

// Lets Try to fetch the AZ and ID

output "instanceVal1"{

    value = "Instance is Launcher -> ${aws_instance.instance-1.availability_zone}"

}

output "instanceVal2"{

    value = "ID of the Instance -> ${aws_instance.instance-1.id}"

}

resource "aws_ebs_volume" "volume" {

// Here , We need to give same AZ as the INstance Have.
    availability_zone = aws_instance.instance-1.availability_zone

// Size IN GiB
    size = 10

    tags = {

        Name = "terraformTesting"
    }    
}

// Lets Try To Print the AZ of volume and ID

output "volumeVal1" {

    value = "AZ of volume -> ${aws_ebs_volume.volume.availability_zone}"
    
}

output "volumeVal2" {

    value = "ID of Volume -> ${aws_ebs_volume.volume.id}"

}

resource "aws_volume_attachment" "ebsAttach" {

    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.volume.id
    instance_id = aws_instance.instance-1.id

}

output "Done" {

    value = "Finaly Done !!"
}