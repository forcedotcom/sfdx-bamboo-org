REM
REM Download Salesforce CLI and install it
REM

REM Decrypt server key
openssl aes-256-cbc -d -md md5 -in assets/server.key.enc -out assets/server.key -k %bamboo_SERVER_KEY_PASSWORD%

REM Set up SFDX environment variables
set SFDX_AUTOUPDATE_DISABLE="false"
set SFDX_USE_GENERIC_UNIX_KEYCHAIN="true"
set SFDX_DOMAIN_RETRY="300"
set SFDX_DISABLE_APP_HUB="true"
set SFDX_LOG_LEVEL="DEBUG"
set DEPLOYDIR="src"
set TESTLEVEL="RunLocalTests"

REM Output CLI version and plugin information
sfdx --version
sfdx plugins --core

REM
REM Deploy metadata to Salesforce
REM

REM Authenticate to Salesforce using the server key
sfdx force:auth:jwt:grant --instanceurl https://test.salesforce.com --clientid %bamboo_SF_CONSUMER_KEY% --jwtkeyfile assets/server.key --username %bamboo_SF_USERNAME% --setalias UAT 

REM Deploy metadata and execute unit tests
sfdx force:mdapi:deploy --wait 10 --deploydir %DEPLOYDIR% --targetusername UAT --testlevel %TESTLEVEL%

REM Example shows how to run a check-only deploy
REM sfdx force:mdapi:deploy --checkonly --wait 10 --deploydir %DEPLOYDIR% --targetusername UAT --testlevel %TESTLEVEL%
