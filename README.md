# Pi Configuration

Scripts and systemd unit to configure an application's environment variables.

## Motivation

For most of my Raspberry Pi projects I need to configure an app with secret environment variables. I always use systemd to initialize my applications. This tool uses Heroku as a secrets storage getting the secrets and setting environment variables before starting a given application. This operates similar to a Vault agent configuring an app's secret variables on application startup.

---
## Installation

- Create a [Heroku](https://dashboard.heroku.com) application and set any Config Vars required by your application
- Using the Heroku cli, generate an API key: `heroku authorizations:create -s read-protected -d <description>`
- Create your application script or binary
- From a terminal on your Raspberry Pi run the following to run the installation script. Have your API key, Heroku app name, and the full path of your script or binary ready to enter into the prompt ready to enter into the prompt
    
    ```bash <(curl -s -H 'Cache-Control: no-cache' https://raw.githubusercontent.com/andrewmarklloyd/pi-config/main/install.sh)```
