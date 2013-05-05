package data;

typedef Subreddit = {
	accounts_active: Int,
	created:Int,
	created_utc:Int,
	description:Null<String>,
	description_html:Null<String>,
	display_name:String,
	header_img:Null<String>,
	header_size:Null<Array<Int>>,
	header_title:Null<String>,
	id:String,
	name:String,
	over18:Bool,
	public_description:String,
	subscribers:Int,
	title:String,
	url:String
}