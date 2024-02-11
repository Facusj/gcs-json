# gcs-json

This repository provides a standardized approach to define, create and manage GCS buckets and it´s permissions using Terraform.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](https://github.com/hashicorp/terraform-provider-google) | 4.43.1 |

## How to Use

For creating a new GCS bucket, we simply create a new `.json` file under the `/configs` folder

**Keypoints**

- The filename of the `.json` will be the bucket name. E.g. `test-bucket.json` will create the bucket `test-bucket`

- `lifecycle_rule`, `iam_members`, `retention_policy`, `logging`, `labels`  and `versioning` blocks are optional

- Binded SA (iam_members) to the buckets must be created already

- Members can be defined with:
    1. user:{emailid}
    2. serviceAccount:{emailid}
    3. group:{emailid}

- Only 6 roles are accepted for SA:
    1. Read Only: `roles/storage.objectViewer`
    2. Write Only: `roles/storage.objectCreator`
    3. Read-Write-Delete: `roles/storage.objectUser`
    4. Read Only Legacy: `roles/storage.legacyBucketReader`
    5. Write Only Legacy: `roles/storage.legacyBucketWriter`
    6. Read Write Delete Legacy: `roles/storage.legacyBucketOwner`


- `path_prefix` is used for folder specific permissions, default is "/"

- Any changes must be done via CI/CD Jobs. On MR only Plan will be run, apply will run on merge only.