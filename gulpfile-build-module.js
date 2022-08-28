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

// get the name of the Module and its entry point
let options = minimist(process.argv.slice(2), knownOptions);

// define where the files will be placed
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

const copyBaseFiles = () => {
    gulp.src(
            [
                `${MODULE_DIR}/index.js`,
                `${MODULE_DIR}/locals.js`
            ], { allowEmpty: true }
        )
        .pipe(gulp.dest(DIST_DIR));
    return gulp.src(
        [
            `${PROJECT_ROOT}/package.json`
        ]
    )

    .pipe(gulp.dest(DIST_DIR));
};

const copyLibFiles = () => {
    return gulp.src(
            [
                `${MODULE_DIR}/lib/**`
            ]
        )
        .pipe(gulp.dest(`${DIST_DIR}/lib`))
};

const installpackages = (cb) => {
    exec(`cd ${DIST_DIR} && npm install --production=true --registry https://amiya.devops.com/artifactory/api/npm/npm/packages`, (err => {
            cb(err)
        }

    ));
};

// zip the dist directory
// we use a tap to determine if the file should be a directory, executable, config or regular
// file and set the mode explicitly in the zip file
// this allows windows builds to work correctly when unzipping to Linux
const ziplit = () => {
    del(`${DIST_DIR}/common-lib`);
    let dirmode = parseInt('40755', 8);
    let filemode = parseInt('100644', 8);

    return gulp.src(tap((file) => {
            if (file.stat.isDirectory()) {
                file.stat.mode = dirmode;
            } else {
                file.stat.mode = filemode;
            }
        }))
        .pipe(zip(OUTPUT_FILE_NAME))
        .pipe(gulp.dest(`${TARGET_DIR}`));
};

function getArtifactName() {
    return `${MODULE_NAME}.${packageJson.version}.zip`;
}

const done = (cb) => {
    console.log(`distribution created in ${path.resolve(DIST_DIR)}`)
    console.log(`zipped target file created in ${path.resolve(TARGET_DIR)}`);
    cb();
}

const build = gulp.series(
    cleanDist,
    cleanTarget,
    copyBaseFiles,
    copyLibFiles,
    installpackages,
    ziplit,
    done
);

gulp.task('build', build);
gulp.task('default', build);