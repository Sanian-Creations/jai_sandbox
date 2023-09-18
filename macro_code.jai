main :: () {

	set_print_style_verbose();

	// code can be used to pass statements
	code_block :: #code {
		print("Hello!");
	}

	// code can also be expressions
	code_expr :: #code 5;

	// Code van be inserted using #insert.
	// similar to how C macros just paste the text, only now it's not just shitty text pasting but actually places the AST node there

	does_it_add_braces :: (c: Code) -> int #expand {
		return 10 * #insert c;
	}

	// A Code parameter will just take the expression that is passed and and turn it into Code without using the #code directive.
	print("%\n", does_it_add_braces(1 + 5));
	/*
	if this code expands to 10 * 1 + 5 (which I DONT want) then it outputs 15;
	if this code expands to 10 * (1 + 5) then it outputs 60, which is great!

	output:
	> 60

	And it does add braces! Take THAT, stupid C macro's!
	*/



	print_code :: (c: Code) { // not a macro!

		// You can use Code outside of macros, but it only contains 8 bytes of data.
		print_expr(#code c); // have to explicitly treat this c as a statement itself, not passing it through to the macro
		print_expr(type_info(Code).*);

		// In order to really do something with code you need to import "Compiler",
		// but the procs in there can only be called at compile time. So using Code at
		// runtime is rather pointless. Try uncommenting the code below. Note you'll
		// get a stack trace where one of the procs is:
		// __panic_due_to_runtime_call_of_compile_time_procedure

		// #import "Compiler";
		// print("node: %\n", compiler_get_nodes(c));
	}
	print_code(34+35);

	{
		a   := 5;
		ptr := *a;
		print_expr(ptr.*);
		print_expr(<<ptr);
	}

	{
		// in order to turn Code into a string to insert it you have to first
		// call compiler_get_nodes, and then print_expression

		Foo :: struct{a,b: int;}

		using_wrapper :: (c: Code) #expand {
			#insert,scope(c) -> string {
				#import "Compiler";
				#import "Program_Print";

				builder: String_Builder;
				append(*builder, "using ");
        		print_expression(*builder, compiler_get_nodes(c));
        		append(*builder, ";");

        		return builder_to_string(*builder);
			}
		}

		f: Foo;
		using_wrapper(f);
		a = 69;

		print("%\n", f);
	}
}

#load "sandbox.jai";