
expr_to_string :: (c: Code) -> string #expand {
	sb: String_Builder;
	nodes := compiler_get_nodes(c);
	print_expression(*sb, nodes); // this is where the crash happens
	return builder_to_string(*sb);
}

#run {
    // This works.
    code :: #code #run 1 + 2;
    write_string(expr_to_string(code));

    // This works too.
    write_string(expr_to_string(#code #run 1 + 2));

    // This crashes by dereferencing a null pointer.
    write_string(expr_to_string(#run 1 + 2));

    // Something about the implicit conversion to code makes it so that c.procedure.body_or_null is still null when print_expression reads it.
    // There's also some flags (0x1000 and 0x20) on the Code_Directive_Run that are not defined in Compiler.jai
}

#run set_build_options_dc(.{do_output = false});

#import "Program_Print";
#import "Compiler";
#import "Basic";