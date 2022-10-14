### Currently Broken DO NOT USE!!!!

export SAST_ORGANIZATION=6dd31fab-ce4a-437f-8c44-0887a1590342
#export SASTCLI_TOKEN=get token from manager and set in shell before script
export SAST_SERVER=https://sast-demo.whitesourcesoftware.com
### Fix the below variable fetch
#groupid=$(curl -H "X-Auth-Token: ${SASTCLI_TOKEN}" ${SAST_SERVER}"/api/groups")
emailfile=$1
emails=`cat ${emailfile}`
for email in $emails; do
    curl --request POST -H "X-Auth-Token: ${SASTCLI_TOKEN}" ${SAST_SERVER}"/api/users" \
    -d '{"name":"'${email}'","email":"'${email}'","groups":[{"id":"'${groupid}'","name":"Administrators"}],"role":0,"username":"'${email}'"}'
    echo "Creating user $email"
done
