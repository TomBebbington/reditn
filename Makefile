SERVICE_URL=http://closure-compiler.appspot.com/compile
all: build chrome opera
clean:
	rm reditn.*.js
build:
	haxe build.hxml
plugin: chrome

chrome: build
	cp icon128.png plugin/chrome/icon.png
	cp reditn.plugin.js plugin/chrome/reditn.js
	zip -r plugin/chrome.zip plugin/chrome
opera: build
	cp icon128.png plugin/opera/icons/icon.png
	cp reditn.user.js plugin/opera/includes/reditn.user.js
	cd plugin/opera && zip -r ../opera.oex .
chrome-full: chrome
	chromium-browser --pack-extension=plugin/chrome --pack-extension-key=plugin/chrome.pem
minify: build
	curl -s --data-urlencode js_code@reditn.user.js -d output_format=text -d output_info=compiled_code -d compilation_level=SIMPLE_OPTIMIZATIONS ${SERVICE_URL} >> oldtemp
	cat info >> temp
	echo " " >> temp
	cat oldtemp >> temp
	mv temp reditn.min.user.js
	rm oldtemp
minify-plugin: build
	curl -s --data-urlencode js_code@reditn.plugin.js -d output_format=text -d output_info=compiled_code -d compilation_level=SIMPLE_OPTIMIZATIONS ${SERVICE_URL} >> reditn.min.plugin.js
install-firefox:
	cp reditn.user.js ~/.mozilla/firefox/*/*scripts/Reditn/150976.user.js