"use strict";

const gulp = require('gulp');
const path = require('path');
const del = require('del');
const zip = require('gulp-zip');
const packageJson = require('./package.json')
const replaceInFile = require('replace-in-file');
const { readdirSync } = require('fs');

// define where the files will be placed
const PROJECT_ROOT = ".";
const MODULE_DIR = `${SRC_DIR}/${MODULE_NAME}`;
const DIST_DIR = `${BUILD_DIR}/dist-${MODULE_NAME}`;
const TARGET_DIR = `${BUILD_DIR}/target-${MODULE_NAME}`;
const UBER_ZIP = getArtifactName();
const VERSION = getVersion();

// Terraform
const TERRAFORM_DIR = `${PROJECT_ROOT}/terraform`;

// delete the dist directory and everything under it
const cleanDist = () => {
    return del(DIST_DIR);
}

/// delete the target directory and everything under it
const cleanTarget = () => {
    return del(TARGET_DIR);
}

const copyZipFIles = () => {
    return gulp.src(
            getSubZipFiles()
        )
        .pipe(gulp.dest(DIST_DIR));
};

const copyTerraformFiles = () => {
    return gulp.src(
            [
                `${TERRAFORM_DIR}/**/*`
            ]
        )
        .pipe(gulp.dest(DIST_DIR));
};

const setVersionInTerraformFiles = (done) => {
    try {
        console.log("Set version in Terraformm Files");
        let options = {
            files: `${DIST_DIR}/vars/*.tfvars`,
            from: /\${version}/g,
            to: getVersion()
        };
        console.log(replaceInFile.sync(options));

        options = {
            files: `${DIST_DIR}/**/*.tf`,
            from: /\${version}/g,
            to: getVersion()
        };
        console.log(replaceInFile.sync(options));
        done();
    } catch (err) {
        console.log("Error Writing Terraform variables: " + err);
    }
};

const zipIt = () => {
    return gulp.src(`${DIST_DIR}/**/*`)
        .pipe(zip(UBER_ZIP))
        .pipe(gulp.dest(`${TARGET_DIR}`));
}

function getArtifactName() {
    return `${packageJson.name}.${packageJson.version}.zip`;
}

function getVersion() {
    return packageJson.version;
}

function getSubZipFiles() {
    const projectSubDirs = readdirSync(`${PROJECT_ROOT}/src`, { withFileTypes: true })
        .filter(direct => direct.isDirectory())
        .map(direct => direct.name);
    const subZipFiles = [];
    projectSubDirs.forEach(dir => {
        subZipFiles.push(`${PROJECT_ROOT}/target-${dir}/${dir}.${VERSION}.zip`);
    });
    return subZipFiles;
}

const doneAll = (cb) => {
    console.log(`distribution created in ${path.resolve(DIST_DIR)}`)
    console.log(`zipped target file created in ${path.resolve(TARGET_DIR)}`);
    cb();
}

const build = gulp.series(
    gulp.parallel(cleanDist, cleanTarget),
    copyZipFIles,
    copyTerraformFiles,
    setVersionInTerraformFiles,
    zipIt,
    doneAll
)

gulp.task('build', build);
gulp.task('default', build);