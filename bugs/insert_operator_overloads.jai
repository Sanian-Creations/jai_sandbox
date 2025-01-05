/*
tested:  beta-1-085
type:    should_not_error
status:  still_present
description:
	When code that gets inserted is either a single statement or an expression, it uses the wrong scope to resolve operator overloads.
	It uses the scope where the #insert is, when it should instead use the scope where the code came from.
	The local scope should only be used when ,scope() is added to the #insert directive.
	The code now gets resolved by mixing two different scopes, the wrong one for operator overloads and the correct one for everything else.
*/

Thing :: struct { value: int; }

main :: () {
	operator + :: (a: Thing, b: Thing) -> Thing {
		write_string("Correct operator\n");
		return .{ a.value + b.value };
	}

	a, b: Thing = .{9}, .{10};

	// Works as expected
	do_insert( #code { something := a + b; } );      // Correct operator  (reason: code is a block and not a statement)
	do_insert( #code something := operator+(a, b) ); // Correct operator  (operator is called as a proc, and procs are resolved correctly)

	// Conditions for the bug: The code is a statement or expression and contains an overloaded operator.
	do_insert( #code something := a + b );           // Error: Attempt to use the binary operator '+', which is not defined in this scope
	// If this no longer errors, also ensure that it calls the correct operator and not the wrong one.
}

do_insert :: (c: Code) #expand {
	// Both inserts here should work correctly

	// scope with no operator+
	{ #insert c; }

	// scope with a different operator+
	{
		operator + :: (a: Thing, b: Thing) -> Thing {
			write_string("Wrong operator\n");
			return .{ a.value + b.value + 69105 };
		}

		#insert c;
	}
}