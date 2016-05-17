require 'open-uri'
require 'net/http'
require 'cgi'
require 'pastebin'

task :default => :gen_test_url

desc 'create a rendered version of the CreateUiDefinition.json file'
task :gen_test_url, :resource_id do |t, args|
    fail 'No resource id provided, please supply the resource id for the vm youre testing on' unless args[:resource_id]
    file_content = File.read('./Artifacts/CreateUiDefinition.json')
    parsed_uri = URI(Pastebin.new(api_paste_code: file_content, api_paste_name: "CreateUiDefinition#{Time.now.to_i}.json").paste)
    parsed_uri.path = "/raw" + parsed_uri.path
    escaped_uri = CGI.escape(parsed_uri.to_s)
    escaped_resource_id = CGI.escape(args[:resource_id].to_s)
    url_template = %Q|https://portal.azure.com/#blade/Microsoft_Azure_Compute/AddVmExtension/internal_bladeCallId/anything/internal_bladeCallerParams/{"initialData":{},"providerConfig":{"id":"{resource_id}","createUiDefinition":"{blob_url}"}}|
    url_template['{resource_id}'] = escaped_resource_id
    url_template['{blob_url}'] = escaped_uri
    puts url_template
end