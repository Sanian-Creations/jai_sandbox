
main :: () {

	// This is how you can get constants from structs.

	Poly_Struct :: struct($N: int, thing: $T) { }

	Baked_Poly_Struct :: Poly_Struct(35, "What's the deaaal");

	print("%\n", Baked_Poly_Struct.N);
	print("%\n", Baked_Poly_Struct.T);

	// But can you do the same to get constants from baked procedures?
	// The answer is No, unfortunately.
	/*
	poly_proc :: ($N: int, thing: $T) { }

	baked_poly_proc :: #procedure_of_call poly_proc(34, "with airplane food?");

	print("%\n", baked_poly_proc.N);
	print("%\n", baked_poly_proc.T);
	*/
}

#load "sandbox.jai";
