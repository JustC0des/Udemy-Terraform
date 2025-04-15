# 2. Erste Schritte in Terraform

## 2.1 Windows Installation

```shell
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco --version

choco install terraform

where terraform

choco uninstall terraform -x
```
```shell
# Binary installieren und an einem Ort ablgeen
# Binary Ordner zu PAth hinzufügen
# CMD neu starten
terraform --version
where terraform
```

## 2.2 Linux installation

### 2.2.1 Ubuntu

```bash
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform
```

### 2.2.2 Amazon Linux

```bash
sudo yum install -y yum-utils shadow-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum -y install terraform
```
# 3. Grundlagen des Workflows und Zustandsmanagement

## 3.3 Terraform State Befehle
```shell
terraform state list
terraform state list aws_instance.example
terraform state list module.vpc
terraform satte list -id =sg-003459fa17315ba9f
terraform state show data.aws_instances.all
terraform state show module.vpc.aws_security_group.ec2
terraform state show aws_ebs_volume.my_ebs_volume[0]
terraform state show aws_instance.example[\"0\"]
terraform apply -replace="aws_instance.example[\"0\"]"
terraform state mv data.aws_instances.all data.aws_instances.new
terraform state mv data.aws_instances.new module.vpc.data.aws_instances.new
terraform state mv aws_volume_attachment.my_volume_attachment[0] aws_volume_attachment.my_volume-attachment[0]
terraform state mv aws_volume_attachment.my_volume_attachment[1] aws_volume_attachment.my_volume-attachment[1]
terraform state mv aws_instance.example[\"1\"] aws_instance.new[\"1\"]
terraform state rm module.vpc.data.aws_instances.new
terraform state mv aws_instance.example[\"0\"] aws_instance.new[\"0\"]
terraform state import aws_instance.new[\"0\"] i-0e15e79a96cba3a72
terraform state replace-provider hashicorp/aws registry.acme.corp/acme/aws
terraform state replace-provider registry.acme.corp/acme/aws hashicorp/aws
terraform state pull
terraform state pull > out.txt
terraform state push -force out.txt
```
