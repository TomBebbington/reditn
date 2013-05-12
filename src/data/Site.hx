package data;

typedef Site = {
	regex:EReg,
	method:EReg -> (Dynamic -> Void) -> Void
}