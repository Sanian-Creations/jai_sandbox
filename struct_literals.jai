Foo :: struct {
	a: int;
	b: int;
}

main :: () {

	// You can take pointers to literals!

	wowie := *Foo.{};

	// Be careful though, there is a difference between constant literals and
	// non-constant literals. Constant literals are stored within the executable
	// in read-only memory. This means you cannot write to them, but you can return pointers to them from procs.
	// (not if you first copy it to the stack and THEN take its pointer, though)
	// Non-constant literals are constructed on the stack, meaning you can write to
	// them, but pointers to them become invalidated after the proc scope, so returning those is a no-no.

	#assert(is_constant(Foo.{a = 69})                  == true);
	#assert(is_constant(Foo.{a = crazy_calculation()}) == false);

	// NOTE:
	#assert(is_constant(*Foo.{}) == false);
	// this is not constant, even though the literal itself IS constant.
	// Taking a pointer is always non-constant.


	format_pointer :: (c: Code) -> FormatInt #expand {
		#assert(size_of(u64) == size_of(type_of(#insert c)));
		return .{
			value            = cast(u64) #insert c,
			base             = 16,
			minimum_digits   = 12,
			digits_per_comma = 4,
			comma_string     = "_",
		};
	}

	f: Foo;
	print(#string STOP
local var:         %
non const literal: %
const literal:     %
STOP,
		format_pointer(*f),
		format_pointer(*Foo.{a = crazy_calculation()}),
		format_pointer(*Foo.{}),
	);
}


crazy_calculation :: () => 5; // it is secretly not so crazy

#import "Basic";
