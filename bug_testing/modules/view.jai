/*
Utility procs for making views of arrays and strings.

view      (source, start_index, count)
rview     (source, start_index, end_index)  // end_index is exclusive. result.count is (end_index - start_index).
view_from (source, start_index)

Why not use Basic.array_view?
- Basic.array_view only asserts that start_index and count are not negative, and that's it. If the view wouldn't fit the source array,
  it either truncates the count to fit, or returns an empty view if there's no overlap with the source array at all. I argue this is usually
  unwanted behaviour, silently continuing with an empty view just makes potential bugs harder to find.

What do these procs give you that Basic.array_view does not?
- They assert that the view you ask for fits exactly.
  - The assertion prints out the values that were used, so you know what went wrong.
  - It also asserts at compile time, if any args are constant.
- You can optionally turn off the *runtime* asserts with (check=false).
- Every proc has a *_safe counterpart which returns an ok: bool rather than asserting.
- You can optionally turn on truncation with (trunc=true).
  - Truncation still asserts (0 <= start_index <= source.count), disabling this with (check=false) can potentially result in views with negative count.
- Each proc has an overload for string views. (Basic.array_view can't do this, you need String.slice instead)
- rview     supports an index range (start/end indeces) rather than a start + count.
- view_from supports view-to-end-of-array
*/

