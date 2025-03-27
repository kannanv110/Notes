# Terraform
## What is Terraform?
Terraform is a powerful Infrastructure as Code (IaC) tool that allows you to define and manage your infrastructure using code. 
## Key Concepts:
### Infrastructure as Code (IaC):
Terraform enables you to manage and provision infrastructure using code, rather than manual processes.
### Declarative Language (HCL):
It uses HashiCorp Configuration Language (HCL) to define the desired state of your infrastructure.
### Providers:
Terraform works with various cloud providers (AWS, Azure, GCP, etc.) and other services through "providers," which are plugins that interact with their APIs.
### State:
Terraform maintains a "state" file that tracks the current state of your infrastructure, allowing it to plan and apply changes accurately.
### Modules:
Terraform allows the creation of reusable modules, to better organize and share infrastructure code.
### Terraform workflow:
Terraform has a workflow that includes the following commands:
 - terraform init: Initializes the working directory.
 - terraform validate: Validates the configuration files.
 - terraform plan: Shows the changes that will be made.
 - terraform apply: Applies the changes to create or modify the infrastructure.

## Key Benefits:
### Multi-Cloud Support:
Terraform can manage infrastructure across multiple cloud providers.
### Automation:
It automates infrastructure provisioning and management.
### Version Control:
Infrastructure code can be version-controlled, enabling collaboration and tracking changes.
### Consistency:
It ensures consistent infrastructure deployments.

In essence, Terraform simplifies the process of managing complex infrastructure by treating it as code.

## Types of IaC tools

### Provisioning tools
Provisioning tools streamline the process of setting up and managing IT infrastructure, contributing to greater efficiency, reliability, and scalability. Well know tools are
 - Terraform
 - AWS Cloudformation

### Server Templating
Server templating tools streamline server provisioning by creating reusable and consistent server images, contributing to more efficient and reliable infrastructure management. Well known tools are
 - docker
 - packer
 - vagrant

### Configuration Management
Configuration management tools streamline IT operations by automating configuration tasks and ensuring consistency across infrastructure. Well known tools are
 - Ansible
 - puppet
 - chef
 - saltstack

## Installing Terraform and HCL basics

### Installing Terraform
#### Download and Install
Terraform can be installed by downloading the binary for your operating system (Windows, Mac, Linux, etc.) and copying it to your system path.
#### Supported OS
It works on popular operating systems like Windows, Mac, Linux, Solaris, and OpenBSD.

### HashiCorp Configuration Language (HCL)
#### Configuration Files
Terraform uses configuration files written in HCL, with a .tf extension.
#### Blocks and Arguments
These files are made up of blocks (enclosed in curly braces {}) and arguments (key-value pairs).

### Resource Block Example
#### Structure
The resource block starts with the keyword resource, followed by the resource type (e.g., local_file) and a logical name (e.g., pet).
#### Arguments
Inside the block, you define arguments specific to the resource type, like filename and content for a local file.


