main :: () {
	i := 1;
	compare_pointers(*i, *i);   // i is an lvalue so works as expected
	compare_pointers(**i, **i); // We can take pointers to rvalues! They get an invisible spot on the stack.

	// We cannot take pointers to "small constants"
	// compare_pointers(*1, *1); // not possible

	// But we can take pointers to the return values of procs!
	compare_pointers(*dup(1), *dup(1));
	compare_pointers(*dup(i), *dup(i)); // Not the same as *i, the returnvalue becomes an rvalue and so taking a pointer to it reserves an invisible stack spot.
	compare_pointers(*dup_inline(1), *dup_inline(1));
	compare_pointers(*dup_inline(i), *dup_inline(i));
	compare_pointers(*dup_macro(1), *dup_macro(1));
	compare_pointers(*dup_macro(i), *dup_macro(i)); // This might have been the same as *i cuz it's a macro, but it seems that the return value of macros are still rvalues.
}

compare_pointers :: (a: *$T, b: *T, $call: = #caller_code) {
	code_str :: #run code_to_string(call);
	print("%: %equal (a: %, b: %)\n", code_str, ifx a != b "not ", a, b);
}

dup :: (v: $T) -> T { return v; }
dup_inline :: inline (v: $T) -> T { return v; }
dup_macro :: (v: $T) -> T #expand { return v; }

#load "sandbox.jai";
