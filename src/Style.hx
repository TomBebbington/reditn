class Style {
	#if !macro
	public static function init() {
		var css = getStyle("src/reditn.css");
		var style = js.Browser.document.createStyleElement();
		style.type = 'text/css';
		if (untyped style.styleSheet){
			untyped style.styleSheet.cssText = css;
		} else {
			style.appendChild(js.Browser.document.createTextNode(css));
		}
		js.Browser.document.head.appendChild(style);
	}
	#end
	macro static function getStyle(file:String) {
		var s = sys.io.File.getContent(file);
		return haxe.macro.Context.makeExpr(s, haxe.macro.Context.currentPos());
	}
}