### Terraform Workflow
 - Write Configuration: Create a .tf file with the desired resource definitions.
    ```
    resource local_file pet_file {
        filename = 'pets.txt'
        content = 'I've lovely dog'
    }
    ```
 - Initialize: Run terraform init to download necessary provider plugins.
    ```shell
    [kannan@localhost]$terraform init
    Initializing the backend...
    Initializing provider plugins...
    - Finding latest version of hashicorp/local...
    - Installing hashicorp/local v2.5.2...
    - Installed hashicorp/local v2.5.2 (signed by HashiCorp)
    Terraform has created a lock file .terraform.lock.hcl to record the provider
    selections it made above. Include this file in your version control repository
    so that Terraform can guarantee to make the same selections by default when
    you run "terraform init" in the future.

    Terraform has been successfully initialized!

    You may now begin working with Terraform. Try running "terraform plan" to see
    any changes that are required for your infrastructure. All Terraform commands
    should now work.

    If you ever set or change modules or backend configuration for Terraform,
    rerun this command to reinitialize your working directory. If you forget, other
    commands will detect it and remind you to do so if necessary.
    ```
    - Plan: Use terraform plan to review the actions Terraform will take.
    ```shell
    [kannan@localhost]$ terraform plan

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
    symbols:
    + create

    Terraform will perform the following actions:

    # local_file.pet_file will be created
    + resource "local_file" "pet_file" {
        + content              = "I love pets!"
        + content_base64sha256 = (known after apply)
        + content_base64sha512 = (known after apply)
        + content_md5          = (known after apply)
        + content_sha1         = (known after apply)
        + content_sha256       = (known after apply)
        + content_sha512       = (known after apply)
        + directory_permission = "0777"
        + file_permission      = "0777"
        + filename             = "pet.txt"
        + id                   = (known after apply)
        }

    Plan: 1 to add, 0 to change, 0 to destroy.

    ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

    Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run
    "terraform apply" now.
    ```
 - Apply: Execute terraform apply to create the resources, confirming with yes.
    By default the apply will prompt to confirm to proceed provision. You can skip it by command line option `-auto-approve` but use with caution.
    ```shell
    [kannan@localhost]$ terraform apply

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
    symbols:
    + create

    Terraform will perform the following actions:

    # local_file.pet_file will be created
    + resource "local_file" "pet_file" {
        + content              = "I love pets!"
        + content_base64sha256 = (known after apply)
        + content_base64sha512 = (known after apply)
        + content_md5          = (known after apply)
        + content_sha1         = (known after apply)
        + content_sha256       = (known after apply)
        + content_sha512       = (known after apply)
        + directory_permission = "0777"
        + file_permission      = "0777"
        + filename             = "pet.txt"
        + id                   = (known after apply)
        }

    Plan: 1 to add, 0 to change, 0 to destroy.

    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value: yes

    local_file.pet_file: Creating...
    local_file.pet_file: Creation complete after 0s [id=7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68]

    Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
    ```

### Example Resources
 - Local File: Creates a file on the local system.
 - AWS EC2 Instance: Provisions an EC2 instance on AWS.
 - AWS S3 Bucket: Creates an S3 bucket on AWS.

### Best Practices
 - Review Plans: Always review the execution plan before applying changes.
 - Documentation: Refer to Terraform documentation for valid arguments for each resource type.

## Create, update, and destroy infrastructure

### Creating Infrastructure

#### Configuration File
Define the infrastructure in a .tf file. For example, to create a local file, you specify the file name and content.

#### Commands
 - `terraform init`: Initializes the directory and downloads necessary plugins.
 - `terraform apply`: Creates the resources as defined in the configuration file.

```
resource local_file pet_file {
    filename = 'pets.txt'
    content = 'I've lovely dog'
}
```

### Updating Infrastructure

