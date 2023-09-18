main :: () {
	set_print_style_verbose();

	Whatever :: struct {
		a: int;
		b: float64;
	}

	My_Enum :: enum {
		APPLE;
		PEAR;
		CAKE :: 70;
	}

	{
		ti := type_info(Whatever);
		// type_info returns a POINTER, not the struct itself. The structs with the
		// actual information are baked into the executable and stored in readonly mem.

		print_expr(ti.*);
		print_expr(type_of(type_info(int).type));
		print_expr(type_of(Type_Info_Struct_Member.{}.flags));
	}

	{
		ti := type_info(My_Enum);
		print_expr(ti.*);
	}
}



#load "sandbox.jai";