main :: () {

    Foo :: struct { v: int; }
    operator + :: (f1: Foo, f2: Foo) -> Foo { return .{0}; }

    { add :: operator +; }

    #insert #run code_as_string(#code add :: operator +);

    f1 := Foo.{} + Foo.{};
    f2 := add(Foo.{}, Foo.{});
}

code_as_string :: ($code: Code) -> string {
    // converts Code to Code_Node then back to string.
    #import "Compiler";
    #import "Program_Print";
    return #run -> string {
        sb: String_Builder;
        print_expression(*sb, compiler_get_nodes(code));
        append(*sb, ";");
        return builder_to_string(*sb);
    };
}

#import "Basic";