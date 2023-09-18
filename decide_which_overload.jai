call_const_or_mut :: () {
	// this proc has an overload where the arg is const and one where it is mutable
	// the mutable version is chosen every time
	x := 5;

	const_or_mut(5); // it picks the non-baking version every time.
	const_or_mut(x);

	print("---\n");

	const_or_mut_2(5);
	const_or_mut_2(x);
}

const_or_mut :: ($a: int) {
	write_string(#run tprint("const: %\n", a)); // can bake this string
}

const_or_mut :: (a: int) {
	print("mut: %\n", a); // cannot bake this string
}

// if you want it to optionally bake, then you don't have to use overloads, you have to use $$, which means
// it generates a single proc that is used for non-constants that are passed, but it bakes a new proc for every
// constant you pass it.
const_or_mut_2 :: ($$a: int) {
	#if is_constant(a) {
		write_string(#run tprint("const: %\n", a)); // can bake this string
	} else {
		print("mut: %\n", a); // cannot bake this string
	}
}





same_signature :: (a: int) {
	print("version a\n");
}
/* this cannot even exist since it has the same signature */
// same_signature :: (b: int) {
// 	print("version b");
// }

/* but what if we give it a different type that is actally just the same type? */
also_int :: #type int;
/* still not allowed. */
// same_signature :: (b: also_int) {
// 	print("version b");
// }

/* make it a little more specific? */
isa_int :: #type,isa int;
same_signature :: (b: isa_int) {
	print("version b\n");
}

/* even more specific also works */
distinct_int :: #type,distinct int;
same_signature :: (c: distinct_int) {
	print("version c\n");
}


procs_with_same_signature :: () {
	same_signature(5);     // version a
	same_signature(b = 5); // version b (literal 5 turns into isa_int implicitly)
	same_signature(c = 5); // version c (literal 5 turns into distinct_int implicitly)
	print("---\n");
	x := 5;
	same_signature(x);     // version a
	// same_signature(b = x);    // compiler err (int cannot implicitly cast to isa_int)
	// same_signature(c = xx x); // compiler err (int cannot implicitly cast to distinct_int)
	same_signature(b = xx x); // works with auto cast
	same_signature(c = xx x); // compiler err (int cannot implicitly cast to distinct_int)
}



main :: () {
	call_const_or_mut();
	print("\n");
	procs_with_same_signature();
}

#load "sandbox.jai";
