echo $(pwd)
ls - al
ARTIFACTORY_URL = "https://devopsamiya.jfrog.io/artifactory/api/npm"
ARTIFACTORY_BASE_URL = "https://devopsamiya.jfrog.io/artifactory"
ARTIFACTORY_RELEASE = "releases-npm"
ARTIFACTORY_SNAPSHOTS = "snapshots-npm"
mkdir - p workspace
touch ${VARIABLE_FILE}
echo ARTIFACT_ID = $(jq - r.name package.json) >> ${VARIABLE_FILE}
VERSION = $(jq - r.version package.json)
now = `date +'%Y%m%d%h%M'`
echo CURRENT_SNAPSHOT_VER = "VERSION.$now" >> ${VARIABLE_FILE}
CURRENT_SNAPSHOT_VER = "$VERSION.$now"
echo RELEASE_VERSION = $(sed 's/-SNAPSHOT//' <<<$(jq - r.version package.json)) >> ${VARIABLE_FILE}
TEMP_VAR = $(sed 's/-SNAPSHOT//' <<<$(jq - r.version package.json))
pip install--upgrade pip
pip install semver# https: //python-semver.readthedocs.io/en/2.9.0/index.html
    echo NEXT_DEVELOPEMENT_VERSION = "$(pysemver bump patch $TEMP_VAR)-SNAPSHOT"
REP_URL = $(jq - r.repository.url package.json)
STRIPPED_URL = $(echo $REP_URL | sed 's~.*github.com/~~')
COMPUTED_SSH_URL = git @github.com: $STRIPPED_URL
echo COMPUTED_SSH_URL = git @github.com: $STRIPPED_URL >> ${VARIABLE_FILE}
echo HTTPS_URL = $(jq - r.repository.http_url package.json)
echo COMPUTED_SSH_URL = git @github.com: $STRIPPED_URL
git--version
git branch - r
echo SNAPSHOT_VERSION = $CURRENT_SNAPSHOT_VER
echo APP_VERSION = $CURRENT_SNAPSHOT_VER >> ${VARIABLE_FILE}
echo ARTIFACTORY_LOC = "$ARTIFACTORY_URL/$ARTIFACTORY_SNAPSHOTS/" >> ${VARIABLE_FILE}
echo ARTIFACTORY_LOC = "$ARTIFACTORY_URL/$ARTIFACTORY_SNAPSHOTS/"
echo ARTIFACTORY_TYPE = $ARTIFACTORY_SNAPSHOTS >> ${VARIABLE_FILE}

ls - al

echo "******************reading VARIABLE_FILE start*****************"
cat ${VARIABLE_FILE}
echo "******************reading VARIABLE_FILE end*****************"