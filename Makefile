SERVICE_URL=http://closure-compiler.appspot.com/compile
all: build minify minify-plugin plugin install
build:
	haxe build.hxml
plugin: chrome

chrome:
	cp icon128.png plugin/chrome/icon.png
	cp reditn.min.plugin.js plugin/chrome/reditn.js
chrome-full: chrome
	chromium-browser --pack-extension=plugin/chrome --pack-extension-key=plugin/chrome.pem
minify:
	curl -s --data-urlencode js_code@reditn.user.js -d output_format=text -d output_info=compiled_code -d compilation_level=SIMPLE_OPTIMIZATIONS ${SERVICE_URL} >> oldtemp
	cat info >> temp
	echo " " >> temp
	cat oldtemp >> temp
	mv temp reditn.min.user.js
	rm oldtemp
minify-plugin:
	rm reditn.min.plugin.js
	curl -s --data-urlencode js_code@reditn.user.js -d output_format=text -d output_info=compiled_code -d compilation_level=SIMPLE_OPTIMIZATIONS ${SERVICE_URL} >> reditn.min.plugin.js
install:
	cp reditn.min.user.js ~/.mozilla/firefox/*/*scripts/Reditn/150976.user.js