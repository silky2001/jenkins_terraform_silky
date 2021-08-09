# Jenkins Installation through Terraform Script

To install Jenkins master through Terraform. Submit the Terraform code and your Jenkins master is ready in 2 minutes.

1) Review the Terraform Code.
     Main.tf variables.tf outputs.tf
2) Run Terraform Plan.
3) Run Terraform apply -auto-approve.
4) Get public IP from outputs.
5) Got o browser, use public IP with port 8080 to load Jenkins.

# Technologies Used

### Jenkins
Jenkins is a free and open source automation server. It helps automate the parts of software development related to building, testing, and deploying, facilitating continuous integration and continuous delivery. It is a server-based system that runs in servlet containers such as Apache Tomcat.

### Terraform
Terraform is an open-source infrastructure as code software tool created by HashiCorp. Users define and provision data center infrastructure using a declarative configuration language known as HashiCorp Configuration Language, or optionally JSON.

## The env's lifecyle - init, plan, apply, destroy:: 
```
cd main

terraform init                        # Downloads and installs all the required modules for this project.
terraform plan                        # Show the components terraform will create or update on AWS once applied with Terraform.
terraform apply                       # Perform all the actions shown in the plan above.
terraform destroy                     # Once the env is not needed anymore, the destroy command will remove all its installed components from AWS.
```
