/*
tested:  beta-1-091
type:    bad_error
status:  still_present
description:
	Comparing two procedures with == will error if they do not have the same signature.
	That is fine (it is an expected type error), but in the case where the returnvalues are different, the error does not print out the line on which the actual comparison is happening, so you do not know which line is actually causing the error.
*/
main :: () {
	proc_int   :: (x: int)   { }
	proc_float :: (x: float) { }
	proc_ret_int   :: () -> int   { return 5; }
	proc_ret_float :: () -> float { return 5; }

	// ok_error1 :: proc_int == proc_ret_int;       // Type mismatch: this line
	// ok_error2 :: proc_int == proc_float;         // Type mismatch: this line
	bad_error :: proc_ret_int == proc_ret_float; // Number mismatch: both proc signatures, but no mention of this line
}
