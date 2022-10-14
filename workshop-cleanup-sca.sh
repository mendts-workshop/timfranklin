#export WS_APIKEYS="apiKey, apiKey1, apiKey2"
#export WS_USERKEYS="userKey, userKey1, userKey2"
#export WS_WSS_URL="https://saas.mend.io/api/v1.3"
#export GH_USERS_PER_ORG=2

emailsFile=$1
readarray -t emails <$emailsFile

# Remove all spaces and split WS_APIKEYS based on the delimiter ','
WS_APIKEYS=$(echo $WS_APIKEYS | tr -d ' ' | tr  ',' ' ')
read -ra apiKeys <<< "$WS_APIKEYS"

# Remove all spaces and split WS_USERKEYS based on the delimiter ','
WS_USERKEYS=$(echo $WS_USERKEYS | tr -d ' ' | tr ',' ' ')
read -ra userKeys <<< "$WS_USERKEYS"

emailsInd=0
while (($emailsInd < ${#emails[@]})); do
   # Calc organization index for GitHub organization
   orgInd=$(($emailsInd / $GH_USERS_PER_ORG))

   echo -e "\nOrg #$orgInd: Remove user ${emails[$emailsInd]} from an organization"
   curl --request POST -H "Content-Type:application/json" $WS_WSS_URL \
   -d "{'requestType':'removeUserFromOrganization', 'userKey':'${userKeys[$orgInd]}', 'orgToken':'${apiKeys[$orgInd]}', 'user':{'email':'${emails[$emailsInd]}'}}"

   emailsInd=$(($emailsInd + 1))
done
