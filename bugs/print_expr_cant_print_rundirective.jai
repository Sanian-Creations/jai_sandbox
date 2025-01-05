/*
tested:  beta-1-085
type:    unexpected_behaviour
status:  still_present
related: baked_Code_varargs_pt2.jai
description:
	Implicitly generated Code (expression without #code prefix) is possibly malformed when the expression begins with a #run directive.
	Whether it is malformed is up to question, but Program_Print.print_expression will dereference a null pointer trying to deal with it.
	One thing that is certain is that expressions without a #code directive generate different Code from expressions that do have the directive.
*/

expr_to_string :: ($code: Code) -> string #compile_time {
	sb: String_Builder;
	nodes := compiler_get_nodes(code);
	print_expression(*sb, nodes); // this is where the crash happens
	return builder_to_string(*sb);
}

main :: () {
	// This works.
	code :: #code #run 1 + 2;
	write_string(#run expr_to_string(code));

	// This crashes at comptime by dereferencing a null pointer.
	write_string(#run expr_to_string(#run 1 + 2));

	// Something about the implicit conversion to code makes it so that c.procedure.body_or_null is still null, but `case .DIRECTIVE_RUN;` in print_expression tries to read this value.
	// There's also some flags (0x1000 and 0x20) on the Code_Directive_Run that are not defined in Compiler.jai
}

#import "Program_Print";
#import "Compiler";
#import "Basic";
