#
# Cookbook Name:: build-cookbook
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Ensure that the output_dir is empty to clear out previous builds
directory node['extension']['output']['dir'] do
  action :delete
  recursive true
end
