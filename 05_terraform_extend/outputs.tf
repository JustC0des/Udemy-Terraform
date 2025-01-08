output "module_path" {

  description = "Pfad des Root moduls"
  value       = path.module

}

output "root_path" {

    description = "Pfad des Root moduls"
    value       = path.root

}

output "current_path" {

    description = "Aktueller Pfad"

    value       = path.cwd

}

output "stages_upper_if_not_dev" {

    description = "Gibt alle Umgebungen die nicht dev sind in uppercase aus"

    value       = [for s in var.list_stages : upper(s) if s!= "dev"]

}

output "stage_lengths" {

  description = "Längen von Namen und Beschreibungen der Stages"

  value       = [for k, v in var.nested_map_stages : "${length(v.name)}:${length(v.description)}"]

}

output "upper_stage_names" {

  description = "Alle Stages in Großbuchstaben"

  value       = { for stage in var.set_stages : stage => upper(stage) }

}

output "stage_beschreibung" {
    description = "Beschreibung der Stage"
    value = var.stage == "qas" ? "Qualitätsumgebung" : "Testumgebung"
}