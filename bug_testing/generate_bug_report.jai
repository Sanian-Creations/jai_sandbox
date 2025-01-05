DEBUG :: true;

BUGS_DIR :: "../bugs";

main :: () {
	#if DEBUG set_print_style_verbose();

	run :: (args: ..string) {
		print("---\n");
		result, out_str, err_str, _ := Process.run_command(args = ..args, capture_and_return_output = true);
		printex(result);
		printex(out_str);
		printex(err_str);
		print("---\n");
	}


	// jai compilation:
	// success: exitcode 0, stdout has bunch of stuff, stderr is empty
	// fail:    exitcode 1, stdout is empty, stderr has bunch of stuff


	// run("echo", "hello");
	// run("./hello.exe");
	// run("./return1.exe");
	run("jai", "./generate_bug_report.jai");
	// run("jai", "-version"); // this doesn't work unfortunately, it seems that the output is printed too soon before
	// run("jai", "generate_bug_report.jai");

	// run_command :: (
	// args: .. string,
	// working_directory := "",
	// capture_and_return_output := false,
	// print_captured_output := false,
	// timeout_ms := -1,
	// arg_quoting := Process_Argument_Quoting.QUOTE_IF_NEEDED) ->


	// (process_result: Process_Result, output_string, error_string, timeout_reached_bool)
}

my_main :: () {
    defer report_memory_leaks();

	#if DEBUG set_print_style_verbose();


	QData :: string; // For now, the data we attach to each file is: the filename
	My_Visit_Data :: struct {
		queue: *FA.Queue(QData);
		file_count: int;
	}

	visit_data: My_Visit_Data;
	printex(size_of(type_of(visit_data.queue)));

	{	using visit_data; // odd language quirk here, cannot write `visit_data.queue=, err := blah()` because var= must be a single identifier, not var.field=
		queue=, err := FA.initialize_queue(string);
		assert(err.code == .Success);
	} defer FA.destroy_queue(visit_data.queue);

	visit_proc :: (info: *File_Visit_Info, visit_data: *My_Visit_Data) {
		/* (beta-1-091)
		File_Visit_Info ::
			short_name:             string; // filename
			full_name:              string; // path passed to visit_files + intermediate dirs + filename
			modification_time:      Apollo_Time;
			had_error:              bool; // Whether there was an error when we tried to get all necessary information about the file (eg. due to insuficient perimssions).
			is_symlink:             bool;
			is_directory:           bool;
			descend_into_directory: bool; // Can be modified by the visit procedure to indicate that we shouldn't go into this directory.
		*/

		assert(!info.had_error);

		if !Str.ends_with(info.short_name, ".jai") return;
		if info.is_symlink  return;
		if info.is_directory {
			print("cannot go into dir '%' because dirs are not supported yet\n", info.short_name);
			info.descend_into_directory = false;
			return;
		}

		// printex(info.full_name);
		// printex(info.short_name);


		// @Note: Assume both short_name and full_name get invalidated after all files are visited.
		//        Make a copy if we want to use them.

		// With FA.open_file and FA.read_file we could read a limited amount of data, but the
		// bug repro files are small enough that we don't care if we read the entire file.
		visit_data.file_count += 1;
		FA.read_entire_file(visit_data.queue, info.full_name, user_data = copy_string(info.short_name)); // @Leak filename
	}


	// - synchronously visit all files, then
	// - add those files to the async queue that READS them asynchronously.
	visit_ok := visit_files(dir_name = BUGS_DIR,
		user_data   = *visit_data,
		proc        = visit_proc,
		recursive                 = false,
		visit_files               = true,
		visit_directories         = false,
		visit_symlinks            = false,
		follow_directory_symlinks = false
	);

	assert(visit_ok);

	for 1..visit_data.file_count {
		// (queue: *Queue($T), check_only := false) -> T, data: [] u8, Error
		// T is the userdata, in this case the filename
		file_name, file_content, err := FA.wait_for_completion(visit_data.queue);
		assert(!err.code);
		defer array_free(file_content);
		defer free(file_name);

		#assert type_of(file_name) == string; // if userdata changes then this code breaks

		header := get_header(cast(string) file_content, file_name);
		trim(*header);


		// parse based on the Bug struct
		// only exception is the 'description' field which has special parsing rules

		// printex(header);
	}
}