// simple view ... [start_index, start_index + count)
view ::      inline ($$source: []$E,   $$start_index := 0, $$count: int, $trunc := false, $check := true, $loc := #caller_location) -> []E    { #insert,scope() view_internal; }
view ::      inline ($$source: [$N]$E, $$start_index := 0, $$count: int, $trunc := false, $check := true, $loc := #caller_location) -> []E    { #insert,scope() view_internal; }
view ::      inline ($$source: string, $$start_index := 0, $$count: int, $trunc := false, $check := true, $loc := #caller_location) -> string { #insert,scope() view_internal; }
view_safe :: inline ($$source: []$E,   $$start_index := 0, $$count: int, $trunc := false, $loc := #caller_location) -> []E,    ok := true #must { #insert,scope() view_safe_internal; }
view_safe :: inline ($$source: [$N]$E, $$start_index := 0, $$count: int, $trunc := false, $loc := #caller_location) -> []E,    ok := true #must { #insert,scope() view_safe_internal; }
view_safe :: inline ($$source: string, $$start_index := 0, $$count: int, $trunc := false, $loc := #caller_location) -> string, ok := true #must { #insert,scope() view_safe_internal; }

// range view ... [start_index, end_index)
rview ::      inline ($$source: []$E,   $$start_index: int, $$end_index: int, $trunc := false, $check := true, $loc := #caller_location) -> []E    { #insert,scope() rview_internal; }
rview ::      inline ($$source: [$N]$E, $$start_index: int, $$end_index: int, $trunc := false, $check := true, $loc := #caller_location) -> []E    { #insert,scope() rview_internal; }
rview ::      inline ($$source: string, $$start_index: int, $$end_index: int, $trunc := false, $check := true, $loc := #caller_location) -> string { #insert,scope() rview_internal; }
rview_safe :: inline ($$source: []$E,   $$start_index: int, $$end_index: int, $trunc := false, $loc := #caller_location) -> []E,    ok := true #must { #insert,scope() rview_safe_internal; }
rview_safe :: inline ($$source: [$N]$E, $$start_index: int, $$end_index: int, $trunc := false, $loc := #caller_location) -> []E,    ok := true #must { #insert,scope() rview_safe_internal; }
rview_safe :: inline ($$source: string, $$start_index: int, $$end_index: int, $trunc := false, $loc := #caller_location) -> string, ok := true #must { #insert,scope() rview_safe_internal; }

// view to the end of the array ... [start_index, source.count)
view_from ::      inline ($$source: []$E,   $$start_index: int, $check := true, $loc := #caller_location) -> []E    { #insert,scope() view_from_internal; }
view_from ::      inline ($$source: [$N]$E, $$start_index: int, $check := true, $loc := #caller_location) -> []E    { #insert,scope() view_from_internal; }
view_from ::      inline ($$source: string, $$start_index: int, $check := true, $loc := #caller_location) -> string { #insert,scope() view_from_internal; }
view_from_safe :: inline ($$source: []$E,   $$start_index: int, $loc := #caller_location) -> []E,    ok := true #must { #insert,scope() view_from_safe_internal; }
view_from_safe :: inline ($$source: [$N]$E, $$start_index: int, $loc := #caller_location) -> []E,    ok := true #must { #insert,scope() view_from_safe_internal; }
view_from_safe :: inline ($$source: string, $$start_index: int, $loc := #caller_location) -> string, ok := true #must { #insert,scope() view_from_safe_internal; }

// I'm using inline instead of #expand because in the case of passing a [$N]$T, a macro copies it to a new address whereas inline doesn't make a copy.

#scope_file

// I'm using #code and #insert,scope() as a kind of macro because I don't want to type `backticks everywhere. I've also noticed that there's some
// overhead with #expand macros, they all do a copy of the arguments that are passed in.

view_internal :: #code {
	#insert,scope() comptime_is_valid_view;
	#if check {
		is_valid := #insert,scope() is_valid_view;
		assert(is_valid, "Couldn't make view [%1, %2) on a source array of size %3\n  Args: start_index = %1, count = %2 (together %3), source.count = %4\n", start_index, count, start_index + count, source.count, loc=loc);
	}
	#insert,scope() return_view;
}
view_safe_internal :: #code {
	#insert,scope() comptime_is_valid_view;
	is_valid := #insert,scope() is_valid_view;
	if !is_valid return .{}, false;
	#insert,scope() return_view;
}

rview_internal :: #code {
	#insert,scope() comptime_is_valid_rview;
	#if check {
		is_valid := #insert,scope() is_valid_rview;
		assert(is_valid, "Couldn't make view [%1, %2) on a source array of size %3\n  Args: start_index = %1, end_index = %2, source.count = %3\n", start_index, end_index, source.count, loc=loc);
	}
	#insert,scope() return_rview;
}
rview_safe_internal :: #code {
	#insert,scope() comptime_is_valid_rview;
	is_valid := #insert,scope() is_valid_rview;
	if !is_valid return .{}, false;
	#insert,scope() return_rview;
}

view_from_internal :: #code {
	#insert,scope() comptime_is_valid_start_index;
	#if check {
		is_valid := #insert,scope() is_valid_start_index;
		assert(is_valid, "Couldn't make view [%1, source.count) on a source array of size %2\n  Args: start_index = %1, source.count = %2\n", start_index, source.count, loc=loc);
	}
	return .{source.count - start_index, start_index + source.data};
}
view_from_safe_internal :: #code {
	#insert,scope() comptime_is_valid_start_index;
	is_valid := #insert,scope() is_valid_start_index;
	if !is_valid return .{}, false;
	return .{source.count - start_index, start_index + source.data};
}

// Validity checks

is_valid_start_index :: #code (start_index >= 0) && (start_index <= source.count);

is_valid_rview :: #code #ifx trunc
	then (start_index >= 0) && (start_index <= end_index) && (start_index <= source.count)
	else (start_index >= 0) && (start_index <= end_index) && (end_index   <= source.count);

is_valid_view :: #code #ifx trunc
	then (start_index >= 0) && (count >= 0) && (start_index         <= source.count)
	else (start_index >= 0) && (count >= 0) && (start_index + count <= source.count);

// Returns

return_view :: #code {
	#if trunc
		then return .{min(count, source.count - start_index), start_index + source.data};
		else return .{count, start_index + source.data};
}

return_rview :: #code {
	#if trunc
		then return .{min(end_index - start_index, source.count - start_index), start_index + source.data};
		else return .{end_index - start_index, start_index + source.data};
}

// Comptime checks

error :: (fmt: string, args: ..Any, can_trunc := false) #expand {
	using,only(compiler_report) _ :: #import "Compiler";
	compiler_report(tprint(fmt, ..args), loc=`loc);
}

comptime_is_valid_start_index :: #code {
	#if is_constant(start_index)
	#if start_index < 0
		#run error("Can't make view. start_index < 0\n  Args: start_index = %", start_index);

    #if is_constant(start_index + source.count)
    #if start_index > source.count
    	#run error("Can't make view. start_index > source.count\n  Args: start_index = %, source.count = %", start_index, source.count);
}

comptime_is_valid_view :: #code {
	#insert,scope() comptime_is_valid_start_index;

	#if is_constant(count)
	#if count < 0
		#run error("Can't make view. count < 0\n  Args: count = %", count);

	#if !trunc && is_constant(count + source.count)
	#if count > source.count
		#run error("Can't make view. count > source.count.\n  Args: count = %, source.count = %", count, source.count);

	#if !trunc && is_constant(start_index + count + source.count)
	#if start_index + count > source.count
		#run error("Can't make view. (start_index + count) > source.count\n  Args: start_index = %, count = % (together %), source.count = %", start_index, count, start_index + count, source.count);
}

comptime_is_valid_rview :: #code {
	#insert,scope() comptime_is_valid_start_index;

	#if is_constant(end_index)
	#if end_index < 0
		#run error("Can't make view. end_index < 0\n  Args: end_index = %", end_index);

	#if is_constant(start_index + end_index)
	#if start_index > end_index
		#run error("Can't make view. start_index > end_index\n  Args: start_index = %, end_index = %", start_index, end_index);

	#if !trunc && is_constant(end_index + source.count)
	#if end_index > source.count
		#run error("Can't make view. end_index > source.count\n  Args: end_index = %, source.count = %", end_index, source.count);
}

#import "Basic";
