var data = require("self").data;
var pageMod = require("page-mod");
var storage = require("sdk/simple-storage").storage;
pageMod.PageMod({
	include: ["*.reddit.com"],
	contentScriptWhen: 'ready',
	contentScriptFile: data.url("reditn.js"),
	onAttach: function(worker){
		console.log(storage);
		worket.port.emit("dataLoad", storage);
		worker.port.on("saveData", function(data) {
			for(f in data) storage[f] = data[f];
		});
	}
});