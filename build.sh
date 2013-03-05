#! /bin/bash
haxe build.hxml
cat info >> temp
cat reditn.js >> temp
mv temp reditn.js
rm temp
cp ./reditn.js ./chrome/
cp ./icon.svg ./chrome/
cd ./chrome
zip -r ../chrome.zip ./*
cd ..
cp ./reditn.js ./opera/includes/
cp ./icon.svg ./opera/
cd ./opera
zip -r ../opera.oex ./*
cd ..