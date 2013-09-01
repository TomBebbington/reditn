package reddit;

abstract Post(Dynamic) {
	public var author(get, never):String;
	public var score(get, never):Int;
	public var title(get, never):String;
	public var url(get, never):String;
	inline function get_author():String
		return this.data.author;
	inline function get_score():Int
		return this.data.score;
	inline function get_title():String
		return this.data.title;
	inline function get_url():String
		return this.data.url;
	public inline function toString():String
		return haxe.Json.stringify(this.data);
}