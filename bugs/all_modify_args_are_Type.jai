/*
tested:  beta-1-085
type:    should_not_error
status:  still_present
description:
	#modify directive cannot assign integer constants, it can only assign Type constants.
	It can change The type of T in `[5]$T`, but it cannot change the value of N in `[$N]int`, because it assumes N to be a Type.
*/

foo :: ($num: int) -> *[$B]u8
#modify {
	SHOULD_WORK :: true;

	#if SHOULD_WORK {
		B = fib(num); // Error: Type mismatch. Type wanted: Type; type given: int.
	} else {
		// This errors as expected.
		B = string;   // Error: The dimension in this array declaration is not an integer. (Its type is Type.)
	}

	return true;
} {
	return New([B]u8);
}

main :: () {
	val := foo(6);
	print("type_of(val) is %\n", type_of(val)); // should be: *[8] u8
}

fib :: (num: int) -> int {
	assert(num >= 0);
	return ifx num <= 1 then num
		else fib(num-1) + fib(num-2); // naive approach, fine for this example
}

#import "Basic";
