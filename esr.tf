resource "aws_ecr_repository" "repo" {
  name = "${var.project-name}-ecr"
}

resource "aws_ecr_lifecycle_policy" "cycle" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
  {
    "rules": [
      {
        "rulePriority": 1,
        "description": "Keep last 30 release tagged images",
        "selection": {
          "tagStatus": "tagged",
          "tagPrefixList": ["release"],
          "countType": "imageCountMoreThan",
          "countNumber": 30
        },
        "action": {
          "type": "expire"
        }
      }
    ]
  }
EOF
}
