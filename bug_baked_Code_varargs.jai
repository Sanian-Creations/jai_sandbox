
// Let's try to have macro that knows:
// 1. args count as a constant
// 2. the type of every argument as a constant

varargs_macro :: ($args: ..Code) #expand { hardcoded_print(args); }

hardcoded_print :: ($args: [$N]Code) #expand { #insert -> string {
	sb: String_Builder;
	template :: #string CODE
	{
		v := #insert args[%1];
		print("arg %1 is of type %%, value is %%\n", type_of(v), v);
	}
	CODE
	for args print_to_builder(*sb, template, it_index);
	return builder_to_string(*sb);
}}

main :: () {
	a := "hi";
	b := 1;
	c := false;

	hardcoded_print(.[a, b, c]); // This works, but we'd like to be able to do it without the brackets.

	// varargs_macro(a, b, c);   // like this
	varargs_macro((#code a), (#code b), (#code c)); // unfortunately only this works, for now.

	// this works, because `#code anything` is always constant
	// the first one proclaims that the arguments are not constant, even though it should also know they are to be treated as code
}


#load "sandbox.jai";
