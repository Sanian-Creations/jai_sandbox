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
    type_of_a_determines_type_of_b(byte, str);
}

#import "Basic";