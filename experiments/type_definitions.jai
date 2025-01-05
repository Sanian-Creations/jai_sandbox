main :: () {
	{
		// It is only a new type if the right hand side is a type-literal.
		Foo :: struct {} // new type (named struct Foo)
		Bar :: struct {} // new type (named struct Bar)
		Baz :: Foo;      // no new type (Baz is assigned 'named struct Foo', you can use #type,distinct if you want to create a new type)

		// Kinda counterintuitive if you look at this
		#assert Foo != struct {}; // named struct Foo != anonymous struct
		#assert Foo != Bar;       // named struct Foo != named struct Bar
		#assert Foo == Baz;       // named struct Foo == named struct Foo
	} {
		// In any other case all these constants should be equal
		Foo :: "something";
		Bar :: "something";
		Baz :: Foo;
		#assert Foo == "something";
		#assert Foo == Bar;
		#assert Foo == Baz;
	}

	test ::($T: Type) {
		// Luckily the exception is only for type-literals. As long as you're working with identifiers it all works as expected.
		Foo :: T;
		Bar :: T;
		Baz :: Foo;
		#assert Foo == T;
		#assert Foo == Bar;
		#assert Foo == Baz;
	}

	test(struct {}); // Here we pass a type literal, but it gets assigned to an identifier on the inside, so no strange behaviour happens.

	{
		// isa means implicit cast from this type back to the base type
		// Int_Wrapper -> int
		Int_Wrapper :: #type,isa int;
	}

}

#load "sandbox.jai";
