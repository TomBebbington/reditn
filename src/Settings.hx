import js.*;
import js.html.*;
import data.*;
import haxe.ds.StringMap;
import haxe.crypto.BaseCode;
import ext.Storage.*;
import ext.*;
class Settings {
	static inline var NOTE_TEXT = "Close this dialog and refresh the page to see your changes in effect. Changes will be saved automatically.";
	public static var settings:Map<String, Setting<Dynamic>> = [
		"adblock" => { def: true, desc: "Block advertisements and sponsors" },
		"userinfo" => { def: true, desc: "Show information about a user upon hover" },
		"subinfo" => { def: true, desc: "Show information about a subreddit upon hover" },
		"expand" => { def: true, desc: "Allow expansion of articles, images, albums and the like" },
		"text-expand" => { def: true, desc: "Allow expansion of links found in comments and posts" },
		"dup-hider" => { def: true, desc: "Hide duplicates" },
		"user-tag" => { def: true, desc: "Tag users with nicknames" },
		"sub-tag" => { def: true, desc: "Tag subreddits with nicknames" },
		"autoscroll" => { def: true, desc: "Seamless scrolling between pages" },
		"preview" => { def: true, desc: "Preview comments and self posts before they are published" },
		"keyboard" => { def: false, desc: "Keyboard navigation of the links in the page" },
		"nsfw-filter" => { def: false, desc: "Filter NSFW posts" },
		"theme-chooser" => { def: "default", desc: "Select a theme", options: []},
		"user-tags" => { def: new Map<String, String>(), desc: null },
		"sub-tags" => { def: new Map<String, String>(), desc: null }
	];
	public static var data(get, set):Map<String, Dynamic>;
	static inline function get_data() {
		return Storage.data;
	}
	static inline function set_data(d:Map<String, Dynamic>) {
		return Storage.data = d;
	}
	public static function save() {
		Storage.flush();
		ThemeChooser.update();
	}
	public static function init() {
		for(k in settings.keys())
			if(!data.exists(k))
				data[k] = settings[k].def;
		var h = Browser.document.getElementById("header-bottom-right");
		if(h == null)
			return;
		var prefs:Element = cast h.getElementsByTagName("ul")[0];
		var d = Browser.document.createAnchorElement();
		d.innerHTML = "reditn";
		d.className = "pref-lang";
		d.href = "javascript:void(0);";
		d.onclick = function(e) settingsPopUp();
		if(prefs == null)
			h.appendChild(d);
		else
			h.insertBefore(d, prefs);
		var sep = Browser.document.createSpanElement();
		sep.innerHTML = " | ";
		sep.className = "seperator";
		sep.style.fontWeight = "";
		h.insertBefore(sep, prefs);
	}
	static function settingsPopUp() {
		var old = Browser.document.getElementById("reditn-config");
		if(old != null)
			Reditn.remove(old);
		var e = Browser.document.createDivElement();
		e.id = "reditn-config";
		var h = Browser.document.createElement("h1");
		h.innerHTML = "Reditn settings";
		e.appendChild(h);
		Reditn.fullPopUp(e);
		var form = Browser.document.createFormElement();
		form.action = "javascript:void(0);";
		form.onchange = function(ev) {
			var a:Array<Element> = cast form.childNodes;
			for(i in a) {
				if(i.getAttribute("type") == "button")
					continue;
				switch(i.nodeName.toLowerCase()) {
					case "input":
						var i:js.html.InputElement = cast i;
						var val:Dynamic = switch(i.type.toLowerCase()) {
							case "checkbox": i.checked;
							default: i.value;
						}
						data.set(i.name, val);
					case "select":
						var s:js.html.SelectElement = cast i;
						data.set(s.name, untyped s.children[s.selectedIndex].value);
					default: continue;
				}
			}
			save();
		}
		var delb = Browser.document.createInputElement();
		delb.id = "restore";
		delb.type = "button";
		delb.value = "Restore default settings";
		delb.onclick = function(_) {
			if(Browser.window.confirm("Are you sure? This will delete all user tags, subreddit tags and settings!")) {
				for(s in settings.keys())
					data[s] = settings[s].def;
				save();
				settingsPopUp();
			}
		}
		form.appendChild(delb);
		form.appendChild(Browser.document.createBRElement());
		for(k in settings.keys()) {
			var s = settings.get(k);
			var d = data.get(k);
			if(s.desc != null) {
				var label = Browser.document.createLabelElement();
				label.setAttribute("for", k);
				label.innerHTML = s.desc;
				form.appendChild(label);
				var input:Element = null;
				if(s.options == null) {
					var inp = Browser.document.createInputElement();
					input = inp;
					inp.type = if(Std.is(d, Bool))
						"checkbox";
					else if(Std.is(d, String))
						"text";
					else if(Std.is(d, Date))
						"datetime";
					else if(Std.is(d, Int))
						"number";
					else
						"text";
					if(Std.is(d, Bool))
						inp.checked = d;
					else inp.value = d;
				} else {
					var sel = Browser.document.createSelectElement();
					input = sel;
					var i:Int = 0;
					for(o in s.options) {
						if(d == o)
							sel.selectedIndex = i;
						var op = Browser.document.createOptionElement();
						op.textContent = o;
						input.appendChild(op);
						i++;
					}
					sel.value = d;
				}
				input.setAttribute("name", k);
				form.appendChild(input);
				form.appendChild(Browser.document.createBRElement());
			}
		}
		var note = Browser.document.createDivElement();
		note.style.fontWeight = "bold";
		note.innerHTML = NOTE_TEXT;
		form.appendChild(note);
		e.appendChild(form);
	}
}
typedef Setting<T> = {
	var desc:String;
	var def:T;
	@:optional var options:Array<T>;
}