// reads the first block comment in the file and returns the content
// (assumes the first item in the file is a block comment and not some other declaration)
get_header :: (_file_content: string, filename: string) -> string {
	file_content := _file_content; // immutable annoyance
	advance_while(*file_content, is_whitespace);

	expect(eat(*file_content, "/*"),
		"% doesn't have a proper info header, the very first thing in the file should be a block comment `/*` with information about the bug", filename);

	// consume the whole block comment (keep nested comments in mind)

	i := 0;
	nested_blocks := 1;
	while file_content.count-i >= 2 {
		start := view(file_content, i, 2, trunc = true);
		if start == "/*" {
			nested_blocks += 1;
			i += 1;
		} else if start == "*/" {
			nested_blocks -= 1;
			if nested_blocks <= 0 break;
			i += 1;
		}
		i += 1;
	}
	expect(nested_blocks == 0, "Reached EOF before finding the closing `*/` on the header block comment. Nested block comments: %", nested_blocks);

	return view(file_content, 0, i);
}

// reason we dont use assert is because assert may be stripped in release builds, this should never be stripped
expect :: (condition: bool, fmt: string, args: ..Any) {
	if condition return;
	print(fmt, ..args);
	write_string("\n");
	debug_break();
} @PrintLike

eat :: (str: *string, match: string) -> bool #must {
	if Str.starts_with(str.*, match) {
		advance_unsafe(str, match.count);
		return true;
	} return false;
}
eat :: (str: *string, match: u8) -> bool #must {
	if str.count > 0 && (#no_abc str.*[0]) == match {
		advance_unsafe(str);
		return true;
	} return false;
}

eat_newline :: (str: *string) -> bool #must {
	if eat(str, "\n") return true;
	return eat(str, "\r\n");
}

advance_until :: (str: *string, char: u8) {
	i := 0;
	while i < str.count && (#no_abc str.*[i]) == char { i += 1; }
	advance_unsafe(str, i);
}
advance_until :: (str: *string, $condition: (u8)->bool) {
	i := 0;
	while i < str.count && !inline condition(#no_abc str.*[i]) { i += 1; }
	advance_unsafe(str, i);
}
advance_while :: (str: *string, $condition: (u8)->bool) {
	i := 0;
	while i < str.count && inline condition(#no_abc str.*[i]) { i += 1; }
	advance_unsafe(str, i);
}

advance_unsafe :: inline (str: *string, amount := 1) {
	str.count -= amount;
	str.data  += amount;
}

trim_left :: (str: *string) {
	i := 0;
	while i < str.count && is_whitespace(#no_abc str.*[i]) {
		i += 1;
	}

	str.count -= i;
	str.data  += i;
}

trim_right :: (str: *string) {
	i := str.count - 1;
	while i >= 0 && is_whitespace(#no_abc str.*[i]) {
		i -= 1;
	}

	str.count = i + 1;
}

trim :: (str: *string) {
	trim_left(str);
	trim_right(str);
}

is_whitespace ::   inline (c: u8) -> bool { return c == #char " " || c == #char "\t" || c == #char "\r" || c == #char "\n"; }
is_tab_or_space :: inline (c: u8) -> bool { return c == #char " " || c == #char "\t"; }

Bug :: struct {
	tested:      string;
	type:        Bug_Type;
	status:      Bug_Status;
	related:     []string;
	description: string;
}

Bug_Status :: enum u8 {
	unspecified :: 0;
	fixed;
	still_present;
}
Bug_Type :: enum u8 {
	unspecified :: 0;

	unexpected_behaviour; // The generated code does not do what it is supposed to, or has strange side effects.
	should_not_error;     // Compiler errors when the code should be correct.
	should_not_compile;   // Succesfully compiles when code is actually wrong.
	compiler_terminates;  // Compiler terminates/crashes unexpectedly.
	compiler_hangs;       // Compiler never completes.
	bad_error_message;    // Compiler gives an unhelpful error message.
	in_module;            // Bug is not compiler related, it is in one of the default modules.
}

#if DEBUG {
	set_print_style_verbose :: () {
		using context.print_style.default_format_struct;
		use_long_form_if_more_than_this_many_members = -1;
		use_newlines_if_long_form                    = true;
		draw_type_name                               = true;
	}

	printex :: ($c: Code) #expand {
		print("% is %\n", #run code_to_string(c), #insert c);
	}

	code_to_string :: ($c: Code) -> string #compile_time {
		using _ :: #import "Program_Print";
		using _ :: #import "Compiler";
		sb: String_Builder;
		print_expression(*sb, compiler_get_nodes(c));
		return builder_to_string(*sb);
	}
} else {
    printex :: (#discard $c: Code) #expand {}
}


#scope_file

#import "Basic"()(MEMORY_DEBUGGER = true);
#import "File_Utilities";
Process :: #import "Process";

#import "view";
Str :: #import "String";
FA :: #import "File_Async";
