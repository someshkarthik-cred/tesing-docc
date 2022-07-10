#!/bin/bash

set -x
set -e

BUILd_FOLDER="Build"

rm -rf $BUILd_FOLDER

# Pass scheme name as the first argument to the script
NAME=$1
OUTPUT_FILE=$2

# Build the scheme for all platforms that we plan to support
for PLATFORM in "iOS" "iOS Simulator"; do

    case $PLATFORM in
    "iOS")
    RELEASE_FOLDER="$BUILd_FOLDER/Release-iphoneos"
    ;;
    "iOS Simulator")
    RELEASE_FOLDER="$BUILd_FOLDER/Release-iphonesimulator"
    ;;
    esac

    ARCHIVE_PATH=$RELEASE_FOLDER

    # Rewrite Package.swift so that it declaras dynamic libraries, since the approach does not work with static libraries
    perl -i -p0e 's/type: .static,//g' Package.swift
    perl -i -p0e 's/type: .dynamic,//g' Package.swift
    perl -i -p0e 's/(library[^,]*,)/$1 type: .dynamic,/g' Package.swift

    xcodebuild archive -scheme $NAME \
            -destination "generic/platform=$PLATFORM" \
            -archivePath $ARCHIVE_PATH \
            -derivedDataPath ".build" \
            SKIP_INSTALL=NO BUILD_LIBRARY_FOR_DISTRIBUTION=YES

    FRAMEWORK_PATH="$ARCHIVE_PATH.xcarchive/Products/usr/local/lib/$NAME.framework"
    MODULES_PATH="$FRAMEWORK_PATH/Modules"
    mkdir -p $MODULES_PATH

    BUILD_PRODUCTS_PATH=".build/Build/Intermediates.noindex/ArchiveIntermediates/$NAME/BuildProductsPath"
    RELEASE_PATH="$BUILD_PRODUCTS_PATH/$RELEASE_FOLDER"
    SWIFT_MODULE_PATH="$RELEASE_PATH/$NAME.swiftmodule"
    RESOURCES_BUNDLE_PATH="$RELEASE_PATH/${NAME}_${NAME}.bundle"

    # Copy Swift modules
    if [ -d $SWIFT_MODULE_PATH ] 
    then
        cp -r $SWIFT_MODULE_PATH $MODULES_PATH
    else
        # In case there are no modules, assume C/ObjC library and create module map
        echo "module $NAME { export * }" > $MODULES_PATH/module.modulemap
        # TODO: Copy headers
    fi

    # Copy resources bundle, if exists 
    if [ -e $RESOURCES_BUNDLE_PATH ] 
    then
        cp -r $RESOURCES_BUNDLE_PATH $FRAMEWORK_PATH
    fi

done

XC_FRAMEWORK=$BUILd_FOLDER/$NAME.xcframework

xcodebuild -create-xcframework \
-framework $BUILd_FOLDER/Release-iphoneos.xcarchive/Products/usr/local/lib/$NAME.framework \
-framework $BUILd_FOLDER/Release-iphonesimulator.xcarchive/Products/usr/local/lib/$NAME.framework \
-output $XC_FRAMEWORK

zip -r $XC_FRAMEWORK.zip $XC_FRAMEWORK

rm -rf $XC_FRAMEWORK

echo $XC_FRAMEWORK.zip > $OUTPUT_FILE
