main :: () {
	box :: (a: Any) -> Any #expand {
		b: Any;
		b.type = type_info(Any);
		b.value_pointer = *a;
		return b;
	}

	// Even though you can box Anys if you want, the value printed
	// always follows the chain back to the base value

	base_value := 5;

	a: Any = base_value;
	b := box(a);
	c := box(b);
	d := box(c);
	e := box(d);
	f := box(e);
	g := box(f);

	print_expr(a.value_pointer);
	print_expr(b.value_pointer);
	print_expr(c.value_pointer);
	print_expr(d.value_pointer);
	print_expr(e.value_pointer);
	print_expr(f.value_pointer);

	print_expr(a);
	print_expr(b);
	print_expr(c);
	print_expr(d);
	print_expr(e);
	print_expr(f);
}

#load "sandbox.jai";