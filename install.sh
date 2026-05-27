#!/bin/bash
if [ -d "flutter" ]; then
  cd flutter && git fetch --depth 1 origin stable && git reset --hard FETCH_HEAD && cd ..
else
  git clone https://github.com/flutter/flutter.git --branch stable --depth 1
fi
flutter/bin/flutter doctor
flutter/bin/flutter clean
flutter/bin/flutter config --enable-web
