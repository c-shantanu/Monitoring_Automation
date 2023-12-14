# already existing key pair
data "aws_key_pair" "existing_key_pair" {
  key_name = "mykey"
  include_public_key = true
}
