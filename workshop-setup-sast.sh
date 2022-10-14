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
adminGroupID=""
while (($emailsInd < ${#emails[@]})); do
   # Gets the Administrators group ID for a Mend SAST organization.
   if (($(($emailsInd % $GH_USERS_PER_ORG)) == 0)); then
      # Calc organization index for API requests
      orgInd=$(($emailsInd / $GH_USERS_PER_ORG))

      groups=$(curl -H "X-Auth-Token: ${apiTokens[$orgInd]}" $SAST_URL/api/groups)
      # Contains the part of "groups" response before "Administrators"
      adminGroup=${groups/"Administrators"*/}
      # Contains the part of "adminGroup" after "id"
      adminGroupIDwithOrgID=${adminGroup/*"id"/}
      # Get the id (1st set of substring before ,) and trim
      adminGroupID=$(echo $adminGroupIDwithOrgID | cut -d ',' -f 1 | tr -dc '[:alnum:]-')
      echo -e "\nOrg #$orgInd: Administrators user group ID - $adminGroupID"
   fi

   echo -e "\nOrg #$orgInd: Add user ${emails[$emailsInd]} to the Administrators group"
   curl -H "X-Auth-Token: ${apiTokens[$orgInd]}" $SAST_URL/api/users \
   -d '{"username":"'${emails[$emailsInd]}'","name":"'${emails[$emailsInd]}'","role":0,"groups":[{"id":"'$adminGroupID'","name":"Administrators"}]}'

   emailsInd=$(($emailsInd + 1))
done
