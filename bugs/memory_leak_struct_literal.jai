/*
tested:  beta-1-085
type:    compiler_hangs
status:  fixed
description:
	Passing a particular struct literal to a procedure with a bakeable parameter will hang the compiler.
*/
main :: () {
//	procedure1(cast(float)make_float64());                               // compiles fine
//	procedure2(cast(float)make_float64());                               // does not compile (as it should)
	procedure3(.{cast(float)make_float64(), cast(float)make_float64()}); // hangs the compiler (and skyrockets memory usage!)  FIXED: get error now
}

Vec2 :: struct { x, y: float; }
procedure1 :: (param: float)  { print("%", param); }
procedure2 :: ($param: float) { print("%", param); }
procedure3 :: ($param: Vec2)  { print("% %", param.x, param.y); }
make_float64 :: () -> float64 { return 3.1415; }

#import "Basic";
