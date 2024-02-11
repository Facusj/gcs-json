resource "google_storage_bucket" "gcs_buckets" {
  for_each                    = local.buckets
  project                     = lookup(each.value, "project", null)
  name                        = each.key
  location                    = lookup(each.value, "bucket_location", "us-east4")
  public_access_prevention    = lookup(each.value, "public_access_prevention", null) != null ? each.value.public_access_prevention : "enforced"
  force_destroy               = lookup(each.value, "force_destroy", null) != null ? each.value.force_destroy : false
  uniform_bucket_level_access = lookup(each.value, "uniform_bucket_level_access", null) != null ? each.value.uniform_bucket_level_access : true
  storage_class               = lookup(each.value, "storage_class", "STANDARD")

  versioning {
    enabled = lookup(each.value, "versioning", null) != null ? each.value.versioning.enabled : false
  }

  dynamic "retention_policy" {
    for_each = lookup(each.value, "retention_policy", null) != null ? [each.value.retention_policy] : []
    content {
      retention_period = retention_policy.value.retention_period
    }
  }

  dynamic "lifecycle_rule" {
    for_each = lookup(each.value, "lifecycle_rules", null) != null ? each.value.lifecycle_rules : []
    content {
      action {
        type          = lookup(lifecycle_rule.value.action, "type", null)
        storage_class = lookup(lifecycle_rule.value.action, "storage_class", null)
      }
      condition {
        age                        = lookup(lifecycle_rule.value.condition, "age", null)
        created_before             = lookup(lifecycle_rule.value.condition, "created_before", null)
        with_state                 = lookup(lifecycle_rule.value.condition, "with_state", "ANY")
        matches_storage_class      = contains(keys(lifecycle_rule.value.condition), "matches_storage_class") ? split(",", lifecycle_rule.value.condition["matches_storage_class"]) : null
        matches_prefix             = contains(keys(lifecycle_rule.value.condition), "matches_prefix") ? split(",", lifecycle_rule.value.condition["matches_prefix"]) : null
        matches_suffix             = contains(keys(lifecycle_rule.value.condition), "matches_suffix") ? split(",", lifecycle_rule.value.condition["matches_suffix"]) : null
        num_newer_versions         = lookup(lifecycle_rule.value.condition, "num_newer_versions", null)
        custom_time_before         = lookup(lifecycle_rule.value.condition, "custom_time_before", null)
        days_since_custom_time     = lookup(lifecycle_rule.value.condition, "days_since_custom_time", null)
        days_since_noncurrent_time = lookup(lifecycle_rule.value.condition, "days_since_noncurrent_time", null)
        noncurrent_time_before     = lookup(lifecycle_rule.value.condition, "noncurrent_time_before", null)
      }
    }
  }

  labels = lookup(each.value, "labels", null) != null ? each.value.labels : merge(
    local.labels,
    {
      stack = replace(each.key, "-", "_")
  })

  dynamic "logging" {
    for_each = lookup(each.value, "logging", null) != null ? [each.value.logging] : []

    content {
      log_bucket        = lookup(logging.value, "log_bucket", null) != null ? logging.value.log_bucket : null
      log_object_prefix = lookup(logging.value, "log_object_prefix", null) != null ? logging.value.log_object_prefix : null
    }
  }
}