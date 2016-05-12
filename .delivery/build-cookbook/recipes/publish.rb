#
# Cookbook Name:: build-cookbook
# Recipe:: publish
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

base_dir = File.expand_path("../../../")

# Recipe to ensure that the extension for all types is built in the correct directory
node['delivery']['extension_type'].each do |type|

  # determine the directory that the artifacts should be created in
  artifact_dir = File.join(base_dir, type)

  # Determine the output path for the CreateUIDefinition
  createuiddefinition_path = File.join(artifact_dir, 'Artifacts', 'CreateUIDefinition.json')

  # Ensure that the directory exists for the path
  directory "#{type}-artifacts" do
    path File.dirname(createuiddefinition_path)
  end

  # Write out the CreateUIDefinition file
  template "create-ui-definition" do
    path
    source "CreateUIDefinition.json.erb"
  end

end
