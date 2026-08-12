variable "do_token" {
  type        = string
  description = "DigitalOcean API Token"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "DigitalOcean Region (e.g. nyc1, nyc3, sfo3)"
  default     = "nyc3"
}