#### Modify Configuration
To update a resource, change the configuration file. For example, add an argument to change file permissions.
```
resource local_file pet_file {
    filename = 'pets.txt'
    content = 'I've lovely dog'
    permission = '0700'
}
```
#### Execution Plan
 - `terraform plan`: Shows the execution plan. The -/+ symbol indicates the resource will be deleted and recreated.

    ```shell
    [SHELL]$ terraform plan
    local_file.pet_file: Refreshing state... [id=7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
    symbols:
    -/+ destroy and then create replacement

    Terraform will perform the following actions:

    # local_file.pet_file must be replaced
    -/+ resource "local_file" "pet_file" {
        ~ content_base64sha256 = "4LBQ/UV/Gxp6DWNEp+upXEfPrTTpUCpfiAkOpJixJEc=" -> (known after apply)
        ~ content_base64sha512 = "wKb93aeKXXwWVvqgU6yfOuiKC6dLDLLWp7dclsVtlgenVx4/BUpKiEnsdA6EbHgUmSDTp/+Si9wFeXH8/46Eiw==" -> (known after apply)
        ~ content_md5          = "3dd08189b6cbd661de6b25ed369f5746" -> (known after apply)
        ~ content_sha1         = "7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68" -> (known after apply)
        ~ content_sha256       = "e0b050fd457f1b1a7a0d6344a7eba95c47cfad34e9502a5f88090ea498b12447" -> (known after apply)
        ~ content_sha512       = "c0a6fddda78a5d7c1656faa053ac9f3ae88a0ba74b0cb2d6a7b75c96c56d9607a7571e3f054a4a8849ec740e846c78149920d3a7ff928bdc057971fcff8e848b" -> (known after apply)
        ~ file_permission      = "0777" -> "0700" # forces replacement
        ~ id                   = "7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68" -> (known after apply)
            # (3 unchanged attributes hidden)
        }

    Plan: 1 to add, 0 to change, 1 to destroy.

    ─────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

    Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run
    "terraform apply" now.
    ```

 - `terraform apply`: Applies the changes, adhering to the concept of immutability (resources are recreated rather than modified in place).

    ```shell
    [SHELL]$ terraform apply
    local_file.pet_file: Refreshing state... [id=7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
    symbols:
    -/+ destroy and then create replacement

    Terraform will perform the following actions:

    # local_file.pet_file must be replaced
    -/+ resource "local_file" "pet_file" {
        ~ content_base64sha256 = "4LBQ/UV/Gxp6DWNEp+upXEfPrTTpUCpfiAkOpJixJEc=" -> (known after apply)
        ~ content_base64sha512 = "wKb93aeKXXwWVvqgU6yfOuiKC6dLDLLWp7dclsVtlgenVx4/BUpKiEnsdA6EbHgUmSDTp/+Si9wFeXH8/46Eiw==" -> (known after apply)
        ~ content_md5          = "3dd08189b6cbd661de6b25ed369f5746" -> (known after apply)
        ~ content_sha1         = "7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68" -> (known after apply)
        ~ content_sha256       = "e0b050fd457f1b1a7a0d6344a7eba95c47cfad34e9502a5f88090ea498b12447" -> (known after apply)
        ~ content_sha512       = "c0a6fddda78a5d7c1656faa053ac9f3ae88a0ba74b0cb2d6a7b75c96c56d9607a7571e3f054a4a8849ec740e846c78149920d3a7ff928bdc057971fcff8e848b" -> (known after apply)
        ~ file_permission      = "0777" -> "0700" # forces replacement
        ~ id                   = "7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68" -> (known after apply)
            # (3 unchanged attributes hidden)
        }

    Plan: 1 to add, 0 to change, 1 to destroy.

    Do you want to perform these actions?
    Terraform will perform the actions described above.
    Only 'yes' will be accepted to approve.

    Enter a value: yes

    local_file.pet_file: Destroying... [id=7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68]
    local_file.pet_file: Destruction complete after 0s
    local_file.pet_file: Creating...
    local_file.pet_file: Creation complete after 0s [id=7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68]

    Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
    ```
### Destroying Infrastructure

#### Command:
 - `terraform destroy`: Deletes the resources. The execution plan shows a - symbol next to resources to be destroyed.

    ```shell
    terraform destroy
    local_file.pet_file: Refreshing state... [id=7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68]

    Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
    symbols:
    - destroy

    Terraform will perform the following actions:

    # local_file.pet_file will be destroyed
    - resource "local_file" "pet_file" {
        - content              = "I love pets!" -> null
        - content_base64sha256 = "4LBQ/UV/Gxp6DWNEp+upXEfPrTTpUCpfiAkOpJixJEc=" -> null
        - content_base64sha512 = "wKb93aeKXXwWVvqgU6yfOuiKC6dLDLLWp7dclsVtlgenVx4/BUpKiEnsdA6EbHgUmSDTp/+Si9wFeXH8/46Eiw==" -> null
        - content_md5          = "3dd08189b6cbd661de6b25ed369f5746" -> null
        - content_sha1         = "7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68" -> null
        - content_sha256       = "e0b050fd457f1b1a7a0d6344a7eba95c47cfad34e9502a5f88090ea498b12447" -> null
        - content_sha512       = "c0a6fddda78a5d7c1656faa053ac9f3ae88a0ba74b0cb2d6a7b75c96c56d9607a7571e3f054a4a8849ec740e846c78149920d3a7ff928bdc057971fcff8e848b" -> null
        - directory_permission = "0777" -> null
        - file_permission      = "0700" -> null
        - filename             = "pet.txt" -> null
        - id                   = "7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68" -> null
        }

    Plan: 0 to add, 0 to change, 1 to destroy.

    Do you really want to destroy all resources?
    Terraform will destroy all your managed infrastructure, as shown above.
    There is no undo. Only 'yes' will be accepted to confirm.

    Enter a value: yes

    local_file.pet_file: Destroying... [id=7e4db4fbfdbb108bdd04692602bae3e9bd1e1b68]
    local_file.pet_file: Destruction complete after 0s

    Destroy complete! Resources: 1 destroyed.
    ```

