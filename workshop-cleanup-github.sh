export ghorg=wsts-workshop
#export GITHUB_TOKEN=get token from manager and set in shell before script
export GITHUB_USERNAME=ts-whitesource

rm -rf easybuggy
ghuserfile=$1
ghusers=`cat ${ghuserfile}`
for ghuser in $ghusers; do
    curl -X DELETE -H "Accept: application/vnd.github.v3+json" -u ${GITHUB_USERNAME}:${GITHUB_TOKEN} https://api.github.com/repos/${ghorg}/${ghuser}
    echo "Deleting repository for ${ghuser}"
done
