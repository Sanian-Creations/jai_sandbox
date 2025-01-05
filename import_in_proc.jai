
not_used :: () {
	#import "Basic"; // does not import into proc scope, but into application scope!
	Str :: #import "String"; // imports into this var, which is only in this scope
}

main :: () {
	// Basic is imported within not_used, but it still yoinked
	// everything into the aplication scope, allowing us to use print() here.
	print("huh!\n");

	// Str is a constant that is local to the scope of not_used, though. So it cannot be used here
	/*
	found, a, b := Str.split_from_left("whatever man", "er ");
	print("%|%\n", a, b);
	*/
}

