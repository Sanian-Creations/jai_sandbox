Custom_Type :: struct {
	value : int;
	name  : string;
}

operator + :: (ct: Custom_Type, num: int) -> Custom_Type {
	return .{value = ct.value + num, name = ct.name};
}

main :: () {
	{
		// Initialize multiple vars at once, and of different types
		a, b, c, d := 12, 34.56, cast(u8) 78, Custom_Type.{value = 34, name = "Steve"};

		// It also works with shorthand operators like += -= *= etc
		// even if the operators are overloaded (note d: Custom_Type)
		a, b, c, d += 9, 10.11, 12, 35;

		// Not reccommended you do this, it seems to be slower than individual
		// assignments, at least in bytecode. Explained in more detail further below.

		// If you only specify one item on the right side, it will apply that
		// single thing to all variables listed on the left.
		x, y, z := 1; // all set to 1
		x, y, z *= 5; // all multiplied by 5

		// Again, this works even if the listed items are of different types.
		e: int;
		f: float;
		g: u8;
		e, f, g =  34;
		e, f, g += 35;
	}
	{
		a, b: int;

		// NOTE: comma separated assignment is NOT syntax sugar for sequential assignment.
		a, b = 1, 10;
		a = b;          // a = 10, the 1 is overwritten
		b = a;          // b = 10, pointless assignment
		print_all(a,b);

		a, b = 1, 10;
		a, b = b, a;    // a = 10, b = 1
		// Even if you are reading from the same variables you are writing to,
		// their values do not change halfway through because of the assignment itself.
		// This is a proper swap.
		print_all(a,b);
	}

	{
		hm :: (ptr: *int) -> int {
			ptr.* = 10;
			return 2;
		}

		a, b: int;

		a, b = hm(*a), a;
		print_all(a, b);

		// The call to hm() modifies a to 10,
		// and a is eventually assigned to b, which should make b 10.
		// After this line is evaluated, b is indeed 10.
		// However, a is not 10, it is the 2 that was returned from hm().

		// This means that all items on the right are first evaluated in left-to-right
		// order, and only after that is done, are the actual assignments done.

		// That means that at least in theory, there are 2 temp variables. Each
		// expression on the right side is evaluated and stored in its own temp variable,
		// only afterwards are all of the temp slots copied over to the left hand side.
		// These temp variables may be optimized out, but the code at least behaves as
		// if this is how it works, and un-optimized code shows this.

		// As of right now (19/08/2023), the byte code for the following swap
		// procs is different. The one that uses multiple assignment actually has
		// more instructions. Enable the #if below to see, then run this command:

		// jai -x64 multiple_assignment.jai -exe z -quiet

		#if 0 {

		basic_swap :: (a: int, b: int) #dump {
			temp := a;
			a = b;
			b = temp;
		}
		multiple_assignment_swap :: (a: int, b: int) #dump {
			a, b = b, a;
		}
		theoretically_same_as_multiple_assignment_swap :: (a: int, b: int) #dump {
			b_val := b;
			a_val := a;
			a = b_val;
			b = a_val;
		}

		} // #if

		// Here's an even more interesting example, the first and last seem to have
		// the same bytecode, but the multiple assignment has some additional copies
		// for reasons I don't understand.

		#if 0 {

		basic_ptr_swap :: (a: *int, b: *int) #dump {
			temp := a.*;
			a.* = b.*;
			b.* = temp;
		}
		multiple_assignment_ptr_swap :: (a: *int, b: *int) #dump {
			a.*, b.* = b.*, a.*;
		}
		theoretically_same_as_multiple_assignment_ptr_swap :: (a: *int, b: *int) #dump {
			b_val := b.*;
			a_val := a.*;
			a.* = b_val;
			b.* = a_val;
		}

		} // #if

	}

	{
		// procs that return multiple values may also be put on the right side of
		// a shorthand operation that expects as many values.

		one_two_three :: ()-> int, int, int {
			return 1,2,3;
		}

		x, y, z := 10;
		x, y, z *= one_two_three();
		print_all(x,y,z);
	}
}

print_all :: (args: ..Any, $call := #caller_code) #expand {

	fmt_string :: #run -> string {
		#import "Compiler";
		proc_call := cast(*Code_Procedure_Call) compiler_get_nodes(call);
		num_args  := proc_call.arguments_unsorted.count;
		assert(num_args > 0);

		sb: String_Builder;
		for 1..num_args append(*sb, "%, ");
		str := builder_to_string(*sb);
		str.count -= 1;                // chop off the trailing space.
		str[str.count-1] = #char "\n"; // replace trainling comma with a newline

		return str;
	};

	print(fmt_string, ..args);
}

#import "Basic";
