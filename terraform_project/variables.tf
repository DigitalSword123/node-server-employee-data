variable "project" {
  description = "project name for tags and resource naming"
  default     = "employee"
}

variable "name" {
  description = "name to be used as prefix"
  default     = "employee-data-node"
}

variable "env" {
  description = "project environments"
}

variable "owner" {
  description = "owner of this project"
  default     = "ranaamiys70@gmail.com"
}

variable "region" {
  description = "region to which this API to be deployed"
  default     = "ap-south-1"
} 

variable "master_tags" {
  description = "common tags"
  type        = map(string)
}

variable "default_master_tags" {
  description = "common tags"
  type        = map(string)
  default = {
    createdBy  = "ranaamiys70@gmail.com"
    CostCenter = "8723578"
    AlwaysOn   = "Yes"
    platforms  = "Myproject"
    product    = "employee data"
  }
}

variable "_lambda_properties" {
  description = "lambda properties map"
  type        = map(string)
  default = {
    Lambda_function_name          = "node_employee_data"
    lambda_zip_file_employee_data = "employee-node-data.1.0.0-SNAPSHOT.zip"
    # lambda_zip_file_employee_data = "employee-node-data.${version}.zip"
    lambda_handler                = "index.handler"
  }
}

variable "environment_variables" {
  description = "lambda env variables"
  type        = map(string)
  default     = {}
}