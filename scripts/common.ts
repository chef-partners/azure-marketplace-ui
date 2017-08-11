
declare var __dirname

import * as path from "path"
import * as fs from "fs-extra"

export function getConfig() {

    // Determine the base directory for the project
    let basedir = path.join(__dirname, "..")

    // Read in the configuration file
    let config_raw = fs.readFileSync(path.join(basedir, "config.json"))
    let config = JSON.parse(config_raw)

    // Add the base dir to the config
    config["paths"] = {
        basedir: basedir
    }

    // Return the configuration
    return config
}