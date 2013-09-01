import flash.display.Sprite;
import ru.stablex.ui.UIBuilder;
import ru.stablex.ui.widgets.*;
import ru.stablex.ui.skins.*;
import flash.Lib.current;
import flash.Lib;
import flash.net.URLRequest;
import flash.events.*;
import reddit.*;
class Reditn {
	public static var title:Text;
	public static var posts:VBox;
	public static function main() {
		UIBuilder.init("ui/defaults.xml");
		UIBuilder.buildFn("ui/main.xml")().show();
		title = cast UIBuilder.get("title");
		title.label.multiline = false;
		title.addEventListener(KeyboardEvent.KEY_UP, function(e:KeyboardEvent) {
			if(e.keyCode == 13)
				browse(new Subreddit(title.text));
		});
		posts = cast UIBuilder.get("posts");
		browse(new Subreddit("funny"));
	}
	static function browse(s:Subreddit):Void {
		title.text = '${s.displayName}';
		posts.freeChildren(false);
		for(p in s.getPosts()) {
			var text = UIBuilder.create(Text, {
				text: p.title,
				left: 0,
				defaults: "PostTitle"
			});
			var score = UIBuilder.create(Text, {
				text: Std.string(p.score),
				defaults: "PostScore"
			});
			var post = UIBuilder.create(HBox, {
				children: [
					text,
					score
				],
				defaults: "Post"
			});
			post.addEventListener(flash.events.MouseEvent.CLICK, function(_) {
				Lib.getURL(new URLRequest(p.url));
			});
			posts.addChild(post);
		}
	}
}