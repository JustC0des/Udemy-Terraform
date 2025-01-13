variable "stage" {
  description = "Beschreibt die Landschaft in der man sich befindet (DEV/QAS/PRD)"
  type        = string
  default     = "qas"
}


























variable "list_stages" {
  description = "Unsortierte Liste aller verfügbaren Landschaften"
  type        = list(string)
  default     = ["qas", "dev", "prd", "dev"]
}


variable "set_stages" {
  description = "Liste aller verfügbaren Landschaften genau ein mal"
  type        = set(string)
  default     = ["qas", "dev", "prd", "dev"]
}





























variable "map_stage_dev" {
  description = "Map für die Landschaft DEV"
  type        = map(string)
  default = {
    "name"        = "dev",
    "description" = "Entwicklungsumgebung"
    "account_id"  = 1234
  }
}

variable "map_stage_dev_bool" {
  description = "Map für die Landschaft DEV"
  type        = map(bool)
  default = {
    "is_false" = false
    "is_true"  = true
  }
}





























variable "nested_map_stages" {
  description = "Map aller verfügbaren Landschaften"
  type        = map(map(string))
  default = {
    "stage_dev" = {
      "name"        = "dev",
      "description" = "Entwicklungsumgebung"
      "account_id"  = 1234
    },
    "stage_qas" = {
      "name"        = "qas",
      "description" = "Qualitätsumgebung",
      "account_id"  = 5678
    },
    "stage_prd" = {
      "name"        = "prd",
      "description" = "Produktionsumgebung",
      "account_id"  = 9012
    },
  }
}















variable "nested_list_map_stages" {
  description = "Map aller verfügbaren Landschaften"
  type        = list(map(string))
  default = [
    {
      "name"        = "dev",
      "description" = "Entwicklungsumgebung"
      "account_id"  = 1234
    },
    {
      "name"        = "qas",
      "description" = "Qualitätsumgebung",
      "account_id"  = 5678
    },
    {
      "name"        = "prd",
      "description" = "Produktionsumgebung",
      "account_id"  = 9012
    },
  ]
}




variable "object_stage_status" {
  description = "Ein Objekt, das den Status und andere Details für jede Landschaft enthält"
  type = object({
    stage       = string
    description = string
    account_id  = number
    active      = bool
  })
  default = {
    stage       = "qas"
    description = "Qualitätsumgebung"
    account_id  = 5678
    active      = true
  }
}