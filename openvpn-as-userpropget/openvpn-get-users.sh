#!/bin/bash

output_file="openvpn_users.csv"
echo "Username,Group,AdminPermission" > $output_file

# Get list of all users
users=$(cd /usr/local/openvpn_as/scripts && ./sacli UserPropGet | grep -oP '"(\w+)":' | tr -d '":')

for username in $users; do
  # Check admin permission
  is_admin=$(cd /usr/local/openvpn_as/scripts && ./sacli --user "$username" UserPropGet | grep '"type": "admin"' &>/dev/null && echo "true" || echo "false")
  
  # Get group information (if applicable)
  group=$(cd /usr/local/openvpn_as/scripts && ./sacli --user "$username" UserPropGet | grep '"group"' | awk -F: '{print $2}' | tr -d '", ')
  
  # Append user info to CSV
  echo "$username,$group,$is_admin" >> $output_file
done

echo "Details saved to $output_file"
