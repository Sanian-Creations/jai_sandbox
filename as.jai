experiment1 :: () {
    Foo :: struct {
        name: string;
        name = "foo";
    }
    Bar :: struct {
        #as using base: Foo;
        base.name = "bar";
        skibidi: int;
    }
    Baz :: struct {
        shalabing: float32;
        base.name = "baz";
        #as using base: Foo;  // this is purposefully not the first member
    }

    take_a_foo :: (foo: Foo) {
        print_expr(foo.name);
    }

    foo: Foo;
    bar: Bar;
    baz: Baz;

    take_a_foo(foo);
    take_a_foo(bar);
    take_a_foo(baz);

    print_expr(#procedure_of_call take_a_foo(foo));
    print_expr(#procedure_of_call take_a_foo(bar));
    print_expr(#procedure_of_call take_a_foo(baz));

    take_a_foolike :: (foo: $T/Foo) {
        print_expr(foo.name);
    }

    take_a_foolike(foo);
    take_a_foolike(bar);
    take_a_foolike(baz);

    print_expr(#procedure_of_call take_a_foolike(foo)); // Notice procs for foo and bar have the same address because the members within them have the same offset
    print_expr(#procedure_of_call take_a_foolike(bar)); // ...meaning their procedures are exactly the same.
    print_expr(#procedure_of_call take_a_foolike(baz)); // baz has its base a t a different offset, so the proc is different.
}

experiment2 :: () {

    // This is a bug, see bug_as_does_not_work_for_polymorphic_structs.jai

    code :: #code {
        Foo :: struct { #as using base: Base; name = "Foo"; }
        Bar :: struct { #as using base: Base; name = "Bar"; }

        base_only    :: (b: Base)    { print("passed a % to (b: Base),    type_of(b) is %\n", b.name, type_of(b)); }
        t_slash_base :: (b: $T/Base) { print("passed a % to (b: $T/Base), type_of(b) is %\n", b.name, type_of(b)); }

        foo: Foo;
        bar: Bar;

        base_only(foo);
        base_only(bar);
        t_slash_base(foo);
        t_slash_base(bar);
    }

    {
        print("\nWhen Base is not polymorphic:\n");
        Base :: struct { name: string; }
        #insert,scope() code;
    } {
        print("\nWhen Base is polymorphic:\n");
        Base :: struct($N := 8) { name: string; }
        #insert,scope() code;
    }
}


main :: () {
    set_print_style_verbose();
    experiment1();
    experiment2();
}

#load "sandbox.jai";