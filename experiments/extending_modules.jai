main :: () {
	Basic.my_hello();
	Basic.assert(true);
}

// Extend the Basic namespace with my own crappy procs.
// Not a good pattern, but possible.
Basic :: struct {
	using #import "Basic";
	my_hello :: () {
		print("Hello!\n"); // since the surroudning scope "uses" Basic, i can call print here without prefix.
	}
}
