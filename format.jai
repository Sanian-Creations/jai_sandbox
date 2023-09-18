main :: () {
	set_print_style_verbose_structs();

	// A FormatStruct is a struct that can be passed instead of the struct
	// itself in order to format it in a few different ways. The .value
	// field of the FormatStruct is the actual struct that you want to print.
	// But, if the struct that you want to print is itself a FormatStruct,
	// then you obviously cannot pass it, because it will instead print the
	// thing that is in the .value field. So you have to wrap it in ANOTHER
	// FormatStruct and set ITS .value to the struct that you want to print.

	// Example: Trying to print the value of a formatStruct.

	fmt_struct_to_print := context.print_style.default_format_struct;

	// This does not work, it tries to print .value of the struct, which is null here.
	print("%\n", fmt_struct_to_print);

	// Instead you have to do this:
	print("%\n", FormatStruct.{value = fmt_struct_to_print});

	// However, making a new FormatStruct ignores the default print style
	// from the context. In order to print this thing like any other struct
	// you have to make a copy of the default format struct and set the value
	// of THAT guy to the struct you want printed.
	fmt := context.print_style.default_format_struct;
	fmt.value = fmt_struct_to_print;
	print("%\n", fmt);
}

#import,file "../jai_sanian/nicetohaves.jai";
#import "Basic";