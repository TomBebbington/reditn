class Style {
	macro static function getStyle():haxe.macro.Expr.ExprOf<String> {
		return haxe.macro.Context.makeExpr(sys.io.File.getContent("src/reditn-default.css"), haxe.macro.Context.currentPos());
	}
	#if !macro
	public static function init() {
		var s = ext.Browser.document.createStyleElement();
		s.innerHTML = getStyle();
		ext.Browser.document.head.appendChild(s);
	}
	#end
}