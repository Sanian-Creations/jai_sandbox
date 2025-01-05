
// Instead of #run in the proc header, pass Code to a struct, insert it,
// and then #run it within the struct when that is being resolved.


RunCode :: struct(arg: $A, code: Code) #type_info_none {
	out :: #run #insert,scope() code;
	// this can actually crash if you do not use 'arg' and ,scope()
	// Because the compiler crashes if you insert code that uses constants that come from a procedure header.
	// see: bug_insert_code_from_procedure_header.jai
}

type_of_a_determines_type_of_b :: (a: $T, b: RunCode(T, #code map_type(arg)).out) {
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
	byte:  u8;
	short: u16;
	str:   string;
	num:   int;
	type_of_a_determines_type_of_b(byte, str);
	type_of_a_determines_type_of_b(short, num);
}

#load "sandbox";
