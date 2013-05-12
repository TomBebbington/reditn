SERVICE_URL=http://closure-compiler.appspot.com/compile
all: code minify plugin install
code:
	haxe build.hxml
plugin: chrome

chrome:
	cp icon.svg plugin/chrome
	cp reditn.min.plugin.js plugin/chrome/reditn.js
minify:
	curl -s --data-urlencode js_code@reditn.user.js -d output_format=text -d output_info=compiled_code -d compilation_level=SIMPLE_OPTIMIZATIONS ${SERVICE_URL} >> oldtemp
	cat info >> temp
	echo " " >> temp
	cat oldtemp >> temp
	mv temp reditn.min.user.js
	curl -s --data-urlencode js_code@reditn.plugin.js -d output_format=text -d output_info=compiled_code -d compilation_level=SIMPLE_OPTIMIZATIONS ${SERVICE_URL} >> oldtemp
	cat info >> temp
	echo " " >> temp
	cat oldtemp >> temp
	mv temp reditn.min.plugin.js
	rm oldtemp
install:
	cp reditn.user.js ~/.mozilla/firefox/*/*scripts/Reditn/150976.user.js