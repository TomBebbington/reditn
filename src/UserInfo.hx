import js.*;
import js.html.*;
import data.User;
import data.*;
class UserInfo {
	public static function init() {
		var users:Array<Element> = cast Browser.document.body.getElementsByClassName("author");
		for(i in users)
			i.onmouseover = _onMouseOverUser;
	}
	static function _onMouseOverUser(e:Dynamic) {
		var e:Element = e.target;
		var user:String = e.innerHTML;
		user = user.substr(user.lastIndexOf("/")+1);
		var div = Browser.document.createElement("div");
		Reditn.popUp(e, div, e.offsetLeft + e.offsetWidth, e.offsetTop);
		Reditn.getJSON('/user/${user}/about.json', function(i:User){
			var name = i.name, age = Reditn.age(i.created_utc), linkKarma = Reditn.formatNumber(i.link_karma), commentKarma = Reditn.formatNumber(i.comment_karma);
			var html = '<b>User:</b> ${name}<br>';
			html += '<b>Account age:</b> $age<br>';
			html += '<b>Karma:</b> $linkKarma link karma, $commentKarma comment karma';
			if(i.is_mod)
				html += "<br><b>Moderator</b>";
			if(i.is_gold)
				html += "<br><b>Gold</b>";
			div.innerHTML = html;
		});
	}
}