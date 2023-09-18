Foo :: struct {
	a := 1;
	b := 4.5;
	bar : Bar;
	// ptr1: *Foo;
	// ptr2: *Foo;
}

Bar :: struct {
	a: int = 69;
};

main :: () {
	set_print_style_verbose();

	{ f: Foo; // uses default values defined in the struct
	print("default: %\n", f); }

	{ f: Foo = ---; // uses uninitialized memory (which is not zero)
	print("uninitialized: %\n", f); }
	// if a struct contains uninitialized strings, it will try print the string but crash because the data ptr points to some random place. Don't do that!

	{ f := Foo.{a = 5, bar.a = 420 }; // uses default values but overwrites a.
	// note you can access bar.a in the struct literal, noice! also works with arrays.
	print("overridden: %\n", f); }

	{ f: Foo = ---;
	zero(*f);
	print("zero'd: %\n", f); }
}

zero :: (mem_ptr: *$T) #expand {
 	memset(mem_ptr, 0, size_of(T));
}

#load "sandbox.jai";