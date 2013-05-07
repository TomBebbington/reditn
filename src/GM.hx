@:expose class GM {
	public static function request(data:Dynamic):Void {
		untyped GM_xmlhttpRequest(data);
	}
}