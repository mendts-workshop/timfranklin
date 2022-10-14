# Number of users participating in a (single) GH/SCA/SAST organization.
export GH_USERS_PER_ORG=20
# To setup SAST organizations for workshop participants, change to true.
export SAST_RUN_SCRIPT=false

# GitHub script:
# You can obtain the GH Token from your manager.
export GH_TOKEN=ghp_token
export GH_ORGS="mendts-workshop, mendts-workshop1, mendts-workshop2"
export GH_USERNAME=ts-whitesource
chmod +x ./workshop-cleanup-github.sh && ./workshop-cleanup-github.sh ghusers.txt

# SCA script:
# You can obtain API tokens and User keys from MendTS-Workshop/1/2 orgs and tsworkshop/1/2 service users.
export WS_APIKEYS="apiKey, apiKey1, apiKey2"
export WS_USERKEYS="userKey, userKey1, userKey2"
export WS_WSS_URL="https://saas.mend.io/api/v1.3"
chmod +x ./workshop-cleanup-sca.sh && ./workshop-cleanup-sca.sh emails.txt

# SAST script - Uncommented in order to set up SAST organizations for workshop participants.
# You can obtain API tokens from MendTS-Workshop/1/2 orgs.
export SAST_API_TOKENS="apiToken, apiToken1, apiToken2"
export SAST_URL=https://sast.mend.io/sast
if $SAST_RUN_SCRIPT; then
   chmod +x ./workshop-cleanup-sast.sh && ./workshop-cleanup-sast.sh emails.txt
fi
