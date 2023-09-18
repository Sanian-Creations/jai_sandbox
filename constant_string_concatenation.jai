main :: () {
	A :: "Hello, ";
	B :: "Sailor!";

	C :: #run String.join(A, B); // no constant concat with + like in Odin

	print_expr(C);
}

#load "sandbox.jai";
String :: #import "String";