
│ Error: Invalid value for input variable
│
│   on main.tf line 270, in module "db":
│  270:   additional_users = var.users
│
│ The given value is not suitable for module.db.var.additional_users declared at
│   .terraform/modules/db/modules/postgresql/variables.tf:318,1-28: incorrect list element type: attribute "random_password" is required.
╵