#### Confirmation
You need to confirm the destruction by typing yes, or use the `-auto-approve` flag to skip confirmation (use with caution).

### Managing Configuration Files

#### Multiple Files
You can split your configuration into multiple .tf files for better management. For example, 
 - main.tf for main configurations
 - variables.tf for variables
 - outputs.tf for outputs from resources
 - provider.tf for provider definition
 - terraform.tf Configure terraform behaviour

#### Single File
Alternatively, you can keep all configurations in a single file, but it may become difficult to manage over time.

### Best Practices

#### Review Plans
Always review the execution plan before applying changes to understand the impact.

#### Directory Structure
Organize your configuration files logically to make them easier to manage.


## Terraform Providers
These are plugins that allow Terraform to interact with various platforms like AWS, GCP, and Azure. They are essential for provisioning resources on these platforms.
### Types of Providers
#### Official Providers
Maintained by HashiCorp, including major cloud providers.
#### Partner Providers
Maintained by third-party companies but reviewed by HashiCorp.
#### Community Providers
Created and maintained by individual contributors.

### Download Plugin
`terraform init` This command initializes your Terraform configuration and downloads the necessary provider plugins. It's safe to run multiple times without affecting your infrastructure.
### Plugin Storage
The downloaded plugins are stored in a hidden directory called .terraform/plugins in your working directory.
### Plugin Naming
The plugin name includes the organization (e.g., hashicorp), the provider type (e.g., local), and optionally, the registry host name. URL for terraform registry is registry.terraform.io.

## Multiple providers
Using multiple providers in a single Terraform configuration allows you to manage resources from different platforms within the same configuration file. For example, you can manage both AWS and local resources together.

To view the required provider for the current configuration
```shell
[SHELL]$ terraform providers

Providers required by configuration:
.
├── provider[registry.terraform.io/hashicorp/random]
└── provider[registry.terraform.io/hashicorp/local]

Providers required by state:

    provider[registry.terraform.io/hashicorp/local]

    provider[registry.terraform.io/hashicorp/random]
```
To view installed plugins with version

```shell
[SHELL]$ terraform version
Terraform v1.9.5
on linux_amd64
+ provider registry.terraform.io/hashicorp/local v2.5.2
+ provider registry.terraform.io/hashicorp/random v3.7.1

Your version of Terraform is out of date! The latest version
is 1.11.1. You can update by downloading from https://www.terraform.io/downloads.html
```

```
resource local_file "local_file" {
    filename = "local-file.txt"
    content = "This is a local file"
}
```
```shell
[SHELL]$ terraform init
Initializing the backend...
Initializing provider plugins...
- Finding latest version of hashicorp/local...
- Installing hashicorp/local v2.5.2...
- Installed hashicorp/local v2.5.2 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
### Adding a New Provider
When you add a resource block for a new provider that hasn't been used before in your configuration, you need to run the terraform init command again. This command downloads and installs the necessary plugin for the new provider.
```
resource local_file "local_file" {
    filename = "local-file.txt"
    content = "This is a local file"
}

