package data;
typedef Button = {
	function toggled():Bool;
	function toggle(v:Bool):Void;
	var url:String;
	var element:js.html.DivElement;
}