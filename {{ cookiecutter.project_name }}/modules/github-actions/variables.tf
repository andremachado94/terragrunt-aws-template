variable "prefix" {
  type        = string
  description = "Prefix to apply to all resources"
}

variable "repository" {
  type        = string
  description = "Github repository name"
}

variable "openid_connect_provider" {
  type        = object({
    enabled = bool,
    thumbprint_list = list(string)
  })
  description = "OpenID Connect Provider Configuration"
  default     = { enabled = false , thumbprint_list = []}
  validation {
    condition = !var.openid_connect_provider.enabled || (var.openid_connect_provider.enabled && length(var.openid_connect_provider.thumbprint_list) > 0)
    error_message = "OpenID Connect Provider is enabled but no Thumbprint List was provided"
  }
}

variable "apply_branch" {
  type        = string
  description = "Apply branch"
  default     = "{{ cookiecutter.apply_branch }}"
}