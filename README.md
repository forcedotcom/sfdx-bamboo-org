# sfdx-bamboo-org

For a fully guided walk through of setting up and configuring this sample, see the [Continuous Integration Using Salesforce DX](https://trailhead.salesforce.com/modules/sfdx_travis_ci) Trailhead module.

This repository shows how to successfully setup deploying to non-scratch orgs (i.e. Sandbox or Production) with Bamboo. We make a few assumptions in this README:

- You know how to get your GitHub repository setup with Bamboo. (Here's their [Getting Started guide](https://confluence.atlassian.com/bamboo/getting-started-with-bamboo-289277283.html).)
- You have properly setup JWT-Based Authorization Flow (i.e. headless). We recommended using [these steps for generating your Self-Signed SSL Certificate](https://devcenter.heroku.com/articles/ssl-certificate-self). 

If any any of these assumptions aren't true, the following steps won't work.

## Getting Started
1) [Fork](http://help.github.com/fork-a-repo/) this repo into your GitHub account using the fork link at the top of the page.

2) Clone your forked repo locally: `git clone https://github.com/<git_username>/sfdx-bamboo-org.git`

3) Make sure you have the Salesforce CLI installed. Check by running `sfdx force --help` and confirm you see the command output. If you don't have it installed you can download and install it from [here](https://developer.salesforce.com/tools/sfdxcli).

4) Setup a JWT-based auth flow for the target orgs that you want to deploy to.  This step will create a server.key file that will be used in subsequent steps.
(https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_jwt_flow.htm)  

5) Confirm you can perform a JWT-based auth to the target orgs: `sfdx force:auth:jwt:grant --clientid <your_consumer_key> --jwtkeyfile server.key --username <your_username>`

   **Note:** For more info on setting up JWT-based auth see [Authorize an Org Using the JWT-Based Flow](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_jwt_flow.htm) in the [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev).

6) From your JWT-Based connected app on Salesforce, retrieve the generated `Consumer Key`.

7) Setup Bamboo [plan variables](https://confluence.atlassian.com/bamboo/defining-plan-variables-289276859.html) for your Salesforce `Consumer Key` and `Username`. Note that this username is the username that you use to access your Salesforce org.

    Create a plan variable named `SF_CONSUMER_KEY`.

    Create an plan variable named `SF_USERNAME`.

8) Encrypt your `server.key` file that you generated previously and add the encrypted file (`server.key.enc`) to the folder named `assets`.

    `openssl aes-256-cbc -salt -e -in server.key -out server.key.enc -k password`

9) Setup Bamboo [plan variable](https://confluence.atlassian.com/bamboo/defining-plan-variables-289276859.html) for the password you used to encrypt your `server.key` file.

    Create an plan variable named `SERVER_KEY_PASSWORD`.

And you should be ready to go! Now when you commit and push a change, your change will kick off a Bamboo build.

Enjoy!

## Contributing to the Repository ###

If you find any issues or opportunities for improving this repository, fix them!  Feel free to contribute to this project by [forking](http://help.github.com/fork-a-repo/) this repository and make changes to the content.  Once you've made your changes, share them back with the community by sending a pull request. Please see [How to send pull requests](http://help.github.com/send-pull-requests/) for more information about contributing to Github projects.

## Reporting Issues ###

If you find any issues with this demo that you can't fix, feel free to report them in the [issues](https://github.com/forcedotcom/sfdx-bamboo-org/issues) section of this repository.