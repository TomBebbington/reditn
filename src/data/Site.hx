package data;

typedef Site = {
	type:LinkType,
	regex:EReg,
	method:EReg -> (Dynamic -> Void) -> Void
}