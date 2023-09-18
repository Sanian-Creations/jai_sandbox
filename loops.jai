main :: () {
	// You can break/continue specific loops by assigning a name to the looping condition

	i := 0;
	while outer_loop := i < 2 {
		defer i += 1;

		// can also loop on types other than bool, when they are not 0
		while inner_loop := i {

			// What is this var that names the loop?
			// it is literally the value you assign to it.
			print_expr(inner_loop); // here it's the value of i
			print_expr(outer_loop); // for bools it is always true.

			// Can it be written to?
			outer_loop = false; // yes it can. This does not affect the loop.
			print_expr(outer_loop);

			// this inner loop is only as an example, just break right away so it only runs once.
			break inner_loop;
		}

		write_string("---\n");
	}


	str := #string LINES
this
is
a
set
of
lines
	LINES;

	// Can you use this variable that names the loop in a similar way to
	// how you can make iterators in Odin? Not quite.

	// Uing multiple return values at the start of a while loop is not supported
	//while loop_1, line := iterate_lines(*str) {
	//	print("\"%\"\n", line);
	//}

	// So to make this work, you have to pass in a pointer instead.
	line: string;
	while loop_1 := iterate_lines(*str, *line) {
		print("\"%\"\n", line);
	}


}

iterate_lines :: (str: *string) -> bool, string {
	for 0..str.count-1 {
		if str.*[it] == #char "\n" {
			line := iview(str, to   = it);
			str.* = iview(str, from = it+1);
			return true, line;
		}
	}

	defer str.* = "";
	return str.count != 0, str.*;
}

iterate_lines :: (str: *string, line: *string) -> bool #expand {
	ok: bool;
	ok, line.* = iterate_lines(str);
	return ok;
}


as_ascii_char :: (num: u8) -> string #expand {
	// must be a macro or *num gets invalidated after return
	str: string;
	str.count = 1;
	str.data  = *num;
	return str;
}

#load "../jai_sanian/view.jai";
#load "sandbox.jai";