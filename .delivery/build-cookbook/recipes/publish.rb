#
# Cookbook Name:: build-cookbook
# Recipe:: publish
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'json'

# Iterate around the models
node['extension']['models'].each do |model, info|

  output_dir = File.join(node['extension']['output']['dir'], model)

  # Recipe to ensure that the extension for all types is built in the correct directory
  node['extension']['platforms'].each do |platform, details|

    # determine the directory that the artifacts should be created in
    artifact_dir = File.join(output_dir, platform)

    # determine the output locations
    outputs = {
      "createuidefinition" => File.join(artifact_dir, 'Artifacts', 'CreateUIDefinition.json'),
      "maintemplate" => File.join(artifact_dir, 'Artifacts', 'MainTemplate.json'),
      "manifest" => File.join(artifact_dir, "Manifest.json"),
      "stringresources" => File.join(artifact_dir, "Strings", "Resources.resjson"),
      "uidefinition" => File.join(artifact_dir, "UIDefinition.json"),
    }

    # Ensure that the directory exists for the path
    directory "#{platform}-artifacts-dir" do
      path File.dirname(outputs["createuidefinition"])
      recursive true
    end

    directory "#{platform}-icons-dir}" do
      path File.join(artifact_dir, 'Icons')
      recursive true
    end

    directory "#{platform}-strings-dir}" do
      path File.dirname(outputs["stringresources"])
      recursive true
    end

    # Write out the CreateUIDefinition file
    template "create-ui-definition" do
      path outputs["createuidefinition"]
      source "Artifacts/CreateUIDefinition.json.erb"
      variables({
          "platform" => platform,
          "info" => info
      })
    end

    # Main Template
    template "create-maintemplate" do
      path outputs["maintemplate"]
      source "Artifacts/MainTemplate.json.erb"
      variables({
          "platform" => platform,
          "details" => details,
          "info" => info,
          "model" => model
      })
    end

    # Determine the categories for the model
    # This is based on whatever has been specified in the array as well as the
    # category name
    categories = []
    case model
    when "arm"
      categories.push(details['category_name'])
    when "classic"
      categories.push(info['tag'] + details['category_name'].capitalize)
    end

    # add the specified categories
    categories.push(details['categories']).flatten!

    # Determine the filters that need to be set, if any
    filters = []
    if node['extension']['beta'] == true
      filters.push(details['beta-filters'])
    end

    filters.push(details['filters']).flatten!

    # write out the manifest file
    template "manifest" do
      path outputs["manifest"]
      source "Manifest.json.erb"
      variables({
          "model" => model,
          "info" => info,
          "platform" => platform,
          "details" => details,
          "categories" => categories,
          "filters" => filters
      })
    end

    # write out the icons
    node['extension']['icons'].each do |icon|
      cookbook_file icon do
        source "Icons/#{icon}"
        path File.join(artifact_dir, 'Icons', icon)
      end
    end

    # Strings file
    template "#{platform}-strings" do
      path outputs["stringresources"]
      source "Strings/Resources.resjson.erb"
      variables({
          "platform" => platform,
          "version" => node['extension']['version'],
          "extra" => node['extension']['beta'] ? " Beta" : ""
      })
    end

    # Write out the UIDefinition file
    template "#{platform}-uidefinition" do
      path outputs["uidefinition"]
      source "UIDefinition.json.erb"
      variables({
        "extension" => info["extension"]
      })
    end

    # Noe that all the files have been generated for each of the platforms execute the zip
    # command to make zip file archives out of them
    # generate the output filename
    archive_file_name = "azure-marketplace-ui-%s%s.%s%s.zip" % [platform, info['suffix'], node['extension']['version'], node['extension']['beta'] ? "-beta" : ""]
    archive_file_path = File.join(output_dir, archive_file_name)
    bash "#{platform}-#{model}-zip-archive" do
      cwd output_dir
      code <<-EHO
        zip -9 -r #{archive_file_path} #{platform}
      EHO
    end
  end
end
