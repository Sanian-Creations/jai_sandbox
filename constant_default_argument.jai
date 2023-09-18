main :: () {
	print_exclaim :: (str: string, $exclamation_count := 1) {
		write_string(str);
		for 1..exclamation_count write_string("!");
		write_string("\n");
	}

	// BAM! Is that so hard, Odin?
	print_exclaim("hello");
	print_exclaim("hello", 7);
}