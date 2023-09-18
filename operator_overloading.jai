main :: () {
	IntWrapper :: struct {
		value: int;

		// Unfortunately this does not work well because this overload is
		// within the struct scope. It is not added to the scope outside
		// the struct meaning it cannot be called implicity, only explicitly.
		operator + :: (a: IntWrapper, b: IntWrapper) -> IntWrapper {
			return .{value = a.value + b.value};
		}

		SECRET :: 1337;
	}


	using Outer;
	a := IntWrapper.{value=34};
	b := IntWrapper.{value=35};

	// This is a thing, by the way! You can call operator overloads explicitly.
	print("%\n", IntWrapper.operator+(a, b));


	// You could just declare the operator outside of the struct if you wanted to
	// and then this problem would be gone. However, if you insist on putting it
	// inside the struct declaration, (which, idk, I think it makes sense to put
	// it there) then there are various solutions.



	{ // Solution 1
		// Yoink the operator into this scope by aliasing it
		operator + :: IntWrapper.operator +;
		print("solution 1: %\n", a + b);

		// You can actually use this to redeclare one operator like another
		// operator / :: IntWrapper.operator +;
		// That's gonna really mess with some people.
	}

	{ // Solution 2
		// Yoink all const declarations on the struct into this scope with `using`
		using IntWrapper;
		print("solution 2: %\n", a + b);
	}

	{ // Solution 3
		// Yoink only + into this scope with `using`.
		using,only(.["+"]) IntWrapper;
		print("solution 3: %\n", a + b);

		// This syntax is a bit fucky, for normal fields you can just write this:
		//   using,only(field_name)
		// For operators that doesn't work, though:
		//   using,only(operator+)
		//   using,only(+)
		// Neither of those are valid.
	}



	{ // Solution 4
		// Yoink only all operators into this scope.
		operators :: string.["+", "-", "*", "/", "==", "!=", "<<", ">>", "&", "|", "[]", "%", "^", "<<<", ">>>", "[]="];
		using,only operators IntWrapper;
		print("solution 4: %\n", a + b);
	}



	{ // Solution 5
		// This insane macro that is literally Solution 4 but only 6 characters shorter
		use_operators :: (c: Code) #expand {
			#insert,scope(c) -> string {
				// scope(c) means the code we paste will have the same scope as where the code is from.
				// Meaning the using statement will actually be applied to the outer scope, rather than only the scope of this macro.
				C :: #import "Compiler";
				P :: #import "Program_Print";
				S :: #import "String";

				// The reason for using c: Code -> compiler_get_nodes -> print_expression
				// rather than $T: Type -> type_info(T).name is because in contexts where
				// the struct is in a namespace .name only returns the name of
				// the struct but not the whole expression needed to correctly
				// address it. With Code, the actual expression is copied verbatim.
				nodes := C.compiler_get_nodes(c);

				b: String_Builder;

				macro_body := #string MACRO_BODY
#assert(type_of(StructName) == Type);
#assert(type_info(StructName).type == .STRUCT);
using,only(.["+", "-", "*", "/", "==", "!=", "<<", ">>", "&", "|", "[]", "%", "^", "<<<", ">>>", "[]="]) StructName;
				MACRO_BODY;

				while 1 {
					split: bool; l: string;
					split, l, macro_body = S.split_from_left(macro_body, "StructName"); // do not use % because it's one of the operators.
					append(*b, l);
					if !split break;
					P.print_expression(*b, nodes);
				}

				bts := builder_to_string(*b);
				//write_string(bts);
				return bts;
			}
		}

		// using a more complex example here just to prove that this macro can handle it.
		a := Outer.FloatWrapper.{value = 34};
		b := Outer.FloatWrapper.{value = 35};

		use_operators(Outer.FloatWrapper);
		print("solution 5: %\n", a + b);
	}
}

Outer :: struct {
	FloatWrapper :: struct {
		value: float;

		operator + :: (a: FloatWrapper, b: FloatWrapper) -> FloatWrapper {
			return .{value = a.value + b.value};
		}

		SECRET :: 1337;
	}
}

#import "Basic";
