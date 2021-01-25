resource "aws_iam_policy" "cloudwatch_read_only" {
  name   = "cloudwatch-read-only"
  policy = data.aws_iam_policy_document.cloudwatch_read_only.json
}

resource "aws_iam_policy" "cloudwatch_full_access" {
  name   = "cloudwatch-full-access"
  policy = data.aws_iam_policy_document.cloudwatch_full_access.json
}

resource "aws_iam_user" "example" {
  for_each = toset(var.user_names)
  name     = each.value
}

// IF-ELSE conditions for user1 attachment policy
resource "aws_iam_user_policy_attachment" "user_cloudwatch_full_access" {
  count = var.give_cloudwatch_full_access ? 1 : 0

  user       = aws_iam_user.example[var.user_names[0]].name
  policy_arn = aws_iam_policy.cloudwatch_full_access.arn
}

resource "aws_iam_user_policy_attachment" "user_cloudwatch_read_only" {
  count = var.give_cloudwatch_full_access ? 0 : 1

  user       = aws_iam_user.example[var.user_names[0]].name
  policy_arn = aws_iam_policy.cloudwatch_read_only.arn
}
