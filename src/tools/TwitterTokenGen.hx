package tools;
import haxe.Http;
import haxe.crypto.BaseCode;
using StringTools;
class TwitterTokenGen {
	static inline var BASE_64 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
	static inline var CONSUMER_KEY = "FxcC5YzvpZVGXZ3WOebZg";
	static function main() {
		Sys.println("Please enter the consumer secret:");
		var secret = Sys.stdin().readLine().urlEncode(), key = CONSUMER_KEY.urlEncode();
		var credentials = '${secret}:${key}';
		var crenc = BaseCode.encode(credentials, BASE_64);
		crenc += switch(crenc.length % 4) {
			case 2: "==";
			case 3:  "=";
			default: "";
		};
		Sys.println(crenc);
	}
}