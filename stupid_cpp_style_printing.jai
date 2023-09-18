main :: () {
	// I don't know why I did this.
	out << "Hello World!" << endl;
}

Stupid_Cpp_Style_Printer :: struct {}
Stupid_Cpp_Style_Endl    :: struct {}

out  :: Stupid_Cpp_Style_Printer.{};
endl :: Stupid_Cpp_Style_Endl.{};

operator << :: inline (printer: Stupid_Cpp_Style_Printer, endl: Stupid_Cpp_Style_Endl) -> Stupid_Cpp_Style_Printer {
	write_string("\n");
	return .{};
}
operator << :: inline (printer: Stupid_Cpp_Style_Printer, to_print: Any) -> Stupid_Cpp_Style_Printer {
	print("%", to_print);
	return .{};
}

#import "Basic";