# Azure Marketplace Extension

**This is the Linux version of the extension, for the Windows version please refer to https://github.com/chef-partners/azure-marketplace-extension-windows**

This extension allows `chef-client` to be installed on a Linux virtual machine in Azure using the Azure Portal UI.

To use the extension it needs to be added to the machine, either as part of its creation or by adding the extension to an existing machine.  The UI will display a form requesting the necessary information:

![Chef Client Extension](/images/ame_form.png)

| Field Name                | Description                                                                                        | Required | Example Value                                 |
|:--------------------------|:---------------------------------------------------------------------------------------------------|:---------|:----------------------------------------------|
| Chef Server URL           | URL to the chef server to which the node should register                                           | Yes      | https://api.opscode.com/organizations/example |
| Chef Node Name            | Name of the node when registered with Chef                                                         | Yes      | **Must be the same as the hostname**          |
| Run List                  | The run list to apply to the machine after chef-client has been installed                          | No       |                                               |
| Validation Client Name    | Name of the validation key in the Chef Server organization                                         | Yes      | example-validator                             |
| Validation Key            | The validation private key                                                                         | Yes      |                                               |
| Client Configuration File | A valid `client.rb` file with extra settings that need to be applied.  The environment for example | No       |                                               |
| Chef Client version       | Version of chef-client to install.  Default is latest                                              | No       |                                               |

The 'Chef Node Name' **must** be the same as the hostname that has been applied to the virtual machine.  This is due to the way in which the resources are built up internally.  As there is currentl no way to get the `vmName` from the server into the extension form then this must be done manually.  If the 'Chef Node Name' and 'hostname' differ then the extension will fail to install.

Once all the settings have been configured clicking the 'OK' button at the end of the page will instruct Azure to install `chef-client`.  After a few minutes the machine should show up as a node in the specified chef server.
