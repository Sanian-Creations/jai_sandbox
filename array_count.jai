main :: (){
	arr      : [3] int;
	arr_view : [] int;

	print_expr(is_constant(arr.count)); // seems like a member, but is a constant.
	print_expr(is_constant(arr_view.count)); // actually a member variable.
}

#load "sandbox.jai";