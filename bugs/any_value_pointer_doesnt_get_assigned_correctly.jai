/*
tested:  beta-1-085
type:    unexpected_behaviour
status:  fixed
description:
	Creating multiple Any variables based on teh same local variable will sometimes generate multiple different value_pointer, even though they should all be the same.
*/

// This bug was found by U0
// .u0 on Discord.

main :: () {
	i : int = 27;

	// These should all have the same address for value pointer, but they don't. Not unless you manually get a pointer to i.
	any_1 : Any = i;
	any_2 : Any = i;
	any_3 : Any = i;

	// { p := *i; } // completely arbitrary use of the pointer, comment/uncomment this line to change the outcome of the code below.

	print("any_1 address: %\n", any_1.value_pointer);
	print("any_2 address: %\n", any_2.value_pointer);
	print("any_3 address: %\n", any_3.value_pointer);

	pointers_are_same := any_1.value_pointer == any_2.value_pointer && any_2.value_pointer == any_3.value_pointer;
	print("addresses are the same: %\n\n", pointers_are_same);
	print(ifx pointers_are_same then "This bug has been fixed\n" else "This bug is still present\n");
}

#import "Basic";