resource random_pet "random_pet"{
    length = 2
    prefix = "Mrs."
}
```
In the example given, the main.tf file has two resource blocks: one for the local provider and one for the random provider. The local provider was already installed, so it is reused, but the random provider plugin needs to be downloaded and installed.

```shell
[SHELL]$ terraform plan
╷
│ Error: Inconsistent dependency lock file
│ 
│ The following dependency selections recorded in the lock file are inconsistent with the current configuration:
│   - provider registry.terraform.io/hashicorp/random: required by this configuration but no version is selected
│ 
│ To update the locked dependency selections to match a changed configuration, run:
│   terraform init -upgrade

[SHELL]$ terraform init
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of hashicorp/local from the dependency lock file
- Finding latest version of hashicorp/random...
- Using previously-installed hashicorp/local v2.5.2
- Installing hashicorp/random v3.7.1...
- Installed hashicorp/random v3.7.1 (signed by HashiCorp)
Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
## Version Constraints
Version constraints in Terraform help you control which version of a provider plugin is used in your configurations. 

### Default Behavior
By default, terraform init downloads the latest version of provider plugins. This can cause issues if your configuration was written for a different version.

### Specifying Versions
You can specify a particular version of a provider using the required_providers block inside the terraform block. For example:
```hcl
terraform {
    required_providers {
        local = {
            source = "hashicorp/local"
            version = "2.4.0"
        }
    }
}
resource "local_file" "test_file"{
    filename = "test.txt"
    content = "This is test file"
}
```
```shell
[SHELL]$ terraform init
Initializing the backend...
Initializing provider plugins...
- Reusing previous version of hashicorp/local from the dependency lock file
- Reusing previous version of hashicorp/random from the dependency lock file
- Using previously-installed hashicorp/random v3.7.1
╷
│ Error: Failed to query available provider packages
│ 
│ Could not retrieve the list of available versions for provider hashicorp/local: locked provider
│ registry.terraform.io/hashicorp/local 2.5.2 does not match configured version constraint 2.4.0; must use
│ terraform init -upgrade to allow selection of new versions
```

```shell
[SHELL]$ terraform init -upgrade
Initializing the backend...
Initializing provider plugins...
- Finding hashicorp/local versions matching "2.4.0"...
- Finding latest version of hashicorp/random...
- Installing hashicorp/local v2.4.0...
- Installed hashicorp/local v2.4.0 (signed by HashiCorp)
- Using previously-installed hashicorp/random v3.7.1
Terraform has made some changes to the provider dependency selections recorded
in the .terraform.lock.hcl file. Review those changes and commit them to your
version control system if they represent changes you intended to make.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
### Version Constraints
You can use operators to control versions

 - != ensures a specific version is not used.
 - Comparison operators (<, >, <=, >=) specify acceptable version ranges.
 - ~> (pessimistic constraint) allows incremental updates within a specified version range.
   
   For example, ~> 1.2.0 means any version from 1.2.0 to 1.2.9 can be used.

These constraints help ensure compatibility and stability in your infrastructure, similar to managing software versions in your current role.

## Provider Aliases
### Provider Block
Normally, you define a provider block to specify the configuration for a provider, like AWS, including the region.
#### Issue
If you want to create resources in different regions, a single provider block won't suffice because it can only specify one region.
#### Solution - Aliases
You can use aliases to define multiple configurations for the same provider. This allows you to create resources in different regions.

#### Example:
main.tf
```
resource "Aws_key_pair" "alpha" {
    key_name = "alpha"
    public_key = "ssh-rsa ....."
}
resource "aws_key_pair" "beta" {
    key_name = "beta"
    public_key = "ssh-rsa ....."
    provider = aws.central
}

```
provider.tf
```
provider "aws" {
    region = "us-east-1"
}
provider "aws" {
    alias = "central"
    region = "ca-central-1"
}
```
The above example create 2 keys on 2 aws regions.

By using aliases, you can manage resources across multiple regions or configurations more efficiently, which is particularly useful in complex IT environments like the one you work in.
