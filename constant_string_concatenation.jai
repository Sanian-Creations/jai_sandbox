main :: () {
	A :: "Hello, ";
	B :: "Sailor!";

	C :: #run String.join(A, B); // no constant concat with + like in Odin

	printex(C);
}

#load "sandbox.jai";
String :: #import "String";