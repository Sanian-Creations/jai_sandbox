/*

You can use this metaprogram like this:

	jai metaprogram.jai

But also like this:

	jai -- import_dir . meta metaprogram

With the first option you can see how this metaprogram is itself being built by the Default_Metaprogram, because the value of this workspace is 2.
Only with the second option are we truly ONLY running this metaprogram.

*/

#run {
	set_build_options_dc(.{
		do_output = false,
		write_added_strings = false, // this stops generation of added_strings_w*.jai for this workspace.
	});
	set_print_style_verbose();

	this_workspace         := get_current_workspace();
	name_of_this_workspace := get_name(this_workspace);
	options                := get_build_options();

	printex(        this_workspace );
	printex(type_of(this_workspace));
	printex(name_of_this_workspace );




	w := compiler_create_workspace("Target Program");
	target_options := get_build_options(w);
	target_options.output_executable_name = "target";
	set_build_options(target_options, w);


	compiler_begin_intercept(w);

	add_build_file(tprint("%/scratch.jai", #filepath), w);  // @Cleanup: Fix this to not require #filepath.

	while 1 {
		msg := compiler_wait_for_message();
		if msg.kind == .COMPLETE break;
	}

	compiler_end_intercept(w);

	print("\nend of build program\n");
	return;
}

#import "Compiler";
#load "sandbox.jai";
