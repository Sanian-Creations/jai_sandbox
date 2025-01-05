/*
tested:  beta-1-085
type:    unexpected_behaviour
status:  still_present
description:
	#as should cause the marked struct member to be implicitly passed to procedures expecting such a type.
	This works if the marked member is a normal struct, but if the marked struct member is a polymorphic struct,
	it will not pass the marked member, but instead pass the whole encompassing struct, which generates a new polymorph for the proc.
*/

main :: () {
	Holder_non_poly :: struct {
		array: [5] int;
	}
	Holder :: struct ($T: Type, $N: s64) {
		array: [N] T;
	}

	Foo :: struct { #as holder: Holder_non_poly; }
	Bar :: struct { #as holder: Holder(int, 5); }

	example1 :: (holder: Holder_non_poly) { print("in example1 (holder: Holder_non_poly)  type_of(holder) is %\n", type_of(holder)); }
	example2 :: (holder: Holder($T, $N))  { print("in example2 (holder: Holder($T, $N))   type_of(holder) is %\n", type_of(holder)); }
	example3 :: (holder: Holder)          { print("in example3 (holder: Holder)           type_of(holder) is %\n", type_of(holder)); }

	foo: Foo;
	bar: Bar;
	example1(foo); // foo.holder is passed in because of #as
	example2(bar); // bar.holder is passed in because of #as
	example3(bar); // bar is passed as a whole?
}
#import "Basic";
