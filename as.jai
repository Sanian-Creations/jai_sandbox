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

    proc :: ($huh := true) {

        #if true {
            Base :: struct($N := 8) { name: string; arr: [N]u8; }
            print("\nWhen Base is polymorphic:\n");
        } else {
            // Base :: struct { name: string; }
            // print("\nWhen Base is not polymorphic:\n");
        }

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

    // proc(false);
    // proc(true);
    proc();
    /*
When you pass a struct with a Base member marked '#as'
- In the case that Base is NOT polymorphic:
  b: Base      means it implicitly passses only that member of the struct, so you always get a Base.
  b: $T/Base   means it polymorphs a new proc for that struct and passes you the whole thing
- In the case that Base IS polymorphic:
  b: Base      means it polymorphs a new proc for that struct and passes you the whole thing <- !!!
  b: $T/Base   means it polymorphs a new proc for that struct and passes you the whole thing

To get the behaviour that I expected, I have to do this:
b: Base($N)

...which sort of goes against a statement from 120_polymorphic_structs,
"The way we wrote Holder($T, $N) in do_indices_match is optional. If we want, we can just say Holder"
It is not optional. If we want the bahaviour to stay the same, then it is mandatory.

Of course, the how-to I mentioned does contain an example where this behaviour occurs, 'do_indices_match2',
With the polymorphic struct 'Holder'. However, it only passes in variables of type Holder, and not
types that are derived from Holder with #as, which would show this change in behaviour.
    */
}


main :: () {
    set_print_style_verbose();
    // experiment1();
    experiment2();
}

#load "sandbox.jai";