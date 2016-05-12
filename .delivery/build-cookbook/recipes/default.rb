#
# Cookbook Name:: build-cookbook
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Determine the base directory to work with
base_dir = File.expand_path("#{node['delivery']['workspace']['repo']}")

# Iterate around the types of extensions that need to be created
node['delivery']['extension_type'].each |type|
  directory "#{{base_dir}}/#{{type}}"
end
