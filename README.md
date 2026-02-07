# Lab-3
                                                          HERE IS THE ARCHITECTURE
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/6f48bb3d-31cf-42f6-860d-5a81e82d6f41" />


User
  ↓
Route 53 (DNS)
  ↓
CloudFront Distribution
  └── Protected by AWS WAF (named Web ACL)
  ↓
Application Load Balancer (ALB)
  ↓
Auto Scaling Group (ASG)
  └── 1 EC2 instance in São Paulo (sa-east-1)
  ↓
Database in Japan (ap-northeast-1)





Here is Lab 3 and here is how you will run it.

First Thing
I am assuming you did not do any of the previous labs so here is an explanation as to how this will work.




   HOW TO USE




Change the SNS EMAIL on both state files so you get the notificaiton.(Check the var file and find it there).
Change the import route53 domain registered domain(Line 779)(main.tf in Sao Paulo) from my domain to your domain after you bought it from whatever source. We are doing this through aws so put the domain in route 53. It's not configured to use any other method.

Run terraform apply -auto-approve
On both Japan and Sao Paulo

After the apply, go to Japan, and at Transit Gateways at line 531, change it from false to true. This will initiate a tgw peering connection the the tgw in Sao Paulo.
Run terraform apply -auto-approve on Japan's state file

Go to Sao Paulo state file, change line 1713, change it from false to true. This will accept the peering request from Japan.
Run terraform apply -auto-approve on Sao Paulo's state file

Go to Japan, go to line 637, change this line from false to true, this will create the route's in your vpc route table and create an association in the tgw route table pointing to the peering connection.
Run terraform apply -auto-approve on Japan's state file

Go to Japan, go to line 1813, change this line from false to true, this will create the route's in your vpc route table and create an association in the tgw route table pointing to the peering connection.
Run terraform apply -auto-approve on Sao Paulo's state file


If you destroy and recreate in the same region, you need to change the variable "secret_location" at line 85 in var.tf of Sao Paulo and change the variable "secret_location" at line 81 in var.tf of in Japan. Go to userdata.sh in Sao Paulo and change line 17 and 107.

That is how you use it.


##############################################
              MORE INFORMATION
##############################################

🏥 Lab 3 — Japan Medical
Cross-Region Architecture with Legal Data Residency (APPI-Compliant)

This repository implements a realistic, legally compliant, cross-region medical application architecture on AWS.

The system delivers global access through a single URL while enforcing a strict legal constraint:

All Japanese patient medical data (PHI) is stored only in Japan.

This is not a theoretical design.
This is how regulated healthcare systems are actually built.

🎯 Lab Objective

Design and deploy a multi-region AWS architecture that:

Uses two AWS regions

Tokyo (ap-northeast-1) — data authority

São Paulo (sa-east-1) — compute extension

Serves traffic through one global URL

Uses CloudFront + AWS WAF at the edge

Connects regions using AWS Transit Gateway

Stores all PHI only in Japan

Allows overseas doctors to legally read and write records

Maintains clear auditability and traffic visibility

This lab intentionally mirrors real DevOps and platform engineering realities:

Environments are separated

Terraform states are split

Pipelines are independent

Coordination matters more than copy-paste

🏛️ Real-World Context: Why This Architecture Exists

Japan’s privacy law — 個人情報保護法 (APPI) — imposes strict controls on how personal and medical data is handled.

For healthcare systems, the safest and most common interpretation is:

Japanese patient medical data must be stored physically inside Japan.

This applies even when:

The patient is traveling

The doctor is overseas

The application is accessed globally

Key Principle

Access is allowed. Storage is not.

This lab models how real medical platforms comply with that rule.

🌍 Regional Roles
🇯🇵 Tokyo — Primary Region (Data Authority)

Tokyo is the single source of truth.

It contains:

RDS (medical records)

Primary VPC

Application tier

Transit Gateway (hub)

Parameter Store & Secrets Manager (authoritative)

Logging, auditing, and backups

All data at rest lives here.

If Tokyo becomes unavailable:

The system may degrade

Data residency is never violated

This behavior is intentional and correct.

🇧🇷 São Paulo — Secondary Region (Compute-Only)

São Paulo exists to serve doctors and staff physically located in South America.

It contains:

VPC

EC2 + Auto Scaling Group

Application tier

Transit Gateway (spoke)

It explicitly does not contain:

RDS

Read replicas

Backups

Persistent storage of PHI

São Paulo is stateless compute.
All reads and writes go directly to Tokyo.

🌐 Networking Model
Why Transit Gateway (Not VPC Peering)

Transit Gateway is used instead of VPC peering because it provides:

Centralized routing control

Clear, auditable traffic paths

Enterprise-grade segmentation

A visible “data corridor” for compliance reviews

In regulated environments:

Clarity beats convenience.


