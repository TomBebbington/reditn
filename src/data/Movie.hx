package data;
typedef Movie = {
	title: String,
	year: String,
	?certificate: String,
	?released: String,
	?length: String,
	roles: Map<String, Array<String>>,
	?plot: String,
	images: Album
}