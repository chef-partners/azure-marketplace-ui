
declare var __dirname

import * as path from "path"
import * as commandLineArgs from "command-line-args"
import * as fs from "fs-extra"
import * as colors from "colors/safe"
import * as Mustache from "mustache"
import * as changeCase from "change-case"
import * as common from "./common.js"

// Read in the configuration file
let config = common.getConfig()

// Define the options that can be set
const optionDefinitions = [
    {
        name: 'version', alias: 'v', type: String, defaultValue: config["version"]
    },
    {
        name: 'type', alias: 't', type: String, defaultValue: "beta"
    },
    {
        name: 'directory', alias: 'd', type: String, defaultValue: path.join(config["paths"]["basedir"], "build")
    },
    {
        name: 'models', alias: 'm', type: String, multiple: true, defaultValue: ["arm", "classic"]
    }
]

const options = commandLineArgs(optionDefinitions);

// Create the build directory if it does not exist
console.log(colors.cyan("Checking for build directory"))
if (!fs.existsSync(options["directory"])) {
    console.log(colors.yellow("  Creating: %s"), options["directory"])
    fs.mkdirSync(options["directory"])
} else {
    console.log(colors.green("  Exists"))
}

// Read in the template files so that they can be written out with the required substiutions
let template = {
    "ui_definition": fs.readFileSync(path.join(config["paths"]["basedir"], "templates", "UIDefinition.json"), "utf-8"),
    "manifest": fs.readFileSync(path.join(config["paths"]["basedir"], "templates", "Manifest.json"), "utf-8"),
    "strings": {
        "resources": fs.readFileSync(path.join(config["paths"]["basedir"], "templates", "Strings", "Resources.resjson"), "utf-8")
    },
    "artifacts": {
        "maintemplate": fs.readFileSync(path.join(config["paths"]["basedir"], "templates", "Artifacts", "MainTemplate.json"), "utf-8"),
        "createuidefinition": fs.readFileSync(path.join(config["paths"]["basedir"], "templates", "Artifacts", "CreateUIDefinition.json"), "utf-8")
    }
    
}

let replacements = {}

// Iterate around the models
console.log(colors.cyan("Generating files"))
for (let model of options["models"]) {
    
    console.log(colors.green("  Model: %s"), model)

    // Create the directory for the model in the build dir
    let model_dir = path.join(options["directory"], model)
    if (!fs.existsSync(model_dir)) {
        fs.mkdirSync(model_dir)
    }

    // Iterate around the platforms
    for (let platform in config["platforms"]) {

        console.log(colors.grey("    Platform: %s"), platform)

        let platform_dir = path.join(model_dir, platform)
        if (!fs.existsSync(platform_dir)) {
            fs.mkdirSync(platform_dir)
        }

        // Create the necessary nested directories
        let dirs = ["Artifacts", "Strings"]
        for (let dir of dirs) {
            let full_path = path.join(platform_dir, dir)
            if (!fs.existsSync(full_path)) {
                fs.mkdirSync(full_path)
            }
        }

        // Write out the ui_definition file
        console.log(colors.yellow("      UIDefinition.json"))
        replacements = {
            extension: config["models"][model]["extension"]
        }
        let ui_definition = Mustache.render(template["ui_definition"], replacements)
        fs.writeFileSync(path.join(platform_dir, "UIDefinition.json"), ui_definition)

        // Manifest file
        console.log(colors.yellow("      Manifest.json"))
        replacements = {
            platform: platform,
            suffix: config["models"][model]["suffix"],
            version: options["version"],
            categories: JSON.stringify(config["platforms"][platform]["categories"]),
            filters: JSON.stringify(config["platforms"][platform]["filters"][options["type"]])
        }
        let manifest = Mustache.render(template["manifest"], replacements)
        fs.writeFileSync(path.join(platform_dir, "Manifest.json"), manifest)

        // Strings resource file
        console.log(colors.yellow("      Strings/Resources.resjson"))
        replacements = {
            platform: changeCase.titleCase(platform),
            version: options["version"],
            extra: options["type"] == "beta" ? " Beta" : ""
        }
        let strings_resources = Mustache.render(template["strings"]["resources"], replacements)
        fs.writeFileSync(path.join(platform_dir, "Strings", "Resources.resjson"), strings_resources)

        // MainTemplate file
        console.log(colors.yellow("      Artifacts/MainTemplate.json"))
        replacements = {
            resource_name: config["platforms"][platform]["resource_name"],
            resource_type: config["models"][model]["type"],
            api_version: config["models"][model]["api_version"],
            arm: model == "arm",
            classic: model == "classic",
            type: config["platforms"][platform]["type"]
        }

        // Add specific items depdening on the model
        if (model == "arm") {
            replacements["type_handler_version"] = config["models"][model]["type_handler_version"]
            replacements["auto_upgrade_minor_version"] = config["models"][model]["auto_upgrade_minor_version"]
        } else if (model == "classic") {
            replacements["classic_version"] = config["models"][model]["version"]

        }

        let artifacts_maintemplate = Mustache.render(template["artifacts"]["maintemplate"], replacements)
        fs.writeFileSync(path.join(platform_dir, "Artifacts", "MainTemplate.json"), artifacts_maintemplate)

        // Create UI Definition file
        console.log(colors.yellow("      Artifacts/CreateUIDefinition.json"))
        replacements = {
            handler: config["models"][model]["handler"]
        }
        let artifacts_createuidefinition = Mustache.render(template["artifacts"]["createuidefinition"], replacements)
        fs.writeFileSync(path.join(platform_dir, "Artifacts", "CreateUIDefinition.json"), artifacts_createuidefinition)

        // Copy icons to the correct directory
        console.log(colors.yellow("      Icons"))
        fs.copySync(path.join(config["paths"]["basedir"], "templates", "Icons"), path.join(platform_dir, "Icons"))

    }
}
