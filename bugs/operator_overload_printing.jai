// Program_Print does not print operator overload definitions (and usage as identifier) correctly.

main :: () {
	ok := true;

	{ // This already works
		code            :: #code add :: other_proc;
		expected_string ::      "add :: other_proc;";
		actual_string   :: #run code_as_string(code);
		print("expected_string: \"%\"\n", expected_string);
		print("actual_string:   \"%\"\n", actual_string);
		print("%\n\n", ifx actual_string == expected_string then "SAME" else "DIFFERENT");
		ok &&= actual_string == expected_string;
	}

	{ // Making an alias for overload procs of +
		code            :: #code add :: operator +;
		expected_string ::      "add :: operator +;";
		actual_string   :: #run code_as_string(code);
		print("expected_string: \"%\"\n", expected_string);
		print("actual_string:   \"%\"\n", actual_string);
		print("%\n\n", ifx actual_string == expected_string then "SAME" else "DIFFERENT");
		ok &&= actual_string == expected_string;
	}

	{ // Setting proc 'add' to be an overload for +
		code            :: #code operator + :: add;
		expected_string ::      "operator + :: add;";
		actual_string   :: #run code_as_string(code);
		print("expected_string: \"%\"\n", expected_string);
		print("actual_string:   \"%\"\n", actual_string);
		print("%\n\n", ifx actual_string == expected_string then "SAME" else "DIFFERENT");
		ok &&= actual_string == expected_string;
	}

	{ // This case ensures underscores are not interpreted as operators
		code            :: #code _test :: add;
		expected_string ::      "_test :: add;";
		actual_string   :: #run code_as_string(code);
		print("expected_string: \"%\"\n", expected_string);
		print("actual_string:   \"%\"\n", actual_string);
		print("%\n\n", ifx actual_string == expected_string then "SAME" else "DIFFERENT");
		ok &&= actual_string == expected_string;
	}

	{ // This case ensures underscores are not interpreted as operators
		code            :: #code add :: _test;
		expected_string ::      "add :: _test;";
		actual_string   :: #run code_as_string(code);
		print("expected_string: \"%\"\n", expected_string);
		print("actual_string:   \"%\"\n", actual_string);
		print("%\n\n", ifx actual_string == expected_string then "SAME" else "DIFFERENT");
		ok &&= actual_string == expected_string;
	}

	assert(ok);
}

code_as_string :: ($code: Code) -> string {
	sb: String_Builder;
	print_expression(*sb, compiler_get_nodes(code));
	append(*sb, ";");
	return builder_to_string(*sb);
}

#import "Compiler";
#import "Program_Print";
#import "Basic";
