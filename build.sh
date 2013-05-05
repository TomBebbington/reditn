
SERVICE_URL=http://closure-compiler.appspot.com/compile
NEWFILE="reditn.js"
#! /bin/bash
haxe build.hxml
cat info >> temp
cat reditn.js >> temp
mv temp reditn.js

# Check if files to compile are provided
code="--data-urlencode js_code@reditn.js"
curl \
--url ${SERVICE_URL} \
--header 'Content-type: application/x-www-form-urlencoded' \
${code} \
--data output_format=text \
--data output_info=compiled_code \
--data compilation_level=SIMPLE_OPTIMIZATIONS \
-o reditn.min.js
cat info >> temp
echo " " >> temp
cat reditn.min.js >> temp
rm reditn.min.js
mv temp reditn.min.js

cp ./reditn.js ./firefox/content/
zip -r firefox.xpi ./firefox/
cp ./reditn.js ./chrome/
cp ./icon.svg ./chrome/
zip -r chrome.zip ./chrome/
cp ./reditn.js ./opera/includes/
cp ./icon.svg ./opera/
zip -r opera.oex ./opera/