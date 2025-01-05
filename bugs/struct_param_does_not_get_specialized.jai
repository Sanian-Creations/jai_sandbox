/*
tested:  beta-1-085
type:    unexpected_behaviour
status:  still_present
description:
	When a polymorphic procedure is passed as a struct parameter, it can remain polymorphic even though it should be specialized into a specific procedure by the other struct parameters.
*/

main :: () {
    print_input_type :: (a: $T) {
        print("called f(%)  %!\n", T, ifx T == int then "correct" else "wrong");
    }

    As_Struct :: struct ($T: Type, f: #type (T)) { }
    as_proc   ::        ($T: Type, f: #type (T)) {
        f(cast(u16) 5); // f(s64)
        f(cast(u32) 5); // f(s64)
    }

    as_proc(int, print_input_type);

    foo: As_Struct(int, print_input_type);
    foo.f(cast(u16) 5); // f(u16) ... but should be f(s64)
    foo.f(cast(u32) 5); // f(u32) ... but should be f(s64)
}

#import "Basic";
