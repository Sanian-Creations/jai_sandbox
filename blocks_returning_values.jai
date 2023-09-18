main :: () {

	// We're hijacking a feature of ifx in order to create blocks that return values.

	a := ifx 1 {
		print("You can just have a block return a value.\n");
		write_string("Really?\n");
		print("Yeah.\n");

		defer print("Cool beans are deferred.\n");

		return_69(); // not a macro, regular proc.

		// The value of the last expression here is the value that's returned.
		// ...is this rust?
	};

	// A reason I'd want this is because of temporary variables that I don't want in my scope.
	// If I want to assign a single variable, but I have some other variables that I need to use
	// during the calculation, then once I'm done with the calculation, I want to discard those
	// variables. Having a block that returns a variable at the end is really nice for this,
	// because blocks discard all variables defined within them at the end.


	print("\n");

	// You can return whilst in the ifx block. Neat.
	ret_from_ifx :: (do_return: bool){
		b := ifx 1 {
			if do_return {
				print("(%)  returning!!\n", do_return);
				return;
			}
			print("(%) did not return from the ifx\n", do_return);
			69;
		};
	}

	ret_from_ifx(false);
	ret_from_ifx(true);

	print("\n");


	// Here's an example of a variable I want to discard after doing soemthing with it.

	try_get_the_value :: (get_it: bool) {
		print("getting value (%)\n", get_it);

		value := ifx 1 {
			ok, v := get_value_or_maybe_not(get_it);
			if !ok return; v;// <- note I have to put this here to return it from the block
		};

		print_expr(value);
	}

	try_get_the_value(false);
	print("\n");

	try_get_the_value(true);
	print("\n");


	(){
		// Cool as it is, it is a little verbose when using it for this case here.
		value := ifx 1 {
			ok, v := get_value_or_maybe_not(true);
			if !ok return; v;
		};

	}();
	(){

		// In this case I would probably just prefer this:
		value: int; {
			ok, value= := get_value_or_maybe_not(true);
			if !ok return;
		}

		// The value= syntax here is what makes this better. If that did not exist,
		// then I would prefer the ifx-hijack-approach.
	}();

	(){
		// Of course I could also do this, but the whole point was that I then have this
		// extra variable in my scope that I do not want there.
		ok, value := get_value_or_maybe_not(true);
		if !ok return;

		// Still have the variable 'ok' here now.

		// Odin does this, but I'm not a fan of that either
		/*
		if ok, value := get_value_or_maybe_not(true); ok {
			// here you can use 'value' (and 'ok', but that is always true so there's no point)
		}
		// now you don't have 'ok' and 'value' anymore
		*/

		// Honestly a directive like #discard might also be nice for this, just throw away
		// variables I don't want in my scope anymore.
		// #discard ok;
	}();

	// Also, this ifx method may be a little error prone?
	// It actually accepts it if you forget to put an expression at the end.
	(){
		value := ifx 1 {
			ok, v := get_value_or_maybe_not(true);
			if !ok return;
			// <- no expression here
		}
		print_expr(value); // it prints void!
		print_expr(type_of(value)); // it prints void!

		// It reads the `if !ok return;` as an expression, but it is a statement which
		// does not return anything, so it returns void
	}();

}

get_value_or_maybe_not :: (get_it: bool) -> bool, int {
	if get_it
	then return true, 69;
	else return false, 0;
}

return_69 :: () -> int {
	print("return_69()\n");
	return 69;
}

#load "sandbox.jai";
