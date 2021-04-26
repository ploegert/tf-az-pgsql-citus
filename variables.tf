
variable "pgsql" {
  type = object({
    name                         = string
    resource_group               = string
    location                     = string
    serverGroup                  = string
    administratorLogin           = string
    administratorLoginPassword   = string
    databaseName                 = string
    port                         = string
    coordName                    = string
    pgsql_worker_count           = string
    coordinatorVcores            = string
    coordinatorStorageSizeMB     = string
    workerVcores                 = string
    workerStorageSizeMB          = string
  })
}



variable "ip_whitelist" {   default     = {} } 

# #example Variable:
# ip_whitelist = {
#   ip1 = { ip = "1.2.3.4" } 
#   ip2 = { ip = chomp(data.http.myip.body) }
# }



variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
