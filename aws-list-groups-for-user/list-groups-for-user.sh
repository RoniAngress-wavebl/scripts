#!/bin/bash

# List all users
USERS=$(aws iam list-users --query 'Users[*].UserName' --output text)

for USER in $USERS; do
  echo "Groups for user: $USER"
  aws iam list-groups-for-user --user-name $USER --query 'Groups[*].GroupName' --output text
  echo "------"
done
