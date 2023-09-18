using global_thing := Thing.{a=1, b=2,c=3};

main :: () {

	print_expr(a);
	print_expr(b);
	print_expr(c);

	// redeclares a b c, but since they are in an outer scope, no complaints
	using t := Thing.{4,4,4};

	print_expr(a);
	print_expr(b);
	print_expr(c);

	{ // making our own little scope here

		// fine again, cuz it's declarations from the outer scope that we're overwriting.
		using t2 := Thing.{5,5,5};

		print_expr(a);
		print_expr(b);
		print_expr(c);
	}

	// This is NOT ok, because we are redeclaring variables that are
	// declared in this exact scope.
	//using t3 := Thing.{5,5,5};
}

Thing :: struct {
	a: int;
	b: int;
	c: int;
}

#import "Basic";
#load "helpers.jai";
