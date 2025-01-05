main :: () {
	{
		using context.print_style.default_format_struct;
		use_long_form_if_more_than_this_many_members = -1;
		use_newlines_if_long_form                    = true;
		draw_type_name                               = true;
	}

	String :: #import "String";
	print("String is %\n", String);
	print("type of String is %\n", type_of(String));
	print("type info of String is %\n", type_info(String).*);
}
#import "Basic";
