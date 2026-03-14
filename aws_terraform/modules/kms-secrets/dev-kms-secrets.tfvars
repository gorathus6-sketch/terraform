kms_alias       = "empath-dev-kms"
kms_description = "KMS key for Empath DEV"
enable_key_rotation = true

kms_policy_json = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Effect = "Allow"
      Principal = { AWS = "arn:aws:iam::123456789012:root" }
      Action = "kms:*"
      Resource = "*"
    },
    {
      Effect = "Allow"
      Principal = { AWS = "arn:aws:iam::123456789012:role/ec2_role" }
      Action = [
        "kms:Encrypt",
        "kms:Decript",
        "kms:GenerateDataKey"
      ]
      Resource = "*"
    }
  ]
})

secrets = {
  db_password = {
    description   = "Database password for Empath DEV"
    initial_value = "NotTellingYouShit"
  }

  api_key = {
    description   = "API key for Empath DEV"
    initial_value = null
  }
}

tags = {
  environment = "dev"
  project     = "empath"
  owner       = "gorathus6"
}