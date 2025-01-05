main :: () {
	f: Foo;

	if #complete f == {
		// missing cases
	}
}

#insert #string CODE
Foo :: enum {
	NOT_IN_ERROR;
	IN_ERROR      :: 1;
	EXPLICIT      :: 2;
	IMPLICIT;
}
CODE;

/*
The problem here is: the error message will sometimes not mention missing cases in a #complete if-case.
The conditions for this are:
1. the enum must be inserted as a string with #insert
2. some values in the enum must be implicitly declared (auto-increment)

The result is that the enum values that are implicitly declared will not show up in the error message for #complete.
So if you are only missing cases of implicitly declared enum values, you will get an error about missing cases,
but no information about which cases are actually missing.
*/