import js.*;
import js.html.*;
class UserInfo {
	public static inline var offset = 3;
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
		Reditn.popUp(e, div, e.offsetLeft + e.offsetWidth + offset, e.offsetTop);
		Reditn.getJSON('/user/${user}/about.json', function(d:Dynamic){
			if(d.data != null)
				d = d.data;
			var html = '<b>User:</b> ${d.name}<br>';
			var age = Reditn.age(d.created_utc);
			html += '<b>Account age:</b> $age<br>';
			html += '<b>Karma:</b> ${Reditn.formatNumber(d.link_karma)} link karma, ${Reditn.formatNumber(d.comment_karma)} comment karma';
			if(d.is_mod != null && d.is_mod)
				html += "<br><b>Moderator</b>";
			if(d.is_gold != null && d.is_gold)
				html += "<br><b>Gold</b>";
			div.innerHTML = html;
		});
	}
}