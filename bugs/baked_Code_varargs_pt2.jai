/*
tested:  beta-1-085
type:    unexpected_behaviour
status:  still_present
description:
	Macros accepting Code varargs will first attempt to simplify the expressions before turning them into Code.
	Passing `1 + 2 * 3` does not generate `#code 1 + 2 * 3`, instead it generates `#code 7`.
*/

main :: () {
	single_code(1 + 2 * 3);        // prints 1 + 2 * 3
	varargs_code(1 + 2 * 3);       // prints 7
	varargs_code(#code 1 + 2 * 3); // prints 1 + 2 * 3
}

single_code :: ($code: Code) #expand {
	print("%\n", #run code_to_string(code));
}

varargs_code :: ($args: ..Code) #expand {
	// For this example we only have to print the first arg.
	print("%\n", #run code_to_string(args[0]));
}

code_to_string :: (c: Code) -> string {
	sb: String_Builder;
	nodes := compiler_get_nodes(c);
	print_expression(*sb, nodes);
	return builder_to_string(*sb);
}

#import "Basic";
#import "Compiler";
#import "Program_Print";
