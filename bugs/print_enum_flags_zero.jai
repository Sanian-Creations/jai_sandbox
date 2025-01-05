// When printing an enum_flags with value 0 it prints "0" even if the enum has a name for 0.
// I have sent in a patch for this so hopefully it will be included in the next beta.

main :: () {
	Foo :: enum {
		None :: 0;
		Both :: 0x3;
		A    :: 0x1;
		B    :: 0x2;
	}
	Bar :: enum_flags {
		None :: 0;
		Both :: 0x3;
		A    :: 0x1;
		B    :: 0x2;
	}

	for type_info(Foo).(*Type_Info_Enum).values { // prints None, Both, A, B
		print("Foo %: %\n", it, it.(Foo));
	}
	for type_info(Bar).(*Type_Info_Enum).values { // prints 0, Both, A, B
		print("Bar %: %\n", it, it.(Bar));
	}
}

#import "Basic";
