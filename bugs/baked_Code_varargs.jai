/*
tested:  beta-1-085
type:    should_not_error
status:  fixed
related: baked_Code_varargs_pt2.jai
description:
	Macros accepting Code varargs interpret the passed arguments as values rather than Code.
	This forces you to explicitly write #code before every argument.
*/

main :: () {
	str := "hi";
	boolean := false;

	varargs_code(1 + 2, str, boolean);                         // This should work, but doesn't. FIXED: this works now
//	varargs_code((#code 1 + 2), (#code str), (#code boolean)); // Unfortunately only this works.
}

varargs_code :: ($args: ..Code) #expand {
	#insert -> string {
		sb: String_Builder;
		for args  print_to_builder(*sb, #string CODE
		{
			v := #insert args[%1];
			print("arg %1, `%%` is of type %%, value is %%\n", #run code_to_string(args[%1]), type_of(v), v);
		}
		CODE, it_index);
		return builder_to_string(*sb);
	}
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