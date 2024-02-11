locals {
  department  = "de"
  environment = "dev"
  name_prefix = "r6-${local.department}-${local.environment}"

  # project-specific labels
  labels = {
    "department"     = local.department
    "spend_category" = "data_storage"
  }

  bucket_json_files = fileset("configs/", "*.json")

  buckets = {
    for file in local.bucket_json_files :
    substr(file, 0, length(file) - 5) => merge(jsondecode(file("${path.root}/configs/${file}")))
  }

  buckets_iam_access = {
    for bind in flatten([
      for k, v in local.buckets : [
        for iam in v.iam_members : [
          for role in iam.roles : [
            for mem in iam.member : {
              map_index   = k
              role        = role
              member      = mem
              path_prefix = iam.path_prefix
            }
          ]
        ]
      ] if can(v.iam_members)
    ]) : "${bind.path_prefix}.${bind.member}.${bind.role}.${bind.map_index}" => bind
  }
}
