main :: () {
	set_print_style_verbose();

	// Lets try to use varargs on a struct to make a basic Tuple.

	// This is the naive approach where we print the types as string.
	Naive_Tuple :: struct(types: ..Type) {
		#insert -> string {
			sb: String_Builder;
			for types  print_to_builder(*sb, "_%: %;\n", it_index, it);
			return builder_to_string(*sb);
		}

		/*
			Naive_Tuple(int, string):
			{
				_0: int;
				_1: string;
			}
		*/
	}

	Tuple :: struct(types: ..Type)
	{
		#insert -> string {
			sb: String_Builder;
			for types  print_to_builder(*sb, "_%1: types[%1];\n", it_index);
			return builder_to_string(*sb);
		}


		/*
			Since all args to a struct are constant, varargs on a struct are
			not converted to an array view [], but to an actual array [N],
			so you can simply express the types of fields like this:

			Tuple(Foo, Bar):
			{
				_0: types[0]; // just works!
				_1: types[1];
			}
		*/

		#assert is_constant(types.count);
		#run { // Show that types is an array [N]
			printex(types);
			printex(type_of(types));
		}
	}

	{ // For simple types, the Naive_Tuple and Tuple work the same
		tuple_a: Naive_Tuple(string, int, float, u8);
		printex(tuple_a);

		tuple_b: Tuple(string, int, float, u8);
		printex(tuple_b);
	}

	{ // But when introducing new types, Naive_Tuple falls flat on its face!
		Foo :: struct {f: string;}
		Bar :: struct {b: string;}

		/* uncomment to see an error */
		// naive_foobar_tuple: Naive_Tuple(Foo, Bar);
		// printex(naive_foobar_tuple);

		/* this one can handle it, though */
		foobar_tuple: Tuple(Foo, Bar);
		printex(foobar_tuple);
	}
}

#load "sandbox.jai";
