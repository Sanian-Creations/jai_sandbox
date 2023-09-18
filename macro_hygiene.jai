main :: () {

	call_continue :: () #expand { continue; }
	call_return   :: () #expand { return; }
	call_break    :: () #expand { break; }

	for 0..10 {
		// return in a macro only exits the macro, nothing else. it does not return from the current scope.
		if it == 5  call_return();
		// you can do it if you backtick it in the macro though: `return.

		// break works as if it was called from the current scope
		if it == 7  call_break();

		// continue works as if it was called from the current scope
		if it % 2 != 0  call_continue();

		print("%\n", it);


		// honestly, kinda weird that it's not `continue and `break.
	}

	// keywords that can be backticked are 'defer', 'return', 'push_context'
}

#import "Basic";