#
# Download Salesforce CLI and install it
#

# Decrypt server key
openssl aes-256-cbc -d -md md5 -in assets/server.key.enc -out assets/server.key -k $bamboo_SERVER_KEY_PASSWORD

# Setup SFDX environment variables
export CLIURL=https://developer.salesforce.com/media/salesforce-cli/sfdx-linux-amd64.tar.xz  
export SFDX_AUTOUPDATE_DISABLE=false
export SFDX_USE_GENERIC_UNIX_KEYCHAIN=true
export SFDX_DOMAIN_RETRY=300
export SFDX_DISABLE_APP_HUB=true
export SFDX_LOG_LEVEL=DEBUG
export DEPLOYDIR=src
export TESTLEVEL=RunLocalTests

# Install CLI
mkdir sfdx
wget -qO- $CLIURL | tar xJ -C sfdx --strip-components 1
"./sfdx/install"
export PATH=./sfdx/$(pwd):$PATH

# Output CLI version and plug-in information
sfdx --version
sfdx plugins --core

#
# Deploy metadata to Salesforce
#

# Authenticate to Salesforce using the server key
sfdx force:auth:jwt:grant --instanceurl https://test.salesforce.com --clientid $bamboo_SF_CONSUMER_KEY --jwtkeyfile assets/server.key --username $bamboo_SF_USERNAME --setalias UAT 

# Deploy metadata and execute unit tests
sfdx force:mdapi:deploy --wait 10 --deploydir $DEPLOYDIR --targetusername UAT --testlevel $TESTLEVEL

# Example shows how to run a check-only deploy
#- sfdx force:mdapi:deploy --checkonly --wait 10 --deploydir $DEPLOYDIR --targetusername UAT --testlevel $TESTLEVEL
