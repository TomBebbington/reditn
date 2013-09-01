package reddit;
import haxe.Http;
import haxe.Json;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.events.ProgressEvent;
class Data {
	function getDataUrl():String
		return null;
	@:isVar var data(get, null):Dynamic;
	inline function get_data():Dynamic {
		return if(this.data != null)
			data;
		else {
			Json.parse(Http.requestUrl(getDataUrl())).data;
		}
	}
}