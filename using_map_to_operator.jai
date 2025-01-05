main :: () {

	// 044_using_advanced mentions that with using,map you can return strings which
	// contain characters that are not normally allowed in identifiers. What if I
	// use + or *, does it map to the operator overloads?

	Foo :: struct {
		value: int;
		add :: (f1: Foo, f2: Foo) -> Foo {
			return .{f1.value + f2.value};
		}
		operator * :: (f1: Foo, f2: Foo) -> Foo {
			return .{f1.value * f2.value};
		}
	}

	a, b : Foo = .{34}, .{35};

	{
		operator + :: Foo.add;
		print("operator + :: Foo.add;\n"); defer print("\n");
		print("a + b is %\n", a + b); // printex(a + b) actually does not work if + is overloaded, see bug_insert_operator_overloads.jai
	}

	{
		using Foo;
		print("using Foo;\n"); defer print("\n");
		printex(add(a, b));
		print("a * b is %\n", a * b);
	}

	{
		using,map(map_add_to_plus_sign) Foo;
		print("using,map(map_add_to_plus_sign) Foo;\n"); defer print("\n");
		print("operator + did not get assigned to\n");
		print("the overload for asterisk also no longer works, despite the map proc not touching it at all\n");
		// print("a + b is %\n", a + b); // this doesn't work.
		// print("a * b is %\n", a * b); // also broke.
	}

	// it does work the other way around, though!

	{
		using,map(map_asterisk_to_multiply) Foo;
		print("using,map(map_asterisk_to_multiply) Foo;\n"); defer print("\n");
		printex(multiply(a, b));
	}


}


// map the procedure 'add' to '+', which maybe becomes the + operator?
map_add_to_plus_sign :: (names: [] string) {
	for * names {
		if it.* == "add" {
			it.* = "+";
			write_string("map_add_to_plus_sign just mapped 'add' to '+'\n");
		}
	}
}

map_asterisk_to_multiply :: (names: [] string) {
	for * names {
		if it.* == "*" {
			it.* = "multiply";
			write_string("map_asterisk_to_multiply just mapped '*' to 'multiply'\n");
		}
	}
}

#load "sandbox.jai";
