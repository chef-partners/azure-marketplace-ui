
**Update: 2017-08-11**
The build process for this repo has been changed from a Delivery cookbook to a NodeJS implementation.

# Azure Marketplace UI Extension

This repo contains the definition files for generating the Azure Marketplace UI Extension for Chef. The build process, such that it is, is performed using NodeJS and thus various scripts have been created to assist with the packaging of the extension.

# Using the Extension

This extension allows `chef-client` to be installed on a virtual machine in Azure using the Azure Portal UI.

To use the extension it needs to be added to the machine, either as part of its creation or by adding the extension to an existing machine.  The UI will display a form requesting the necessary information.

| Field Name                  | Description                                                                                           | Required | Example Value                                 |
|:----------------------------|:------------------------------------------------------------------------------------------------------|:---------|:----------------------------------------------|
| Chef Server URL             | URL to the chef server to which the node should register                                              | Yes      | https://api.opscode.com/organizations/example |
| Chef Node Name              | Name of the node when registered with Chef                                                            | Yes      |                                               |
| Chef Client version | The version of Chef Client to install. If left blank the latest version is installed. | No | |
| Run List                    | The run list to apply to the machine after chef-client has been installed                             | No       |                                               |
| Validation Client Name      | Name of the validation key in the Chef Server organization                                            | Yes      | example-validator                             |
| Validation Key              | The validation private key                                                                            | Yes      |                                               |
| Client Configuration File   | A valid `client.rb` file with extra settings that need to be applied.  The environment for example    | No       |                                               |
| Chef Client version         | Version of chef-client to install.  Default is latest.  This *only* applies to Linux machines         | No       |                                               |
| SSL Verification Mode       | SSL peer verification during the chef-client run to the Chef server, default is Verify Peer           | No       | peer                                          |
| Chef Environment            | The Chef environment this machine will be placed into                                                 | No       | _default                                      |
| Encrypted Databag Secret    | Place a secret that will be used to access your encrypted databags                                    | No       |                                               |
| Chef Server SSL Certificate | When using ssl verification, this will allow you to specify your Chef Server's certificate as trusted | No       |                                               |

Once all the settings have been configured clicking the 'OK' button at the end of the page will instruct Azure to install `chef-client`.  After a few minutes the machine should show up as a node in the specified chef server.


# Build Process

By default the build process will create 4 output archives:

  1. Linux ARM Beta
  2. Windows ARM Beta
  3. Linux Classic Beta
  4. Windows Classic Beta

**NOTE** The Beta just means that the `hidekey` is enabled for the extension. Please see the HideKey section below for more information.

Unfortunately it is not possible to generate a Beta and Release version of the extension at the same time as the version number for each build _has_ to be different. This is a Microsoft restriction.

By default the build scripts will create extensions for both ARM and Classic models in Azure and they will be beta. The following commands will compile the scripts and then use them to create the necessary packages.

```
npm run build:tasks
npm run script:build
npm run script:package
```

As no arguments have been specified the models and version number will be retrieved from the `config.json` file in the root directory. The default to so create a Beta package. If a specific version is required, e.g. if running in a build service such as VSTS, then the version can be specified as well the model, for example:

```
npm run build:tasks
npm run script:build -- -v 2.3.4 -m arm
npm run script:package -- -v 2.3.4 -m arm
```

The arguments _must_ be specified to both the `build` and `package` calls so that they work in the same properties.

The following table shows the options that can be passed.

| Option | Long Option | Description | Default Value |
|--------|-------------|-------------|---------------|
| -v | --version | Version to be applied to the package | Whatever is set in the `config.json` |
| -t | --type | Whether or not the hidekey will be used, e.g. beta version | beta |
| -d | --directory | Build directory location | &lt;Project Dir&gt;/build |
| -m | --models | The Azure models to build for | arm, classic |

## Hidekey

When a beta version of the extension is created then the hidekey values, as specified in the `config.json` file, are required when testing the extension in Azure.

| Platform | Default Hidekey Value |
|----------|-----------------------|
| Linux | chef_linuxchefextension |
| Windows | chef_windowschefextension |
