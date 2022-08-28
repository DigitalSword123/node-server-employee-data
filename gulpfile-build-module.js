"use strict";

const gulp = require('gulp');
const minimist = require('minimist');
const path = require('path');
const del = require('del');
const zip = require('gulp-zip');
const tap = require('gulp-tap');
const exec = require('child_process').exec;
const packageJson = require('./package.json')

let knownOptions = {
    string: ['module-name', 'index-name'],
    default: {}
}

let options = minimist(process.argv.slice(2), knownOptions);

const MODULE_NAME = options["module-name"];
const PROJECT_ROOT = ".";
const BUILD_DIR = ".";
const SRC_DIR = `${PROJECT_ROOT}/src`;
const MODULE_DIR = `${SRC_DIR}/${MODULE_NAME}`;
const DIST_DIR = `${BUILD_DIR}/dist-${MODULE_NAME}`;
const TARGET_DIR = `${BUILD_DIR}/target-${MODULE_NAME}`;
const OUTPUT_FILE_NAME = getArtifactName();

// delete the dist directory and everything under it
const cleanDist = () => {
    console.log("Build Module Begin");
    console.log(`Module=${options["module-name"]}`);
    console.log(`Index=${options["index-name"]}`);
    return del(DIST_DIR);
}

// delete the target directory and everything under it
const cleanTarget = () => {
    return del(TARGET_DIR);
}