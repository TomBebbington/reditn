var data = require("self").data;
var pageMod = require("page-mod");
pageMod.PageMod({
	include: ["*.reddit.com"],
	contentScriptWhen: 'ready',
	contentScriptFile: data.url("reditn.js")
});