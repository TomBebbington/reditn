import haxe.macro.*;
import sys.*;
import sys.io.*;
class Script {
	public static function generate() {
		File.saveContent("reditn.user.js", File.getContent("info") + "\n" + File.getContent("reditn.user.js"));
	}
}