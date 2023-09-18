#import "Basic";

print_expr :: ($c: Code) #expand {
	fmt_string :: #run -> string {
		#import "Compiler";
		#import "Program_Print";

		sb: String_Builder;
		print_expression(*sb, compiler_get_nodes(c));
		append(*sb, " is %\n");

		return builder_to_string(*sb);
	}

	print(fmt_string, #insert c);
}

set_print_style_verbose :: () {
	using context.print_style.default_format_struct;
	use_long_form_if_more_than_this_many_members = -1;
	use_newlines_if_long_form                    = true;
	draw_type_name                               = true;
}

