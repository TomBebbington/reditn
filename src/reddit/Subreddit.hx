package reddit;
/**
	Represents a subreddit.
**/
class Subreddit extends Data {
	/** The name of this subreddit **/
	public var name(default, null):String;
	/** The display name of this subreddit **/
	public var displayName(get, never):String;
	/** The number of subscribers **/
	public var subscribers(get, never):Int;
	/** The number of active users **/
	public var accountsActive(get, never):Int;
	/** When the subreddit was created **/
	public var created(get, never):Date;
	/** If it is intended for a mature audience **/
	public var over18(get, never):Bool;
	/** The description **/
	public var description(get, never):String;
	/** If the current user is subscribed **/
	public var subscribed(get, never):Bool;
	public static function get(name:String):Null<Subreddit>
		return try new Subreddit(name) catch(e:Dynamic) null;
	inline function get_displayName():String
		return data.display_name;
	inline function get_subscribers():Int
		return data.subscribers;
	inline function get_accountsActive():Int
		return data.accounts_active;
	inline function get_created():Date
		return Date.fromTime(data.created_utc * 1000);
	inline function get_over18():Bool
		return data.over18;
	inline function get_description():String
		return data.description;
	inline function get_subscribed():Bool
		return data.user_is_subscriber;
	public function new(n:String):Void
		this.name = StringTools.urlEncode(n);
	override function getDataUrl():String
		return 'http://www.reddit.com/r/$name/about.json';
	public function getPosts(sort:String="hot"):Array<Post>
		try
			return haxe.Json.parse(haxe.Http.requestUrl('http://www.reddit.com/r/$name/$sort.json')).data.children
		catch(e:Dynamic)
			return [];
	public inline function toString():String
		return '/r/$name: $displayName: $description';
}