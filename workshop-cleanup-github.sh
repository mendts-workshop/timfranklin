#export GH_TOKEN=<get token from manager and set in shell before script>
#export GH_ORGS="mendts-workshop, mendts-workshop1, mendts-workshop2"
#export GH_USERNAME=ts-whitesource
#export GH_USERS_PER_ORG=2

ghFile=$1
readarray -t ghUsers <$ghFile

# Remove all spaces and split GH_ORGS based on the delimiter ','
GH_ORGS=$(echo $GH_ORGS | tr -d ' ' | tr  ',' ' ')
read -ra ghOrgs <<< "$GH_ORGS"

ghUsersInd=0
while (($ghUsersInd < ${#ghUsers[@]})); do
    # Calc organization index for GitHub organization
    orgInd=$(($ghUsersInd / $GH_USERS_PER_ORG))

    echo "Deleting repository for ${ghUsers[$ghUsersInd]} within the ${ghOrgs[$orgInd]} organization"
        curl -X DELETE -H 'Accept: application/vnd.github.v3+json' -u $GH_USERNAME:$GH_TOKEN \
        https://api.github.com/repos/${ghOrgs[$orgInd]}/${ghUsers[$ghUsersInd]}

    ghUsersInd=$(($ghUsersInd + 1))
done
