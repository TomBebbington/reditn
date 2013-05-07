class Style {
	macro static function getStyle():haxe.macro.Expr.ExprOf<String> {
		return haxe.macro.Context.makeExpr(sys.io.File.getContent("src/reditn-default.css"), haxe.macro.Context.currentPos());
	}
	#if !macro
	public static function init() {
		var s = js.Browser.document.createStyleElement();
		s.innerHTML = getStyle();
		js.Browser.document.head.appendChild(s);
	}
	#end
}