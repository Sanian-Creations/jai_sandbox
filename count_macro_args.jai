main :: () {
	a, b, c: int;
	get_num_args(a, b, c);

	get_num_args(a, b, c, 4);

	get_num_args_2(.[a, b, c, 4]);
}

get_num_args :: (args: ..int, $call := #caller_code) #expand {

	// Convoluted way to get the number of arguments as a constant, requires an additional parameter $call
	num_args :: #run -> int {
		#import "Compiler";
		#import "Basic";
		proc_call := cast(*Code_Procedure_Call) compiler_get_nodes(call);
		return proc_call.arguments_unsorted.count;
	};

	print("num args is %\n", num_args);
}

get_num_args_2 :: (args: [$N]Any) {
	// doing this is way easier but slightly more syntax to call
	print("N is %\n", N);
}


