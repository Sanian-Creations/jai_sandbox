main :: () {

	A :: "Hello, ";
	B :: "Sailor";
	print_expr(#run join(A, B));

	// program print fails because body_or_null is null and there's no check for it.
	// Also, 'flags' on the Code Procedure Header is 40 (decimal), which is 0x8 and 0x20, but 0x20 isn't part of the flags enum,
	// so it's a flag that's in the compiler but not in Program_Print.
}
#import "String";
#load "sandbox.jai";
