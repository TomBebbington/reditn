import js.*;
import js.html.*;
class UserInfo {
	public static inline var offset = 3;
	public static function init() {
		var users = Browser.document.body.getElementsByClassName("author");
		for(i in 0...users.length)
			untyped users[i].onmouseover = _onMouseOverUser;
	}
	static function _onMouseOverUser(e:Dynamic) {
		var user:String = e.href;
		user = user.substr(user.lastIndexOf("/")+1);
		var div = Browser.document.createElement("div");
		Reditn.popUp(e.target, div, e.offsetLeft + e.offsetWidth + offset, e.offsetTop);
		Reditn.getJSON("/user/"+user+"/about.json", function(d:Dynamic){
			d = d.data;
			var html = "<b>User:</b> "+d.name+"<br>";
			var diff = Date.fromTime(haxe.Timer.stamp() - d.created_utc*1000);
			var years = diff.getFullYear()-1970, months = diff.getMonth(), days = diff.getDate();
			html += "<b>Account age:</b> ";
			if(years > 0) html += years+" years, ";
			if(months > 0) html+=months+" months, ";
			html += days+" days<br>";
			html += "<b>Karma:</b> "+d.link_karma+" link karma, "+d.comment_karma+" comment karma";
			if(d.is_mod)
				html += "<br><b>Moderator</b>";
			if(d.is_gold)
				html += "<br><b>Gold</b>";
			div.innerHTML = html;
		});
	}
}