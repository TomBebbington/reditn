package data.imgur;

typedef Album = {
	id:String,
	title:String,
	description:String,
	datetime:Int,
	cover:String,
	account_url:Null<String>,
	privacy:String,
	layout:String,
	views:Int,
	link:String,
	images_count:Int,
	images:Array<Image>
}