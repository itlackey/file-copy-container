#!/bin/bash

# # Mount the network drives
# mkdir -p /mnt/networkdrive
# echo "//192.168.1.100/share /mnt/networkdrive cifs credentials=/root/.smbcredentials,iocharset=utf8,sec=ntlmssp 0 0" >> /etc/fstab
# mount -a

# Load the config file
config=$(cat config.json)

# Parse the config file
mounts=$(echo "$config" | jq -r '.mounts[]')
commands=$(echo "$config" | jq -r '.commands[]')

#echo $mounts

# Loop through the mounts and mount the network drives
while read -r mount; do
  # Extract the source, destination, type, and options from the mount
  
  echo $(echo "$mount" | jq -Rr '.source')

#   source=$(echo "$mount" | jq -r '.source')

#   echo "$source"
#   destination=$(echo "$mount" | jq -r '.destination')
#   type=$(echo "$mount" | jq -r '.type')
#   options=$(echo "$mount" | jq -r '.options')

 #echo "$type $source $destination $options"
  
  # Mount the network drive
  #mkdir -p "$destination"
  #mount -t "$type" "$source" "$destination" -o "$options"
done <<< "$mounts"

# # Loop through the commands
# while read -r command; do
#   # Extract the source, destination, and patterns from the command
#   source=$(echo "$command" | jq -r '.source')
#   destination=$(echo "$command" | jq -r '.destination')
#   exclude_pattern=$(echo "$command" | jq -r '.exclude_pattern')
#   include_pattern=$(echo "$command" | jq -r '.include_pattern')

#   # Build the azcopy command
#   cmd="azcopy sync --source $source --destination $destination --exclude-pattern $exclude_pattern --include-pattern $include_pattern"

#   # Execute the azcopy command
#   eval "$cmd"
# done <<< "$commands"


#echo "File sync completed"