#import "Basic";

set_print_style_verbose :: () {
	using context.print_style.default_format_struct;
	use_long_form_if_more_than_this_many_members = -1;
	use_newlines_if_long_form                    = true;
	draw_type_name                               = true;
}

printx :: ($c: Code) #expand {
	print("% is %\n", #run code_to_string(c), #insert c);
}

code_to_string :: ($c: Code) -> string {
	using _ :: #import "Compiler";
	using _ :: #import "Program_Print";

	sb: String_Builder;
	print_expression(*sb, compiler_get_nodes(c));
	return builder_to_string(*sb);
}
