
declare var __dirname

import * as common from "./common.js"
import * as commandLineArgs from "command-line-args"
import * as colors from "colors/safe"
import * as path from "path"
import * as zipFolder from "zip-folder"
import {vsprintf} from "sprintf-js"

// Read in the configuration file
let config = common.getConfig()

// Define the options that can be set
const optionDefinitions = [
    {
        name: 'version', alias: 'v', type: String, defaultValue: config["version"]
    },
    {
        name: 'types', alias: 't', type: String, multiple: true, defaultValue: ["beta", "release"]
    },
    {
        name: 'directory', alias: 'd', type: String, defaultValue: path.join(config["paths"]["basedir"], "build")
    },
    {
        name: 'models', alias: 'm', type: String, multiple: true, defaultValue: ["arm"]
    }
]

const options = commandLineArgs(optionDefinitions);

// Iterate around the models
console.log(colors.cyan("Creating Zip Files"))
for (let model of options["models"]) {

    let model_dir = path.join(options["directory"], model)

    // iterate around the release types
    for (let type of options["types"]) {

        // Create the directory for the type
        let type_dir = path.join(model_dir, type)

        let version = common.getVersion(options["version"], type)

        // iterate around the platforms
        for (let platform in config["platforms"]) {

            // Determine the platform dir
            let platform_dir = path.join(type_dir, platform)

            // Determine the zip filename
            let filename_parts = [
                platform,
                config["models"][model]["suffix"],
                version,
                type == "beta" ? "-beta" : ""
            ]
            let zip_filename = path.join(options["directory"], vsprintf("azure-marketplace-ui-%s%s.%s%s.zip", filename_parts))
            
            zipFolder(platform_dir, zip_filename, function(err) {
                if (err) {
                    console.log(colors.red("  FAILED"), err)
                } else {
                    console.log(colors.green("  SUCCESS: %s"), zip_filename)
                }
            })
        }

    }
}