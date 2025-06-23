#!/bin/bash
# Paperless-ngx API URL and API token
#API_URL="http://IP:8000/api"
#API_TOKEN="your api key"
#AIUSER="paperlessaiuser"
#PermissionGroup="yourgroup"

scriptPath=$(dirname "$(readlink -f "$0")")
source "${scriptPath}/.env.sh"

# Query user "root"
ROOT_USER_ID=$(curl -s -H "Authorization: Token $API_TOKEN" "$API_URL/users/" | jq -r --arg USERNAME "$AIUSER" '.results[] | select(.username == $USERNAME) | .id')

if [ -z "$ROOT_USER_ID" ]; then
    echo "User 'admin' not found."
    exit 1
fi

# Query permission group "User"
USER_GROUP_ID=$(curl -s -H "Authorization: Token $API_TOKEN" "$API_URL/groups/" | jq -r --arg PERMISSION_GROUP_NAME "$PermissionGroup" '.results[] | select(.name == $PERMISSION_GROUP_NAME) | .id')

if [ -z "$USER_GROUP_ID" ]; then
    echo "Permission group 'Family' not found."
    exit 1
fi

# Function to update objects
update_object() {
    local endpoint=$1
    local object_type=$2

    # Retrieve all objects
    response=$(curl -s -H "Authorization: Token $API_TOKEN" "$API_URL/$endpoint/?page_size=9999")

    # List objects
    echo "List of all $object_type:"
    echo "$response" | jq -r '.results[] | "\(.id) \(.name) \(.owner)"'

    # Iterate through objects and set owner to null and add read permissions for group "Family" if owner is "admin"
    echo "$response" | jq -r --arg ROOT_USER_ID "$ROOT_USER_ID" '.results[] | select(.owner == ($ROOT_USER_ID | tonumber)) | .id' | while read -r obj_id; do
        echo "Setting owner of $object_type ID $obj_id to null and adding read permissions for group 'Family'"
        body=$(jq -n --argjson USER_GROUP_ID "$USER_GROUP_ID" '{owner: null, set_permissions: {view: {users: [], groups: [$USER_GROUP_ID]}, change: {users: [], groups: []}}}')
        curl -s -X PATCH -H "Authorization: Token $API_TOKEN" -H "Content-Type: application/json" -d "$body" "$API_URL/$endpoint/$obj_id/"
    done

    echo "All relevant $object_type have been updated."
}

# Update tags
update_object "tags" "Tags"

# Update correspondents
update_object "correspondents" "Correspondents"

# Update document types
update_object "document_types" "Document Types"
