# Azure Marketplace UI Extension

This repo contains a Delivery cookbook that bundles up the Windows and Linux versions of the UI extension.

The entire build run is currently configured in `publish.rb`.

The artifacts are, by default, dropped into `/tmp` but this can be modified by changing the the relevant attribute in the cookbook.

As previously mentioned the two archive files are created using a Delivery cookbook.  This means that all the JSON files are now based on templates that are held within the delivery cookbook.  The command to generate them is as follow:

```bash
$> delivery job build publish --local
```

NOTE:  The `delivery-cli` package must be installed for this command to work. (https://docs.chef.io/ctl_delivery.html)

## Using the Extension

This extension allows `chef-client` to be installed on a virtual machine in Azure using the Azure Portal UI.

To use the extension it needs to be added to the machine, either as part of its creation or by adding the extension to an existing machine.  The UI will display a form requesting the necessary information.

| Field Name                  | Description                                                                                           | Required | Example Value                                 |
|:----------------------------|:------------------------------------------------------------------------------------------------------|:---------|:----------------------------------------------|
| Chef Server URL             | URL to the chef server to which the node should register                                              | Yes      | https://api.opscode.com/organizations/example |
| Chef Node Name              | Name of the node when registered with Chef                                                            | Yes      |                                               |
| Run List                    | The run list to apply to the machine after chef-client has been installed                             | No       |                                               |
| Validation Client Name      | Name of the validation key in the Chef Server organization                                            | Yes      | example-validator                             |
| Validation Key              | The validation private key                                                                            | Yes      |                                               |
| Client Configuration File   | A valid `client.rb` file with extra settings that need to be applied.  The environment for example    | No       |                                               |
| Chef Client version         | Version of chef-client to install.  Default is latest.  This *only* applies to Linux machines         | No       |                                               |
| SSL Verification Mode       | SSL peer verification during the chef-client run to the Chef server, default is Verify Peer           | No       | none                                          |
| Chef Environment            | The Chef environment this machine will be placed into                                                 | No       | _default                                      |
| Encrypted Databag Secret    | Place a secret that will be used to access your encrypted databags                                    | No       |                                               |
| Chef Server SSL Certificate | When using ssl verification, this will allow you to specify your Chef Server's certificate as trusted | No       |                                               |

Once all the settings have been configured clicking the 'OK' button at the end of the page will instruct Azure to install `chef-client`.  After a few minutes the machine should show up as a node in the specified chef server.
