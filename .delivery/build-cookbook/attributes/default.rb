
# Specify the flavours of extension that need to be built
default['extension']['platforms']["linux"] = {
  "type" => "LinuxChefClient",
  "resource_name" => "LinuxChefExtension",
  "category_name" =>"compute-vmextension-linux",
  "categories" => [],
  "filters" => [
  ],
  "beta-filters" => [
    {
      "type" => "HideKey",
      "value" => "chef_linuxchefextension"
    }
  ]
}

default['extension']['platforms']["windows"] = {
  "type" => "ChefClient",
  "resource_name" => "WindowsChefExtension",
  "category_name" => "compute-vmextension-windows",
  "categories" => [],
  "filters" => [
  ],
  "beta-filters" => [
    {
      "type" => "HideKey",
      "value" => "chef_windowschefextension"
    }
  ]
}

# Set the models within azure that the extension is to be used for
default['extension']['models'] = {
  "arm" => {
    "suffix" => "-arm",
    "tag" => "",
    "extension" => "Microsoft_Azure_Compute",
    "handler" => "Microsoft.Compute.VmExtension",
    "type" => "Microsoft.Compute",
    "api-version" => "2015-06-15",
    "typeHandlerVersion" => "1210.12",
    "autoUpgradeMinorVersion" => true,
    "settings" => "settings",
    "protected" => "protectedSettings"
  },
  "classic" => {
    "suffix" => "",
    "tag" => "classic",
    "extension" => "Microsoft_Azure_Classic_Compute",
    "handler" => "Microsoft.ClassicCompute.VmExtension",
    "type" => "Microsoft.ClassicCompute",
    "api-version" => "2015-06-01",
    "version" => "1*",
    "settings" => "parameters.public",
    "protected" => "parameters.private"
  }
}

# Set the version number of the extension
default['extension']['version'] = "1.2.1"

# Set the flag to state if this is a beta version, e.g. hidden for testing
default['extension']['beta'] = true

# Define the list if icons that need to be written out
default['extension']['icons'] = [
  "cheflogo40x.png",
  "cheflogo90x.png",
  "cheflogo115x.png",
  "cheflogo255xwide.png",
  "cheflogo815xhero.png"
]

# Set the directory for the output
default['extension']['output']['dir'] = "/tmp/ui-extension"
