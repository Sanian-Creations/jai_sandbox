main :: () {

    Foo :: struct { v: int; }

    operator + :: (f1: Foo, f2: Foo) -> Foo {
        return .{f1.v + f2.v};
    }

    {
        add :: operator +; // this works.
        f1 := Foo.{1} + Foo.{2};
        f2 := add(Foo.{1}, Foo.{2});
        print("%\n", f1);
        print("%\n", f2);
    }

    #insert #run code_as_string(#code add :: operator +); // this should print 'add :: operator +;' but instead it prints 'add :: +;'

    f1 := Foo.{1} + Foo.{2};
    f2 := add(Foo.{1}, Foo.{2});
    print("%\n", f1);
    print("%\n", f2);
}

code_as_string :: ($code: Code) -> string {
    sb: String_Builder;
    print_expression(*sb, compiler_get_nodes(code));
    append(*sb, ";");
    return builder_to_string(*sb);
}

#import "Compiler";
#import "Program_Print";
#import "Basic";