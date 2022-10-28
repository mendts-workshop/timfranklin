#export GH_TOKEN=<get token from manager and set in shell before script>
#export GH_ORGS="mendts-workshop, mendts-workshop1, mendts-workshop2"
#export GH_USERNAME=ts-whitesource
#export GH_USERS_PER_ORG=2
#export GH_BRANCH=easybuggy

ghFile=$1
readarray -t ghUsers < $ghFile

# Remove all spaces and split GH_ORGS based on the delimiter ','
GH_ORGS=$(echo $GH_ORGS | tr -d ' ' | tr ',' ' ')
read -ra ghOrgs <<< "$GH_ORGS"

# Delete the repocreated.txt file, in case it exists from the previous interactions.
if [ -e "repocreated.txt" ]; then
    rm repocreated.txt
fi

workshopProjDir=$PWD/$GH_BRANCH
# Clone the workshop project if it doesn't already exist (e.g. easybuggy).
if [ -d "$workshopProjDir" ]; then
   cd $workshopProjDir && echo "$workshopProjDir exists"
else
# Only clone the specified branch into a separate  folder. This branch also serves as the name of the folder.
   git clone --single-branch --branch $GH_BRANCH https://github.com/mend-toolkit/ts-workshop.git $GH_BRANCH && cd ./$GH_BRANCH
   git config --local url."https://${GH_TOKEN}@github.com".insteadOf "https://github.com"
fi

# For each participant, create a GitHub repository & push the workshop project.
ghUsersInd=0
while (($ghUsersInd < ${#ghUsers[@]})); do

    # Calc organization index for GitHub organization
    orgInd=$(($ghUsersInd / $GH_USERS_PER_ORG))
    echo "Creating repository for ${ghUsers[$ghUsersInd]} within the ${ghOrgs[$orgInd]}" >> ../repocreated.txt

    echo "Creating a new repository for ${ghUsers[$ghUsersInd]} within the ${ghOrgs[$orgInd]} organization"

    curl -X POST -H 'Accept: application/vnd.github.v3+json' -u ${GH_USERNAME}:${GH_TOKEN} \
    https://api.github.com/orgs/${ghOrgs[$orgInd]}/repos -d '{"name":"'${ghUsers[$ghUsersInd]}'"}'

    echo "Adding ${ghUsers[$ghUsersInd]} as a new collaborator to ${ghOrgs[$orgInd]} organization"
    curl -X PUT -H 'Accept: application/vnd.github.v3+json' -u ${GH_USERNAME}:${GH_TOKEN} \
    https://api.github.com/repos/${ghOrgs[$orgInd]}/${ghUsers[$ghUsersInd]}/collaborators/${ghUsers[$ghUsersInd]} -d '{"permission":"admin"}'

    demoOrigin=https://github.com/${ghOrgs[$orgInd]}/${ghUsers[$ghUsersInd]}.git
    echo "Pushing workshop project $GH_BRANCH to $demoOrigin"
    git remote set-url origin $demoOrigin
    git push -u origin

    ghUsersInd=$(($ghUsersInd + 1))
done

cd .. && rm -rf $GH_BRANCH
