/*
tested:  beta-1-086
bug:     compiler_terminates
status:  still_present
description:
	Comparing a string initializer `string.{}` to a string literal `""` crashes the compiler.
*/

#assert string.{} == ""; // crashes, should assert true
#assert "" == string.{}; // asserts false, should assert true

main :: () {
	equal  := "" == string.{};
	equal2 := string.{} == "";
	assert(equal);
	assert(equal2);
}

#import "Basic";