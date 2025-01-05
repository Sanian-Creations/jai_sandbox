
main :: () {
	//                _ _ _
	arr := int.[1,2,3,4,5,6,7,8,9];
	md_arr: [6][10]int = [10]int.[
		.[ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
		.[10,11,12,13,14,15,16,17,18,19], //
		.[20,21,22,23,24,25,26,27,28,29], //
		.[30,31,32,33,34,35,36,37,38,39], //
		.[40,41,42,43,44,45,46,47,48,49],
		.[50,51,52,53,54,55,56,57,58,59],
	];
	#assert size_of(type_of(md_arr)) == 6 * 10 * size_of(int);


	view:    []int     = .{3, xx *arr[3]};
	md_view: [][10]int = .{3, xx *md_arr[1]};

	printex(view); // 4,5,6

	// mark individual expressions
	printex(#no_abc view[3]);  // 7
	printex(#no_abc view[-1]); // 3

	// NOTE: fixed size arrays always check bounds at comptime if you index with constants, regardless of #no_abc directive
	// printex(#no_abc md_view[0][-1]);
	// printex(#no_abc md_view[0][10]);

	// it works with non-constants, though.
	minus_one := -1;
	ten       := 10;
	three     := 3;
	printex(#no_abc md_view[0][minus_one]);

	// NOTE: #no_abc only applies to the last subscript of the expression.
	// printex(#no_abc md_view[3][ten]); // [3] still has runtime checks, but [ten] does not.
	printex(#no_abc (#no_abc md_view[3])[ten]); // now both are unchecked.

	// That seems a bit annoying to read/write, so you can do this:

	// mark entire blocks (also works on proc bodies)
	#no_abc {
		printex(view[3]); // 7
		printex(view[4]); // 8
		printex(view[5]); // 9
	}

	// More complex example: var.array[i].array[j]

	TwoInt :: struct {
		array: [2]int;
	}
	TwoTwoInt :: struct {
		array: [2]TwoInt;
	}

	tti := cast(*TwoTwoInt) *md_arr[3][0]; // {[ {[30, 31]}, {[32, 33]} ]}

	// printex(#no_abc tti.array[three].array[minus_one]); // still only targets [minus_one]
	printex(#no_abc (#no_abc tti.array[three]).array[minus_one]); // so we have to do this

	// printex(itt.array[#no_abc 5].array[#no_abc minus_one]);      // this syntax I think would be better
}

#load "sandbox.jai";