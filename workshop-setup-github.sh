export ghorg=wsts-workshop
#export GITHUB_TOKEN=get token from manager and set in shell before script
export GITHUB_USERNAME=ts-whitesource

DIR=$PWD/easybuggy

ghufile=$1
ghusers=`cat ${ghufile}`
if [ -d "$DIR" ]; then
cd $DIR && echo "$DIR exists"
else 
git clone https://github.com/k-tamura/easybuggy.git && cd ./easybuggy
git config --local url."https://${GITHUB_TOKEN}@github.com".insteadOf "https://github.com"
sed -i '' 's%<phase>install</phase>%<phase>deploy</phase>%1' pom.xml
git add pom.xml && git commit -m 'changed install phase' -a
fi
# Create Github repository & push easybuggy
for ghuser in $ghusers; do
    curl -X POST -H 'Accept: application/vnd.github.v3+json' -u ${GITHUB_USERNAME}:${GITHUB_TOKEN}\
    https://api.github.com/orgs/${ghorg}/repos \
    -d '{"name":"'${ghuser}'"}'
    echo "Creating repository for ${ghuser}" >> ../repocreated.txt
    curl -X PUT -H 'Accept: application/vnd.github.v3+json' -u ${GITHUB_USERNAME}:${GITHUB_TOKEN} https://api.github.com/repos/${ghorg}/${ghuser}/collaborators/${ghuser} -d '{"permission":"admin"}'
    echo "Adding ${ghuser} to https://api.github.com/repos/${ghorg}/${ghuser}/collaborators/${ghuser}"
    demoorigin=https://github.com/${ghorg}/${ghuser}.git
    echo "Pushing easybuggy to $demoorigin"
    git remote set-url origin ${demoorigin}
    git push -u origin
done

cd .. && rm -rf easybuggy
