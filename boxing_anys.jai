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

	printex(a.value_pointer);
	printex(b.value_pointer);
	printex(c.value_pointer);
	printex(d.value_pointer);
	printex(e.value_pointer);
	printex(f.value_pointer);

	printex(a);
	printex(b);
	printex(c);
	printex(d);
	printex(e);
	printex(f);
}

#load "sandbox.jai";