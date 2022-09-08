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
node --version
npm --version
npm install --save-dev

# https://www.jfrog.com/confluence/display/JFROG/QuickStart+Guide%3A+JFrog+Self-Hosted
# http://localhost:8081/artifactory
# used jfrog 7.5.5 and java version "11.0.12" 2021-07-20 LTS
# https://www.youtube.com/watch?v=F-Tb0OFaaKQ

# artifactory base url
# go to install folder and then app->bin->artifactory.bat
# click on localhost http://localhost:8082/artifactory
# https://amiya.devops.com/
# https://amiya.devops.com/artifactory/npm/

# https://devopsamiya.jfrog.io/ui/admin/repositories/local/


# if[$CIRCLE_BRANCH=="main"] 
# then
#     mkdir ~/.ssh && ls -alrt ~/.ssh
#     cat ~/ssh_keys/id_rsa >> ls -alrt ~/.ssh/id_rsa
#     cat ~/ssh_keys/known_hosts >> ls -alrt ~/.ssh/known_hosts
#     chmod 400 ~/.ssh/id_rsa && chmod 400 ~/.ssh/known_hosts
#     ls -alrt ~/.ssh
#     git remote set-url origin $COMPUTED_SSH_URL
#     git checkout main
#     echo "=================build release Artifacts BEGIN====================="
#     npm run release
#     echo "=================build release Artifacts END====================="

#     echo "=================publish release to Artifactory BEGIN====================="
#     npm publish --registry $ARTIFACTORY_LOC
#     echo "=================publish release to Artifactory END====================="

#     echo "=================post release - updating the next snapshot version in package.json====================="
#     rm -f package-lock.json
#     npm version $NEXT_DEVELOPEMENT_VERSION -m "nest developement version $NEXT_DEVELOPEMENT_VERSION updated in package.json"
#     git push --set-upstream origin main
# else 
#     echo "=================build snapshot Artifacts BEGIN====================="
#     echo "building Zip files for deployement"
#     npm run build
#     echo "=================build snapshot Artifacts END====================="

#     echo "=================publish snapshot to Artifactory BEGIN====================="
#     npm publish --registry $ARTIFACTORY_URL
#     echo "=================publish snapshot to Artifactory END====================="
# fi

echo "=================build snapshot Artifacts BEGIN====================="
echo "building Zip files for deployement"
npm run build
echo "=================build snapshot Artifacts END====================="

echo "ARTIFACTORY_LOC : " $ARTIFACTORY_LOC
echo "=================publish snapshot to Artifactory BEGIN====================="
npm publish --registry $ARTIFACTORY_LOC
# npm config set registry $ARTIFACTORY_LOC
# npm publish
echo "=================publish snapshot to Artifactory END====================="

ls -al

cd dist-${MODULE_NAME}

ls -al