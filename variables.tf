variable "access_levels" {
  description = "Access levels privileges for GCS buckets"
  type        = map(any)

  default = {
    read_only         = "roles/storage.objectViewer"
    write_only        = "roles/storage.objectCreator"
    read_write        = "roles/storage.objectUser"
    read_only_legacy  = "roles/storage.legacyBucketReader"
    write_only_legacy = "roles/storage.legacyBucketWriter"
    read_write_legacy = "roles/storage.legacyBucketOwner"
  }
}