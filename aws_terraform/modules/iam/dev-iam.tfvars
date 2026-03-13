tags = {
  environment = "dev"
  project     = "empath"
  owner       = "gorathus6"
}

roles = {
  ec2_role = {
    description = "EC2 role for Empath DEV"
    trust_policy_json = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action = "sts:AssumeRole"
      }]
    })
    managed_policy_arns = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]
    inline_policies = jsonencode ({
      Version = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = ["s3:GetObject"]
        Resource = ["arn:aws:s3 ::: empath-dev/*"]
      }]
    })
  }
}

policies = {
  s3_read_policy = {
    description = "Read-only access to Empath S3 bucket"
    policy_json = jsonencode({
      Version: = "2012-10-17"
      Statement = [{
        Effect = "Allow"
        Action = ["s3:GetObject"]
        Resource = ["arn:aws:s3 ::: empath-dev/* "]
      }]
    })
  }
}