variable "domain" {
  type        = string
  description = "ドメインを指定します"
}

variable "repository" {
  type        = string
  description = "GITHUBリポジトリを指定します"
}

variable "vpc_cidr" {
  type        = string
  description = "VPCのIPv4アドレス範囲を指定します"
  default     = "10.2.0.0/16"
}