/*
tested:  beta-1-085
type:    should_not_error
status:  fixed
description:
	When inserting code inside a struct body, it cannot resolve symbols from the scope where the code came from.
*/

main :: () {
	My_Int :: int;
	decl :: #code inserted: My_Int = 69105;
	do_insertion(decl);
}

do_insertion :: ($c: Code) {
	#insert c;  // Works fine
	print("in proc, inserted = %\n", inserted);

	Foo :: struct { #insert c; }  // Undeclared identifier 'My_Int' FIXED: this works now.
	foo: Foo;
	print("in struct, foo.inserted = %\n", foo.inserted);
}

#import "Basic";
