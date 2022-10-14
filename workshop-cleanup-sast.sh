#export SAST_API_TOKENS="apiToken, apiToken1, apiToken2"
#export SAST_URL=https://sast.mend.io/sast
#export GH_USERS_PER_ORG=2

emailsFile=$1
readarray -t emails <$emailsFile

# Remove all spaces and split SAST_API_TOKENS based on the delimiter ','
SAST_API_TOKENS=$(echo $SAST_API_TOKENS | tr -d ' ' | tr  ',' ' ')
read -ra apiTokens <<< "$SAST_API_TOKENS"

emailsInd=0
orgInd=0
while (($emailsInd < ${#emails[@]})); do
   # Gets the Administrators group ID for a Mend SAST organization.
   if (($(($emailsInd % $GH_USERS_PER_ORG)) == 0)); then
      # Calc organization index for API requests
      orgInd=$(($emailsInd / $GH_USERS_PER_ORG))

      # Get the org users and remove all spaces from the resposne
      users=$(curl -H "X-Auth-Token: ${apiTokens[$orgInd]}" $SAST_URL/api/users | tr -d ' ')
      # Create an array from the json response (by replacing "],[" with a space)
      users=${users//"},{"/" "}
      declare -A usersArr
      for user in $users; do
         # Contains the response part before "groups"
         userDetails=${user/"groups"*/}
         # Contains the part after "id" element
         idVal=${userDetails/*"id"/}
         # Get the id (1st set of substring before ,) and trim
         id=$(echo $idVal | cut -d ',' -f 1 | tr -d '":')
         # Contains the part after "username"
         usernameVal=${user/*"username"/}
         # Get the user name (1st set of substring before ,) and trim
         username=$(echo $usernameVal | cut -d ',' -f 1 | tr -d '":')
         usersArr[$username]=$id
      done
      # Uncomment for debug/troubleshooting purposes
#      echo -e "\nOrg #$orgInd: Org users - ${!usersArr[@]}"
   fi

   # Delete a user if it exists in the org
   if [ ${usersArr[${emails[$emailsInd]}]+_} ]; then
      echo -e "\nOrg #$orgInd: Remove user ${emails[$emailsInd]} from an organization (User id: ${usersArr[${emails[$emailsInd]}]})"
      curl --request DELETE -H "X-Auth-Token: ${apiTokens[$orgInd]}" $SAST_URL/api/users/${usersArr[${emails[$emailsInd]}]}
   else
      echo -e "\nOrg #$orgInd: The email ${emails[$emailsInd]} wasn't found"
   fi

   emailsInd=$(($emailsInd + 1))
done
