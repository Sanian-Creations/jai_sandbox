main :: () {
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
#import "Basic";

/* output

When Base is not polymorphic:
passed a Foo to (b: Base),    type_of(b) is Base
passed a Bar to (b: Base),    type_of(b) is Base
passed a Foo to (b: $T/Base), type_of(b) is Foo
passed a Bar to (b: $T/Base), type_of(b) is Bar

When Base is polymorphic:
passed a Foo to (b: Base),    type_of(b) is Foo
passed a Bar to (b: Base),    type_of(b) is Bar
passed a Foo to (b: $T/Base), type_of(b) is Foo
passed a Bar to (b: $T/Base), type_of(b) is Bar

*/

/*

The last bit should be this:

passed a Foo to (b: Base),    type_of(b) is Base(N=8)
passed a Bar to (b: Base),    type_of(b) is Base(N=8)
passed a Foo to (b: $T/Base), type_of(b) is Foo
passed a Bar to (b: $T/Base), type_of(b) is Bar

But it seems that (b: Base) will behave the same as (b: $T/Base) the moment Base becomes a polymorphic struct.
I'm 99% certain that's a bug because the MEMBER with #as should be passed to the struct, not the whole thing, that should only happen with $T/Foo notation.

*/