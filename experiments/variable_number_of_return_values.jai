main :: () {
	// The goal is to make a procedure with a variable amount of return values.

	// Simply put, this is not possible.
	// - When calling a procedure, the signature must be known.
	// - The signature includes the number of return values.
	// - Therefore the number of return values cannot be changed by the caller (other than by calling a different overload)

	// Here's some things we CAN do, that are maybe close.

	{ // Return a fixed size array
		return_array :: ($numbers: ..int) -> [numbers.count]int {
			ret: [numbers.count]int;
			for numbers ret[it_index] = it;
			return ret;
		}

		printex(return_array(1,2,3));
		printex(return_array(56,76,43,2,54));
	}

	{ // return a struct, and when you apply 'using' to it, you can use the members as if they were variables.
		Special_Struct :: struct(names: [$N]string, T: Type) {
			#insert -> string {
				sb: String_Builder;
				for names print_to_builder(*sb, "%: T;\n", it);
				return builder_to_string(*sb);
			}
		}
		something :: ($names: ..string, values: [names.count]$T) -> Special_Struct(names, T) #expand {
			nqaa: Special_Struct(names, T) = #insert -> string {
				sb: String_Builder;
				print_to_builder(*sb, ".{");
				for names print_to_builder(*sb, "% = values[%],\n", it, it_index);
				print_to_builder(*sb, "};");
				return builder_to_string(*sb);
			};
			return nqaa;
		}

		using something("a", "b", "c", values = int.[1,2,3]);
		printex(a);
		printex(b);
		printex(c);
	}

	{ // use a macro to declare variables in the outer scope
		something :: (vars: string, $values: ..$T) #expand { #insert -> string {
			using #import "String";
			sb: String_Builder;
			names := split(vars, ", ",, temp);
			assert(names.count == values.count);
			for names print_to_builder(*sb, "`% := values[%];\n", it, it_index);
			return builder_to_string(*sb);
		};}

		something("a, b, c", 4, 5, 6);
		printex(a);
		printex(b);
		printex(c);
	}

	{ // generate a struct that has a procedure which has the return values we want.
		Special_Struct :: struct(values: [$N]$T) #type_info_none {
			#assert N > 0;
			#insert -> string {
				sb: String_Builder;
				print_to_builder(*sb, "f :: inline () -> ");
				for 2..values.count print_to_builder(*sb, "T #must, ");
				print_to_builder(*sb, "T #must { return ");
				for 0..values.count-2 print_to_builder(*sb, "values[%], ", it);
				print_to_builder(*sb, "values[%]; };", values.count-1);
				return builder_to_string(*sb);
			}
		}
		something :: ($values: ..$T) -> Special_Struct(values) #expand { return .{}; }

		a, b, c := something(7,8,9).f();
		printex(a);
		printex(b);
		printex(c);

	}

	{
		// the thing that initially prompted this experiment was me trying to make a procedure that could give me some views allocated in a contiguous block of memory
		// something like:
		// a, b, c := alloc_arrays(int, 12, 34, 56);
		// a has 12 elems, b 34, c 56

		// The previous experiment may seem the most fitting here, but there's an issue with it.
		// That is: for vararg procs, the number of arguments passed is only constant if the values that are passed are themselves constant.
		foo :: (args: ..$T) { #assert is_constant(args.count) == false; } // args is not constant so the count is never constant.
		foo(1, 2, 3);

		bar :: ($args: ..$T) { #assert is_constant(args.count) == true; } // args is constant, so all the elements must be constant too.
		bar(1, 2, 3); // this works

		variable: = 1;
		#if 0 bar(variable, 2, 3); // this doesn't


		// what would work, is if I made the args a fixed size array
		alloc_arrays :: struct (num: int, T: Type) {
			#assert num > 1;
			#insert -> string {
				//                 h := inserthelper(#string TEMPLATE
				// f :: ($$$) -> *T, $$$ {
				//     total_len := $$$;
				//     base_array := NewArray(total_len, T);
				//     i := 0;

				// $$$
				//     view%1: []T = .{count%1, base_array.data + i};
				//     i += count%1;

				//     return RETURNS;
				// }
				//                 TEMPLATE);
				sb: String_Builder;
				append(*sb, "f :: (");
				for 1..num print_to_builder(*sb, "count%: int%", it, ifx it != num "," else ") ");
				append(*sb, "-> ");
				for 1..num print_to_builder(*sb, "[]T, ");
				append(*sb, "*T #must {\ni := 0;\ntotal_len := ");
				for 1..num print_to_builder(*sb, "count%0%", it, ifx it != num "+" else ";\n");
				append(*sb, "base_array := NewArray(total_len, T);\n");
				for 1..num print_to_builder(*sb, #string CODE
					view%1: []T = .{count%1, xx (base_array.data + i)};
					i += count%1;
				CODE, it);
				append(*sb, "return ");
				for 1..num print_to_builder(*sb, "view%, ", it);
				append(*sb, "base_array.data;\n}");
				return builder_to_string(*sb);
			}
		}

		a,b,c, ptr := inline alloc_arrays(3, int).f(2,3,4);
		defer free(ptr);
		for 0..(2+3+4)-1 ptr[it] = it;
		printex(a);
		printex(b);
		printex(c);

		d,e,f := ..int.[1,2,3];
	}
}

#load "sandbox.jai";
