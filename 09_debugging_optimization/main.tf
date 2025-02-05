provider "aws" {
  region = "eu-central-1"
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-terraform-bucketiasbdiasjdn"
}

resource "aws_s3_object" "file_1" {
  bucket  = aws_s3_bucket.example_bucket.id
  key     = "file1.txt"
  content = "Datei 1"
}

resource "aws_s3_object" "file_2" {
  bucket  = aws_s3_bucket.example_bucket.id
  key     = "file1.txt"
  content = "Datei 2, die Datei 1 überschreibt"
}

resource "aws_s3_object" "files" {
  count = 100
  bucket  = aws_s3_bucket.example_bucket.id
  key     = "file${count.index}.txt"
  content = "Datei ${count.index}"
}



# ERROR -> Loggt alle Fehler
# WARN -> Loggt alle Fehler + Warnungen
# INFO -> Loggt alle Fehler + Warnungen + Infos
# DEBUG -> Loggt alle Fehler + Warnungen + Infos + Debug Nachrichten
# TRACE -> Loggt alle Fehler + Warnungen + Infos + Debug Nachrichten + Alle Traces