
# Specify the flavours of extension that need to be built
default['extension']['platforms']["linux"] = {
  "type" => "LinuxChefClient",
  "resource_name" => "LinuxChefExtension",
  "categories" => ["compute-vmextension-linux"],
  "filters" => [
    {
      "type": "HideKey"
      "value" => "chef_linuxchefextension"
    }
  ]
}

default['extension']['platforms']["windows"] = {
  "type" => "ChefClient",
  "resource_name" => "WindowsChefExtension",
  "categories" => ["compute-vmextension-windows"],
  "filters" => [
    {
      "type": "HideKey"
      "value" => "chef_windowschefextension"
    }
  ]
}

# Set the version number of the extension
default['extension']['version'] = "1.0.1"

# Define the list if icons that need to be written out
default['extension']['icons'] = [
  "cheflogo40x.png",
  "cheflogo90x.png",
  "cheflogo115x.png",
  "cheflogo255xwide.png",
  "cheflogo815xhero.png"
]

# Set the directory for the output
default['extension']['output']['dir'] = "/tmp"
