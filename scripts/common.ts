
declare var __dirname

import * as path from "path"
import * as fs from "fs-extra"
import {sprintf} from "sprintf-js"

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

export function getVersion(version, type) {

    let type_version = ""

    switch(type) {
        case "beta":
            type_version = sprintf("%s.0", version)
            break;
        case "release":
            type_version = sprintf("%s.1", version)
            break;
    }

    return type_version
}