#! /bin/bash
haxe build.hxml
echo " " >> temp
cat info >> temp
cat reditn.js >> temp
mv temp reditn.js
rm temp
cp ./reditn.js ./firefox/content/
zip -r firefox.xpi ./firefox/
cp ./reditn.js ./chrome/
cp ./icon.svg ./chrome/
zip -r chrome.zip ./chrome/
cp ./reditn.js ./opera/includes/
cp ./icon.svg ./opera/
zip -r opera.oex ./opera/