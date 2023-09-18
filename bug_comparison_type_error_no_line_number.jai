main :: () {
    proc_int   :: (x: int)   { }
    proc_float :: (x: float) { }
    proc_ret_int   :: () -> int   { return 5; }
    proc_ret_float :: () -> float { return 5; }

    // ok_error1 :: proc_int == proc_ret_int;       // Type mismatch: only this line
    // ok_error2 :: proc_int == proc_float;         // Type mismatch: only this line
    bad_error :: proc_ret_int == proc_ret_float; // Number mismatch: both proc signatures, but no mention of this line
}