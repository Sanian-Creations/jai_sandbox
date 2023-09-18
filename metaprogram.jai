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

    print_expr(        this_workspace );
    print_expr(type_of(this_workspace));
    print_expr(name_of_this_workspace );
}

#import "Compiler";
#load "sandbox.jai";
