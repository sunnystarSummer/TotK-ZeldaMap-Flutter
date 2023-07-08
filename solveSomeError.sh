#!/bin/sh
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
flutter upgrade
flutter clean
flutter pub get
flutter pub upgrade --major-versions
cd $SCRIPT_DIR/android && ./gradlew clean
cd $SCRIPT_DIR/ios && pod deintegrate
cd $SCRIPT_DIR/ios && rm -rf Pods Podfile.lock
flutter packages get
cd $SCRIPT_DIR/ios && pod install  --repo-update
