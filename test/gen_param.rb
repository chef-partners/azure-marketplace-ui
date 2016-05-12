
# Generate the parameters from the JSON that has been downloaded from the
# UI testing

require 'optparse'
require 'json'
require 'erb'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: gen_param.rb [options]"

  opts.on('-f', '--file FILE', 'Path to the json file') { |v| options[:file] = v }
  opts.on('-j', '--json STRING', 'JSON string to be decoded') { |v| options[:string] = v}
end.parse!

# Read in the contents of the file
if !options[:file].nil? then
  json_string = File.read(options[:file])
end

if !options[:string].nil? then
  json_string = options[:string]
end

# Decode the JSON string
params = JSON.parse json_string

# Read in the template file
template = File.read('parameters.json.erb')
renderer = ERB.new(template)

# Write out the file
File.write("parameters.json", renderer.result())
