main :: () {
    My_Int :: int;
    decl :: #code inserted: My_Int = 69105;
    do_insertion(decl);
}

do_insertion :: ($c: Code) {
    #insert c;  // Works fine
    print("in proc, inserted = %\n", inserted);

    Foo :: struct { #insert c; }  // Undeclared identifier 'My_Int'
    foo: Foo;
    print("in struct, foo.inserted = %\n", foo.inserted);
}

#import "Basic";
