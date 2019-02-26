# sfdx-bamboo-org


For a fully guided walkthrough of setting up and configuring continuous integration using scratch orgs and Salesforce CLI, see the [Continuous Integration Using Salesforce DX](https://trailhead.salesforce.com/modules/sfdx_travis_ci) Trailhead module.

This repository shows how to successfully set up deploying to non-scratch orgs (sandboxes or production) with Bamboo. We make a few assumptions in this README. Continue only if you have completed these critical configuration prerequisites.

- You know how to set up your GitHub repository with Bamboo. (Need help? See the Bamboo [Getting Started guide](https://confluence.atlassian.com/bamboo/getting-started-with-bamboo-289277283.html).)

- You have properly set up the JWT-based authorization flow (headless). We recommended using [these steps for generating your self-signed SSL certificate](https://devcenter.heroku.com/articles/ssl-certificate-self). 

## Getting Started
1) [Fork](http://help.github.com/fork-a-repo/) this repo to your GitHub account using the fork link at the top of the page.

2) Clone your forked repo locally: `git clone https://github.com/<git_username>/sfdx-bamboo-org.git`

3) Make sure that you have Salesforce CLI installed. Run `sfdx force --help` and confirm you see the command output. If you don't have it installed, you can download and install it from [here](https://developer.salesforce.com/tools/sfdxcli).

4) Set up a JWT-based auth flow for the target orgs that you want to deploy to. This step creates a `server.key` file that is used in subsequent steps.
(https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_jwt_flow.htm)  

5) Confirm that you can perform a JWT-based auth to the target orgs: `sfdx force:auth:jwt:grant --clientid <your_consumer_key> --jwtkeyfile server.key --username <your_username>`

   **Note:** For more info on setting up JWT-based auth, see [Authorize an Org Using the JWT-Based Flow](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_jwt_flow.htm) in the [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev).

6) From your JWT-based connected app on Salesforce, retrieve the generated `Consumer Key`.

7) Set up Bamboo [plan variables](https://confluence.atlassian.com/bamboo/defining-plan-variables-289276859.html) for your Salesforce `Consumer Key` and `Username`. Note that this username is the username that you use to access your Salesforce org.

    Create a plan variable named `SF_CONSUMER_KEY`.

    Create a plan variable named `SF_USERNAME`.

8) Encrypt the generated `server.key` file and add the encrypted file (`server.key.enc`) to the folder named `assets`.

    `openssl aes-256-cbc -salt -e -in server.key -out server.key.enc -k password`

9) Set up Bamboo [plan variable](https://confluence.atlassian.com/bamboo/defining-plan-variables-289276859.html) for the password you used to encrypt your `server.key` file.

    Create a plan variable named `SERVER_KEY_PASSWORD`.

10) Create a Bamboo plan with the build file for your operating system selected (`build.bat` for Windows and `build.sh` for all others). The build files are included in the root directory of the Git repository.

Now you're ready to go! When you commit and push a change, your change kicks off a Bamboo build.

Enjoy!

## Contributing to the Repository ###

If you find any issues or opportunities for improving this repository, fix them! Feel free to contribute to this project by [forking](http://help.github.com/fork-a-repo/) this repository and making changes to the content. Once you've made your changes, share them back with the community by sending a pull request. See [How to send pull requests](http://help.github.com/send-pull-requests/) for more information about contributing to GitHub projects.

## Reporting Issues ###

If you find any issues with this demo that you can't fix, feel free to report them in the [issues](https://github.com/forcedotcom/sfdx-bamboo-org/issues) section of this repository.
