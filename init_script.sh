if[ "origin/$CIRCLE_BRANCH" == "origin/main" ]
            then
              echo RELEASE_VERSION=$TEMP_VAR
              echo NEXT_DEVELOPEMENT_VERSION=$NEXT_DEVELOPEMENT_VERSION
              echo APP_VERSION=$TEMP_VAR >> ${VARIABLE_FILE}
              echo ARTIFACTORY_LOC="$ARTIFACTORY_URL/$ARTIFACTORY_RELEASE/" >> ${VARIABLE_FILE}
              echo ARTIFACTORY_TYPE=$ARTIFACTORY_RELEASE >> ${VARIABLE_FILE}
              echo ARTIFACTORY_LOC="$ARTIFACTORY_URL/$ARTIFACTORY_RELEASE/"
            elif [$CIRCLE_TAG!=null]
            then
              echo "deploying tag: $CIRCLE_TAG"
              echo "APP_VERSION=$VERSION" >> ${VARIABLE_FILE}
              echo "artifactory_type=$ARTIFACTORY_RELEASE" >> ${VARIABLE_FILE}
              echo ARTIFACTORY_TYPE=$ARTIFACTORY_RELEASE >> ${VARIABLE_FILE}
            else
              echo SNAPSHOT_VERSION=$CURRENT_SNAPSHOT_VER
              echo APP_VERSION=$CURRENT_SNAPSHOT_VER >> ${VARIABLE_FILE}
              echo ARTIFACTORY_LOC="$ARTIFACTORY_URL/$ARTIFACTORY_SNAPSHOTS/" >> ${VARIABLE_FILE}
              echo ARTIFACTORY_LOC="$ARTIFACTORY_URL/$ARTIFACTORY_SNAPSHOTS/"
              echo ARTIFACTORY_TYPE=$ARTIFACTORY_SNAPSHOTS >> ${VARIABLE_FILE}
            fi