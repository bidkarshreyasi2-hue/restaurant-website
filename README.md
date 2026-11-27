# Saoji Tadka: Jenkins CI/CD + Terraform Mini Project

Static restaurant website (Home, Menu, Order) deployed to AWS EC2 (Nginx) by a Jenkins pipeline.
The EC2 server and its firewall are created with Terraform.

```
GitHub -> Jenkins (Checkout -> Validate -> Test -> Deploy via SSH) -> EC2 + Nginx
                                                          ^
                                          Terraform creates EC2 + Security Group
```

## Structure
| Path | Purpose |
|---|---|
| index.html, menu.html, order.html, css/, js/ | The website |
| Jenkinsfile | Pipeline: Checkout, Build/Validation, Test, Deploy |
| scripts/validate.sh, test.sh, deploy.sh | Stage scripts |
| terraform/ | main.tf, variables.tf, outputs.tf, terraform.tfvars |

## Steps

### 1. GitHub
```bash
git init && git add . && git commit -m "Restaurant website CI/CD"
git branch -M main
git remote add origin https://github.com/<you>/restaurant-website.git
git push -u origin main
```

### 2. Create an EC2 key pair (AWS Console)
EC2 > Key Pairs > Create key pair > name `restaurant-key`, type RSA, format `.pem`. Save the file.

### 3. Terraform
Edit `terraform/terraform.tfvars` if your key name differs. Then:
```bash
cd terraform
aws configure              # IAM user access key, region ap-south-1
terraform init
terraform plan
terraform apply            # type yes
terraform output public_ip
```
Open `http://<public_ip>`: you should see the default Nginx page (screenshot this).

### 4. Jenkins
1. Manage Jenkins > Credentials > Add > Kind **Secret file**, upload `restaurant-key.pem`, ID `ec2-ssh-key`.
2. New Item > `Restaurant-Website-CI-CD` > Pipeline.
3. Pipeline definition: *Pipeline script from SCM* > Git > your repo URL > branch `*/main` > Script Path `Jenkinsfile`.
4. Build with Parameters > `EC2_HOST` = the public IP from Terraform > Build.
5. Open `http://<public_ip>`: the Saoji Tadka website is live.

Jenkins must run on Linux, WSL or Docker because the stages use `sh`. On plain Windows Jenkins, install Git for Windows and make sure `bash` and `ssh` are on PATH, or switch `sh` to `bat`.

### 5. Prove the CI/CD loop
Change a heading in `index.html`, `git push`, build again, refresh the browser.

### 6. Clean up (avoids AWS charges)
```bash
cd terraform && terraform destroy
```
