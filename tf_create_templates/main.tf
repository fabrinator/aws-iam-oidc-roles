provider "aws" {
  profile = "default"
  region = "us-east-1"
}

data "aws_organizations_organization" "org" {}

locals {
  all_accounts = { for acc in data.aws_organizations_organization.org.accounts : acc.name => acc.id if acc.status == "ACTIVE" }
}

resource "local_file" "aws_config" {
  filename = pathexpand("~/.aws/config")
  content = templatefile("./templates/aws_config", {
    all_accounts = local.all_accounts
  })
}

resource "local_file" "file" {
  for_each = fileset("./templates", "*tmpl")
  filename = trim("${path.cwd}/../terraform/${each.key}", ".tmpl")
  content = templatefile("./templates/${each.key}", {
    all_accounts = local.all_accounts
    region = "us-east-1"
  })
}