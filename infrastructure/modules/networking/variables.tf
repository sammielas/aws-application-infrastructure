variable "name" {
  description = "Name prefix for networking resources"
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the VPC"
  type        = string

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "The VPC CIDR must be a valid IPv4 CIDR block."
  }
}

variable "subnets" {
  description = "Subnet configuration keyed by logical subnet name"

  type = map(object({
    cidr_block        = string
    availability_zone = string
    public            = bool
  }))

  validation {
    condition = alltrue([
      for subnet in values(var.subnets) :
      can(cidrnetmask(subnet.cidr_block))
    ])
    error_message = "Each subnet must have a valid IPv4 CIDR block."
  }
}

variable "tags" {
  description = "Common resource tags"
  type        = map(string)
  default     = {}
}
