#!/bin/bash

npm install

cd functions; npm install

if [[ -z "${FIREBASE_TOKEN}" && -z "${GOOGLE_APPLICATION_CREDENTIALS}" ]]; then
    echo "Access tokens are missing! Provide either FIREBASE_TOKEN or GOOGLE_APPLICATION_CREDENTIALS"
    exit 1
fi

if [ -z "${FIREBASE_PROJECT}" ]; then
    echo "FIREBASE_PROJECT is missing"
    exit 1
fi

cd ..

firebase experiments:enable webframeworks

if [ -n "${FUNCTIONS_SEGMENT}" ]; then
    echo "Deploying functions in segment: ${FUNCTIONS_SEGMENT}" 
    firebase deploy \
        -m "${GITHUB_REF} (${GITHUB_SHA})" \
        --project ${FIREBASE_PROJECT} \
        --only functions:${FUNCTIONS_SEGMENT}
else
    echo "Deploying all functions"
    firebase deploy \
        -m "${GITHUB_REF} (${GITHUB_SHA})" \
        --project ${FIREBASE_PROJECT} \
        ${FUNCTIONS_ONLY:+--only functions}
fi
