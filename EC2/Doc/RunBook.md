# On-boarding Task

Deploy a single machine to the AWS Development environment using terraform.

### Prerequisites

Things you need to install the software and how to install them

  ##### 1. Terraform on Ubuntu / Ubuntu cloud server


- Download required version of the terraform using (https://www.terraform.io/downloads.html)

- Extract the downloaded file archive -> unzip terraform_0. 0.11.linux_amd64.zip

- Move the executable into a directory searched for executable -> sudo mv terraform /usr/local/bin/

- Check the terraform version -> terraform --version.

##### 2. Create Account in AWS Console.

### Creating the Infrastructure

##### -> Terraform init

######  This will download and install the proper version of the AWS provider for your project and place it in a directory called .terraform.

##### -> Terraform apply

######  We'll now run the command that will take the configurations we've  written and use the AWS API to build our servers. This command is one  that you'll be using throughout most of your time with Terraform

##### Note:
Always read this plan carefully and take note of what's being created,  modified or destroyed. This will prevent you from accidentally  destroying infrastructure that does not need to be modified.

- You can type yes and hit Enter to create the new server.

### Destroying the Infrastructure

##### -> Terraform destroy

######  Destruction of resources will happen on a smaller scale, through certain configuration changes.
