## Terraform Multi-Tier Web Application on AWS
# Project Overview

This project demonstrates the deployment of a highly available multi-tier web application infrastructure on AWS using Terraform Infrastructure as Code (IaC).

The architecture consists of:

    Application Load Balancer (ALB)
    EC2 Application Server
    Amazon RDS Database
    Public and Private Subnets
    NAT Gateway
    Internet Gateway
    Security Groups
    Route Tables
    Custom VPC

The project follows AWS best practices by placing the application server and database in private networks while exposing only the Load Balancer to the internet.
# Technologies Used
    Terraform
    AWS VPC
    AWS EC2
    AWS RDS
    AWS ALB
    AWS IAM
    AWS Security Groups
    NAT Gateway
    Route Tables

## Resources Created
    # Networking
         Custom VPC
         Public Subnet
         Private Subnet
         Internet Gateway
         NAT Gateway
         Route Tables
    # Security
         ALB Security Group
         EC2 Security Group
         RDS Security Group
    # Compute
         EC2 Instance
         User Data Script
    # Database
         Amazon RDS MySQL
    # Load Balancing
         Application Load Balancer
         Target Group
         Listener

# Step-by-Step Architecture Explanation

## Step 1: Configure AWS Provider

**File:** `provider.tf`

The AWS provider allows Terraform to communicate with AWS services. It specifies the AWS region where all resources will be created.

**Purpose:**

* Connect Terraform with AWS.
* Define deployment region.

---

## Step 2: Create VPC

**File:** `vpc.tf`

A Virtual Private Cloud (VPC) is created to provide an isolated network environment for the application.

**Purpose:**

* Acts as the foundation of the infrastructure.
* Provides network isolation.
* Controls IP addressing and routing.

Example CIDR:

```text
10.0.0.0/16
```

---

## Step 3: Create Public and Private Subnets

**File:** `subnet.tf`

Two subnets are created:

### Public Subnet

Hosts internet-facing resources.

Resources:

* Application Load Balancer
* NAT Gateway

### Private Subnet

Hosts secure backend resources.

Resources:

* EC2 Instance
* RDS Database

**Purpose:**

* Improve security.
* Separate public and private resources.

---

## Step 4: Create Internet Gateway

**File:** `igw.tf`

An Internet Gateway is attached to the VPC.

**Purpose:**

* Enables internet connectivity for public subnet resources.
* Allows external users to access the ALB.

Traffic Flow:

```text
Internet
    |
Internet Gateway
    |
Public Subnet
```

---

## Step 5: Create NAT Gateway

**File:** `nat.tf`

A NAT Gateway is deployed in the public subnet.

**Purpose:**

* Allows private resources to access the internet.
* Prevents inbound internet access to private resources.

Example:

* EC2 installs packages using apt update.
* EC2 downloads application dependencies.

Traffic Flow:

```text
Private EC2
     |
NAT Gateway
     |
Internet
```

---

## Step 6: Configure Route Tables

**File:** `route.tf`

Route tables define how network traffic moves inside the VPC.

### Public Route Table

```text
0.0.0.0/0 → Internet Gateway
```

Used by:

* ALB
* NAT Gateway

### Private Route Table

```text
0.0.0.0/0 → NAT Gateway
```

Used by:

* EC2
* RDS

**Purpose:**

* Control traffic routing.
* Ensure secure communication.

---

## Step 7: Create Security Groups

**File:** `security_groups.tf`

Security Groups act as virtual firewalls.

### ALB Security Group

Allows:

```text
HTTP (80)
HTTPS (443)
```

From:

```text
0.0.0.0/0
```

### EC2 Security Group

Allows:

```text
HTTP (80)
```

From:

```text
ALB Security Group
```

### RDS Security Group

Allows:

```text
MySQL (3306)
```

From:

```text
EC2 Security Group
```

**Purpose:**

* Restrict unauthorized access.
* Follow least-privilege principle.

---

## Step 8: Launch EC2 Instance

**File:** `ec2.tf`

An EC2 instance hosts the web application.

The instance is launched in the private subnet.

**Purpose:**

* Run application code.
* Process user requests.

The User Data script automatically:

* Updates packages.
* Installs Apache/Nginx.
* Deploys application files.

---

## Step 9: Create RDS Database

**File:** `rds.tf`

Amazon RDS MySQL is deployed in the private subnet.

**Purpose:**

* Store application data.
* Provide managed database services.

Benefits:

* Automated backups.
* High availability options.
* Easy maintenance.

---

## Step 10: Create Target Group

**File:** `target_group.tf`

The Target Group registers the EC2 instance.

**Purpose:**

* Receives traffic from the ALB.
* Forwards requests to healthy EC2 instances.

Health checks continuously verify instance health.

---

## Step 11: Create Application Load Balancer

**File:** `alb.tf`

The Application Load Balancer is deployed in the public subnet.

**Purpose:**

* Entry point for users.
* Distribute traffic to backend servers.
* Improve availability.

Traffic Flow:

```text
User
  |
  v
ALB
  |
Target Group
  |
EC2
```

---

## Step 12: Create Listener

**File:** `listener.tf`

The listener waits for incoming requests.

Example:

```text
Port 80 (HTTP)
```

When traffic arrives:

```text
ALB → Listener → Target Group → EC2
```

---

## Step 13: Configure Outputs

**File:** `outputs.tf`

Terraform displays important information after deployment.

Examples:

* ALB DNS Name
* VPC ID
* EC2 ID
* RDS Endpoint

**Purpose:**

* Easily access deployed resources.

---

## Complete Request Flow

```text
User
  |
Internet
  |
Internet Gateway
  |
Application Load Balancer
  |
Target Group
  |
EC2 Application Server
  |
Amazon RDS Database
```

This architecture follows a production-style design where only the Load Balancer is publicly accessible, while the EC2 instance and RDS database remain protected inside private subnets.

## Deployment Steps
### Clone Repository
    git clone <repository-url>
    cd terraform-multi-tier-app
### Initialize Terraform
    terraform init
### Validate Configuration
    terraform validate
### Preview Changes
    terraform plan
### Deploy Infrastructure
    terraform apply
### Destroy Infrastructure
    terraform destroy

