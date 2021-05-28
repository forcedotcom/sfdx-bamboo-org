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

5) Confirm that you can perform a JWT-based auth to the target orgs: `sfdx auth:jwt:grant --clientid <your_consumer_key> --jwtkeyfile server.key --username <your_username>`

   **Note:** For more info on setting up JWT-based auth, see [Authorize an Org Using the JWT-Based Flow](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_auth_jwt_flow.htm) in the [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev).

6) From your JWT-based connected app on Salesforce, retrieve the generated `Consumer Key`.

7) Set up Bamboo [plan variables](https://confluence.atlassian.com/bamboo/defining-plan-variables-289276859.html) for your Salesforce `Consumer Key` and `Username`. Note that this username is the username that you use to access your Salesforce org.

    Create a plan variable named `CONSUMER_KEY`.

    Create a plan variable named `USER_NAME`.

8) Encrypt and store the generated `server.key`.  IMPORTANT!  For security reasons, don't store the `server.key` within the project.

- First, generate a key and initializtion vector (iv) to encrypt your `server.key` file locally.  The `key` and `iv` are used by AppVeyor to decrypt your server key in the build environment.

```bash
$ openssl enc -aes-256-cbc -k <passphrase here> -P -md sha1 -nosalt
  key=E5E9FA1BA31ECD1AE84F75CAAA474F3A663F05F412028F81DA65D26EE56424B2
  iv =E93DA465B309C53FEC5FF93C9637DA58
```

> Make note of the `key` and `iv` values output to the screen. You'll use the values following `key=` and `iv =` to encrypt your `server.key`.

- Encrypt the `server.key` using the newly generated `key` and `iv` values. Use the `key` and `iv` values only once. Don't use them to encrypt more than the `server.key`. While you can re-use this pair to encrypt other things, it's considered a security violation to do so. Every time you run the command above, it generates a new `key` and `iv` value. You can't regenerate the same pair. If you lose these values, generated new ones and encrypt again.

```bash
openssl enc -nosalt -aes-256-cbc -in your_key_location/server.key -out assets/server.key.enc -base64 -K <key from above> -iv <iv from above>
```
 This command replaces the existing `server.key.enc` with your encrypted version.
 
- Store the `key`, and `iv` values somewhere safe. You'll use these values in a subsequent step in the AppVeyor UI. These values are considered *secret* so please treat them as such.


9) Set up Bamboo [plan variable](https://confluence.atlassian.com/bamboo/defining-plan-variables-289276859.html) for the `key` and `iv` you used to encrypt your `server.key` file.

    Create a plan variable named `DECRYPTION_KEY`.
    Create a plan variable named `DECRYPTION_IV`.

10) Create a Bamboo plan with the build file for your operating system (`build.bat` for Windows and `build.sh` for all others). The build files are included in the root directory of the Git repository.

Now you're ready to go! When you commit and push a change, your change kicks off a Bamboo build.

Enjoy!

## Environment Variables

| Env Var                       | Description                                                                                                     |
| ----------------------------- | --------------------------------------------------------------------------------------------------------------- |
| CONSUMER_KEY                  | From your JWT-based connected app on Salesforce, retrieve the generated `Consumer Key` from your Dev Hub org.   |
| USER_NAME                     | This username is the username that you use to access your Dev Hub.                                              |
| ENDPOINT                      | the login URL of the instance the org lives on.                                                                 |
| DECRYPTION_KEY                | `server.key` encryption key.                                                                                    |
| DECRYPTION_IV                 | `server.key` encryption initialization Vector.                                                                  |
| DX_CLI_URL_CUSTOM             | By default, the script installs the current version of Salesforce CLI. To install the release candidate, set the `DX_CLI_URL_CUSTOM` local variable to the appropriate URL.|


## Contributing to the Repository ###

If you find any issues or opportunities for improving this repository, fix them! Feel free to contribute to this project by [forking](http://help.github.com/fork-a-repo/) this repository and making changes to the content. Once you've made your changes, share them back with the community by sending a pull request. See [How to send pull requests](http://help.github.com/send-pull-requests/) for more information about contributing to GitHub projects.

## Reporting Issues ###

If you find any issues with this demo that you can't fix, feel free to report them in the [issues](https://github.com/forcedotcom/sfdx-bamboo-org/issues) section of this repository.
