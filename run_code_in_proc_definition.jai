
// This is a workaround for not being able to use #run in proc headers, so the crash is somewhat expected.

// Instead of #run in the proc header, pass Code to a struct, insert it,
// and then #run it within the struct when that is being resolved.



RunCode :: struct(arg: $A, code: Code, Out := Type) #type_info_none {
    out :: #run -> Out { return #insert,scope() code; }
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

#import "Basic";

// There is a way to make this work, actually, by inserting the Code using a scope other than the proc header.
// With this, T just has to be passed into the struct, and the Code can use it under the name 'arg'.
RunCode2 :: struct(arg: $A, code: Code, Out := Type) {
	out :: #run -> Out { #insert,scope() code; }
}

// type_of_a_determines_type_of_b :: (a: $T, b: #run -> Type {
// 	if T == {
// 		case u8;  return string;
// 		case u16; return int;
// 		case;     return void;
// 	}
// }) {
// 	print_expr(type_of(b));
// }



// type_of_a_determines_type_of_b_2 :: (a: $T, b: RunCode2(T, code=#code{
// 	if arg1 == {
// 		case u8;  return string;
// 		case u16; return int;
// 		case;     return void;
// 	}
// }).out) {
// 	print_expr(type_of(b));
// }

// Invalid_Type :: #type,distinct void;
// VOID :: #run null.*;

// RunCode2 :: struct(
// 	arg1: $T_arg1 = VOID,
// 	arg2: $T_arg2 = VOID,
// 	Out := Type, code: Code
// ) {
// 	out :: #run -> Out {
// 		#insert,scope() code;
// 	}
// }

// map_type :: ($T_in: Type) -> $T_out {
// 	#if      T_in == u8  then T_out :: string;
// 	else #if T_in == u16 then T_out :: int;
// 	else #if T_in == u32 then T_out :: * [2] u8;
// 	else #if T_in == u64 then T_out :: [] * float;
// 	else                      T_out :: void;
// 	t: T_out;
// 	return t;
// }


// #load "sandbox.jai";
