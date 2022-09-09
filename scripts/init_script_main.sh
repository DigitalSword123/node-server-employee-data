echo $(pwd)
ls -al
ARTIFACTORY_URL="https://devopsamiya.jfrog.io/artifactory/api/npm"
ARTIFACTORY_BASE_URL="https://devopsamiya.jfrog.io/artifactory"
ARTIFACTORY_RELEASE="releases-npm"
ARTIFACTORY_SNAPSHOTS="snapshots-npm"
touch ${VARIABLE_FILE}
echo "export ARTIFACT_ID=$(jq -r .name package.json)" >> ${VARIABLE_FILE}
VERSION=$(jq -r .version package.json) 
now=`date +'%Y%m%d%H%M'`
echo "export CURRENT_SNAPSHOT_VER='$VERSION.$now'" >> ${VARIABLE_FILE}
CURRENT_SNAPSHOT_VER="$VERSION.$now"
echo "export RELEASE_VERSION=$(sed 's/-SNAPSHOT//' <<<$(jq -r .version package.json))" >> ${VARIABLE_FILE}
TEMP_VAR=$(sed 's/-SNAPSHOT//' <<<$(jq -r .version package.json))
pip install --upgrade pip
pip install semver # https://python-semver.readthedocs.io/en/2.9.0/index.html
echo NEXT_DEVELOPEMENT_VERSION="$(pysemver bump patch $TEMP_VAR)-SNAPSHOT"
REP_URL=$(jq -r .repository.url package.json)
STRIPPED_URL=$(echo $REP_URL | sed 's~.*github.com/~~')
COMPUTED_SSH_URL=git@github.com:$STRIPPED_URL
echo "export COMPUTED_SSH_URL=git@github.com:$STRIPPED_URL" >> ${VARIABLE_FILE}
echo HTTPS_URL=$(jq -r .repository.http_url package.json)
echo COMPUTED_SSH_URL=git@github.com:$STRIPPED_URL
git --version
echo "************prtining branch*************"
git branch -r


echo RELEASE_VERSION=$TEMP_VAR
echo NEXT_DEVELOPEMENT_VERSION=$NEXT_DEVELOPEMENT_VERSION
echo APP_VERSION=$TEMP_VAR >> ${VARIABLE_FILE}
echo "export ARTIFACTORY_LOC=$ARTIFACTORY_URL/$ARTIFACTORY_RELEASE/" >> ${VARIABLE_FILE}
echo "export ARTIFACTORY_TYPE=$ARTIFACTORY_RELEASE" >> ${VARIABLE_FILE}
echo ARTIFACTORY_LOC="$ARTIFACTORY_URL/$ARTIFACTORY_RELEASE/"


ls -al
echo "******************reading VARIABLE_FILE start*****************"
cat ${VARIABLE_FILE}
echo "******************reading VARIABLE_FILE end*****************"