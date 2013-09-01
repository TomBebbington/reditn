package reddit;

class Listing extends Data {
	public inline function children():Array<Post>
		return cast data.children;
}