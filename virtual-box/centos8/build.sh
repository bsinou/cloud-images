#!/bin/bash -x

SECONDS=0

# DEFAULT PARAMETERS
baseTemplate=centos8-minimal.json
artifactName=centos8

# DEFAULT PATHS
initialPath=$PWD
basePath=$(dirname "$initialPath")

echo -n "... Build started at "; date

workingFolder=$basePath/exec
cacheFolder=$workingFolder/cache
buildFolder=$workingFolder/build-centos8
targetFolder=$buildFolder/$artifactName
imageFolder=$workingFolder/images
logPath=$buildFolder/build.log

rm -rf $buildFolder $imageFolder/$artifactName.ova

mkdir -p $cacheFolder $buildFolder $imageFolder
cp -r $initialPath/http $buildFolder
cp -r $initialPath/init $buildFolder

export PACKER_CACHE_DIR=$cacheFolder
export PACKER_CACHE=$cacheFolder

template=$initialPath/$baseTemplate
echo "... Launching Packer build for template: $template"
cd $buildFolder

PACKER_LOG=1 PACKER_LOG_PATH="${logPath}" packer build $template
packer build $template

cp $targetFolder/$artifactName.ova $imageFolder

duration=$SECONDS
formattedDur="$(($duration / 60))mn $(($duration % 60))s"

echo -n "... Build done in $formattedDur, terminated at "; date
echo "... You will find the newly created appliance in $imageFolder"; echo
