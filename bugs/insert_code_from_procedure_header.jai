/*
tested:  beta-1-085
type:    compiler_terminates
status:  still_present
description:
	Attempting to run code that is scoped to a procedure header will crash the compiler.
*/

// This struct is a dirty workaround to be able to use #run inside of a procedure header.
RunCode :: struct(code: Code) {
	out :: #run #insert code;
}

type_of_a_determines_type_of_b :: (a: $T, b: RunCode(#code map_type(T)).out) {
	print("type_of(a) is %, type_of(b) is %\n", type_of(a), type_of(b));
}

map_type :: (a: Type) -> Type {
	if a == {
		case u8;  return string;
		case u16; return int;
		case;     return void;
	}
}

main :: () {
	byte: u8;
	str: string;
	type_of_a_determines_type_of_b(byte, str); // the program will even crash without calling this.
}

#import "Basic";
