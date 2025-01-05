/*
tested:  beta-1-085
type:    should_not_error
status:  still_present
description:
	The compiler thinks a polymorphic struct is a normal struct with no parameters if it is declared inside a polymorphic procedure.
	All arguments to the struct are ignored, using them in the body will error with "undeclared identifier".
*/

poly_proc :: (a: $T) {

	Poly_Struct :: struct(N: int) {
		arr: [N]u8;  // Error: Undeclared identifier 'N'.
	}

	foo: Poly_Struct;
	print("foo: %\n", foo);
}

main :: () {
	poly_proc(1);
}
#import "Basic";
