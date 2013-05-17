package data;
typedef Button = {
	function toggled():Bool;
	function toggle(v:Bool, ps:Bool):Void;
	var url:String;
	var element:js.html.DivElement;
}