echo ${TARGET_ENV_PROD}

npm version 
git submodule update --init
cp ~/npmrc-config/ .npmrc ~/.npmrc
node --version
npm install --save-dev

# https://www.jfrog.com/confluence/display/JFROG/QuickStart+Guide%3A+JFrog+Self-Hosted
# http://localhost:8082/artifactory
# used jfrog 7.5.5 and java version "11.0.12" 2021-07-20 LTS

# artifactory base url
# go to install folder and then app->bin->artifactory.bat
# click on localhost http://localhost:8082/artifactory
# https://amiya.devops.com/
# https://amiya.devops.com/artifactory/npm/


echo "=================build Snapshot Artifacts BEGIN====================="
echo "Building Zip files for Deployement"
npm run build
echo "=================build Snapshot Artifacts END====================="

echo "=================publish snapshot to Artifactory BEGIN====================="
npm publish --registry $Artifactory_URL
echo "=================publish snapshot to Artifactory END====================="
