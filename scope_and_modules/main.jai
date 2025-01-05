main :: () {
	print("huh!\n");
}

not_used :: () {
	#import "Basic";
}

#scope_file

printex :: ($c: Code) #expand {
	{
		#import "Basic";
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
}
