
main :: () {
	str := "hi";
	boolean := false;

	varargs_code((#code 1 + 2), (#code str), (#code boolean)); // Unfortunately only this works, for now.
    // varargs_code(1 + 2, str, boolean);                         // ...when it should be this.

	// The above works because anything marked #code becomes constant
	// The latter however, complains that the arguments are not constant, even though it should also know they are to be treated as code, in which case they *are* constant.
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

#load "sandbox.jai";
#import "Compiler";
#import "Program_Print";