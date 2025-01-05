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

	printex(type_info(Whatever).*);
	printex(type_info(My_Enum).*);
	printex(type_of(type_info(int).type));
	printex(type_of(Type_Info_Struct_Member.{}.flags));
}



#load "sandbox.jai";
