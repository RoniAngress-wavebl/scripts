#!/bin/bash

echo "Fetching AWS IAM user, group, and permission details..."
output_file="iam_permission_review.csv"

# Header for the CSV output
echo "UserName,UserArn,Groups,LastActivity,PoliciesAttached,InlinePolicies" > $output_file

# Get all IAM users
users=$(aws iam list-users --query 'Users[*].UserName' --output text | tr -d '\r')

for UserName in $users; do
  echo "Processing user: $UserName"
  
  # Skip invalid usernames
  if [[ ! "$UserName" =~ ^[a-zA-Z0-9+=,.@_-]+$ ]]; then
    echo "Skipping invalid user: $UserName"
    continue
  fi

  # Get user ARN
  UserArn=$(aws iam get-user --user-name "$UserName" --query 'User.Arn' --output text)

  # Get group memberships
  Groups=$(aws iam list-groups-for-user --user-name "$UserName" --query 'Groups[*].GroupName' --output text | tr '\n' ';')

  # Get last activity
  LastActivity=$(aws iam get-service-last-accessed-details --arn "$UserArn" --query 'ServicesLastAccessed[0].LastAuthenticated' --output text 2>/dev/null || echo "Never")

  # Get attached policies
  PoliciesAttached=$(aws iam list-attached-user-policies --user-name "$UserName" --query 'AttachedPolicies[*].PolicyName' --output text | tr '\n' ';')

  # Get inline policies
  InlinePolicies=$(aws iam list-user-policies --user-name "$UserName" --query 'PolicyNames[*]' --output text | tr '\n' ';')

  # Append user details to the CSV
  echo "$UserName,$UserArn,\"$Groups\",$LastActivity,\"$PoliciesAttached\",\"$InlinePolicies\"" >> $output_file
done

echo "Details saved to $output_file"
