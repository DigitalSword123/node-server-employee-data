echo ${TARGET_ENV_PROD}

echo "$(pwd)"

ls -al

echo "******************reading VARIABLE_FILE start*****************"
cat ${VARIABLE_FILE}
echo "******************reading VARIABLE_FILE end*****************"

source ${VARIABLE_FILE}
 
npm version $CURRENT_SNAPSHOT_VER --no---git-tag-version
git submodule update --init
cp ./npmrc-config/.npmrc ~/.npmrc
ls -al
echo "^^^^^^^^^^^^printing .npmrc file^^^^^^^^^^^^^^^^^"
cd ~
cat .npmrc
cd ~/node-server-employee-data
echo node version=$(node --version)
echo npm version=$(npm --version)
npm install --save-dev


# https://www.jfrog.com/confluence/display/JFROG/QuickStart+Guide%3A+JFrog+Self-Hosted
# http://localhost:8081/artifactory
# used jfrog 7.5.5 and java version "11.0.12" 2021-07-20 LTS
# https://www.youtube.com/watch?v=F-Tb0OFaaKQ

# artifactory base url
# go to install folder and then app->bin->artifactory.bat
# click on localhost http://localhost:8082/artifactory

# https://devopsamiya.jfrog.io/ui/admin/repositories/local/

echo "=================build snapshot Artifacts BEGIN====================="
echo "building Zip files for deployement"
npm run build
echo "=================build snapshot Artifacts END====================="

echo "ARTIFACTORY_LOC : " $ARTIFACTORY_LOC
echo "=================publish snapshot to Artifactory BEGIN====================="
# npm publish --registry $ARTIFACTORY_LOC
# npm config set registry $ARTIFACTORY_LOC
# npm publish
npm publish --registry https://devopsamiya.jfrog.io/artifactory/api/npm/snapshots-npm/
echo "=================publish snapshot to Artifactory END====================="

ls -al

cd target

echo "------------printing target folder files ------------------"
ls -al 

cd ../dist

echo "------------printing dist folder files ------------------"
ls -al 
