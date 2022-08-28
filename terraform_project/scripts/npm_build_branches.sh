echo ${TARGET_ENV_PROD}

npm version 
git submodule update --init
cp ~/npmrc-config/ .npmrc ~/.npmrc
node --version
npm install --save-dev

# https://www.jfrog.com/confluence/display/JFROG/QuickStart+Guide%3A+JFrog+Self-Hosted
# http://localhost:8082/artifactory


echo "=================build Snapshot Artifacts BEGIN====================="
echo "Building Zip files for Deployement"
npm run build
echo "=================build Snapshot Artifacts END====================="

echo "=================publish snapshot to Artifactory BEGIN====================="
npm publish --registry $Artifactory_URL
echo "=================publish snapshot to Artifactory END====================="
