![Logo](https://resources.mend.io/mend-sig/logo/mend-dark-logo-horizontal.png)
[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)  
# Technical Services Workshop Setup Tools
This project aims to provide workshop facilitators with tools for setting up environments for workshop participants. TS-Workshop is designed for workshops with many participants so the workload can be distributed among several organizations.
In addition, projects used for workshops can easily be adjusted by the facilitator. Detailed instructions and flows for workshop execution can be found [here](https://whitesource.atlassian.net/wiki/spaces/TES/pages/2500984892/Customer+Workshops).

# Workshop environments
The current workshop setup includes 3 GitHub, SCA, and SAST organizations.
- Workshops typically include GitHub and SCA organizations, while SAST organizations are optional depending on workshop requirements ([SAST focused workshops](#sast-focused-workshops)).
- Additional organizations can be added on demand ([Extending workshop setup](#extending-workshop-setup)).
  - GitHub organizations have 3 predefined secrets that enable the execution of GitHub actions and integration with Mend: APIKEY, USERKEY, and MENDURL.

| GitHub.com organization  | SCA organization | SAST organization |
| --- | --- | --- |
| [mendts-workshop](https://github.com/mendts-workshop) | MendTS-Workshop (https://saas.mend.io) | MendTS-Workshop (https://sast.mend.io/sast) |
| [mendts-workshop1](https://github.com/mendts-workshop1) | MendTS-Workshop1 (https://saas.mend.io) | MendTS-Workshop1 (https://sast.mend.io/sast) |
| [mendts-workshop2](https://github.com/mendts-workshop2) | MendTS-Workshop2 (https://saas.mend.io) | MendTS-Workshop2 (https://sast.mend.io/sast) |

# Prerequisites
-	Fill ghusers.txt with GitHub user accounts that will be participating in the workshop. Do not use commas, just **line separated**.
-	Fill emails.txt with email accounts that will be participating in the workshop. Do not use commas, just **line separated**.

# Tools for setting up a technical workshop
The following parameters are important for understanding the script's functionality:
- **GH_USERS_PER_ORG** - Number of users participating in a (single) GH/SCA/SAST organization.
  - E.g., if GH_USERS_PER_ORG is set to 20 and there are 50 participants in the workshop, the first 20 will be created under MendTS-Workshop (GH/SCA/SAST organization). The next 20 participants will be created in MendTS-Workshop**1** (GH/SCA/SAST organization), and the last 10 in MendTS-Workshop**2** (GH/SCA/SAST organization).
  - It is recommended that organizations have up to 20 users (due to performance considerations).
- **GH_BRANCH** - The branch containing the project that will be used for the workshop (to be pushed to user repositories).
  - E.g., GH_BRANCH=easybuggy, means that the content of easybuggy branch will be pushed to user repositories.
  - [Modifying workshop content](#modifying-workshop-content).

High level overview of the scripts:
- #### GitHub scripts:
  - workshop-setup-github.sh
    - Create repositories in GitHub organizations based on GitHub users list (ghusers.txt). The repository is created with the same name as the GitHub user and give that user admin privileges.
    - Push the workshop project to the user repositories (from the specified branch).
  - workshop-cleanup-github.sh - Delete all repositories in GitHub organizations based on the GitHub users list (ghusers.txt).
- #### SCA scripts:
  - workshop-setup-sca.sh - Create administrator accounts for the email address list (emails.txt) in SCA organizations.
  - workshop-cleanup-sca.sh - Delete all accounts in SCA organizations based on the email address list (emails.txt).
- #### SAST scripts:
  - workshop-setup- sast.sh - Create administrator accounts for the email address list (emails.txt) in SAST organizations.
  - workshop-cleanup-sast.sh - Delete all accounts in SAST organizations based on the email address list (emails.txt).

# Supported operating systems
-	**Linux (Bash)**: CentOS, Debian, Ubuntu, RedHat

# Execution
There are 2 options to execute the scripts
- #### GitHub actions (recommend):
  - Before the workshop
    - Create a new branch and fill the ghusers.txt and emails.txt (as detailed in [Prerequisites](#prerequisites)).
    - Run the TS workshop setup [workshop-setup.yml](https://github.com/mend-toolkit/ts-workshop/actions/workflows/workshop-setup.yml) workflow **(from your branch)** to set up environments for workshop participants.
  - After the workshop
    - Run the TS workshop cleanup [workshop-cleanup.yml](https://github.com/mend-toolkit/ts-workshop/actions/workflows/workshop-cleanup.yml) workflow **(from your branch)** to clean up environments.
    - If any enhancements were performed, push them to the master branch and delete the workshop branch.
- #### Local execution (fallback):
The scripts can be (cloned and) executed locally if GitHub actions cannot be used (e.g. [GitHub actions usage](#github-actions-usage) limit exceeded).
  - ```git clone https://github.com/mend-toolkit/ts-workshop.git && cd ts-workshop```
  - All script parameters must be set, including the parameters that have been predefined as [Repository secrets](#repository-secrets).
  - Fill the ghusers.txt and emails.txt (as detailed in [Prerequisites](#prerequisites)).
  - Run workshop-setup.sh script to set up the environments for workshop participants.
    - ```chmod +x ./workshop-setup.sh && ./workshop-setup.sh```
  - Run workshop-cleanup.sh script to clean up the environments after the workshop.
    - ```chmod +x ./workshop-cleanup.sh && ./cleanup-setup.sh```

# Repository secrets
The following parameters are predefined as repository secrets and need to be defined in case of the [Local execution](#local-execution-fallback).
- GitHub parameters [GitHub scripts](#github-scripts):
  - GH_TOKEN - GitHub token can be obtained from your manager.
- SCA parameters [SCA scripts](#sca-scripts):
  - WS_APIKEYS - API tokens can be obtained from [SCA organizations](#workshop-environments).
  - WS_USERKEYS - Keys can be obtained from service users in [SCA organizations](#workshop-environments).
- SAST parameters [SAST scripts](#sast-scripts):
  - SAST_API_TOKENS - API tokens can be obtained from [SAST organizations](#workshop-environments).

# Appendix
#### SAST focused workshops
SAST scripts are disabled by default and need to be enabled in order to set up SAST organizations for workshop participants.
- SAST_RUN_SCRIPT - Change to true **(lower case)** to enable SAST scripts.
#### Extending workshop setup
Adding new organizations for extended [Workshop environments](#workshop-environments) will require updating the following parameters:
- GitHub parameters [GitHub scripts](#github-scripts):
  - GH_ORGS
- SCA parameters [SCA scripts](#sca-scripts):
  - WS_APIKEYS
  - WS_USERKEYS
- SAST parameters [SAST scripts](#sast-scripts):
  - SAST_API_TOKENS
#### Modifying workshop content
- **Adding new projects for the workshop** - Create a new branch to this repository with the desired content (e.g., the [easybuggy branch](/../../tree/easybuggy) contains the [easybuggy](https://github.com/k-tamura/easybuggy) application).
- **Updating existing projects** - Navigate to the appropriate branch and update the application content as necessary.

# GitHub actions usage
-	https://github.com/settings/billing (Usage this month)
