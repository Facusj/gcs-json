resource "google_storage_bucket_iam_member" "bucket_members" {
  for_each = {
    for k, v in local.buckets_iam_access : k => v if contains(values(var.access_levels), v.role)
  }

  bucket = each.value.map_index
  role   = each.value.role
  member = each.value.member

  dynamic "condition" {
    for_each = each.value.path_prefix != "/" ? [each.value.path_prefix] : []

    content {
      title       = "${each.value.role} Permissions"
      description = "${google_storage_bucket.gcs_buckets[each.value.map_index].id} Permissions"
      expression  = "resource.type == \"storage.googleapis.com/Object\" && resource.name.startsWith(\"projects/_/buckets/${google_storage_bucket.gcs_buckets[each.value.map_index].id}/objects${each.value.path_prefix}\")"
    }
  }

  depends_on = [google_storage_bucket.gcs_buckets]
}