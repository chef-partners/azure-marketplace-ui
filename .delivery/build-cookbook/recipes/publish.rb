#
# Cookbook Name:: build-cookbook
# Recipe:: publish
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

base_dir = File.expand_path("#{node['delivery']['workspace']['repo']}")

# Recipe to ensure that the extension for all types is built in the correct directory
node['default']['extension_type'].each |type|

  # determine the directory that the artifacts should be created in
  artifact_dir = File.join(base_dir, type)

  # Write out the CreateUIDefinition file
  template "create-ui-definition" do
    path File.join(artifact_dir, 'Artifacts', 'CreateUIDefinition.json')
    source "CreateUIDefinition.json.erb"
  end

do
