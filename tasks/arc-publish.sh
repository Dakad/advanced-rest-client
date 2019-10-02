if [ $TRAVIS_BRANCH != 'develop' ] && [ $TRAVIS_BRANCH != 'master' ] && [ $TRAVIS_BRANCH != 'beta' ]; then
  echo "Skipping ARC build. Incompatible branch."
  exit 0
fi

export CSC_NAME="Pawel Psztyc"
export WIN_CSC_LINK="$(pwd)/tasks/advancedrestclient.pfx"
export CSC_LINK="$(pwd)/tasks/mac-app-distribution-cert.p12"

# echo "Decrypring Window key into: $WIN_CSC_LINK"
# openssl aes-256-cbc -K "$encrypted_c7c10d38055a_key" -iv "$encrypted_c7c10d38055a_iv" -in tasks/advancedrestclient.pfx.enc -out "$WIN_CSC_LINK" -d
# if [ ! -f "$WIN_CSC_LINK" ]; then
#   echo "Error decoding Windows key."
#   exit -1
# fi

# echo "Decrypring Mac key into: $CSC_LINK"
# openssl aes-256-cbc -K "$encrypted_c7c10d38055a_key" -iv "$encrypted_c7c10d38055a_iv" -in tasks/mac-app-distribution-cert.p12.enc -out "$CSC_LINK" -d
# if [ ! -f "$CSC_LINK" ]; then
#   echo "Error decoding Mac key."
#   exit -1
# fi

if [ "$TRAVIS_OS_NAME" == "linux" ]; then
  docker run --rm \
    --env-file <(env | grep -iE 'DEBUG|NODE_|ELECTRON_|YARN_|NPM_|CI|CIRCLE|TRAVIS|APPVEYOR_|CSC_|_TOKEN|_KEY|AWS_|STRIP|BUILD_') \
    -v ${PWD}:/project \
    -v ~/.cache/electron:/root/.cache/electron \
    -v ~/.cache/electron-builder:/root/.cache/electron-builder \
    electronuserland/builder:wine \
    /bin/bash -c "./node_modules/.bin/electron-builder --linux --win"
else
  /bin/bash -c "./node_modules/.bin/electron-builder --mac"
fi
