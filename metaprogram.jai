#run { #import "Compiler";
    write_string("this metaprogram does nothing\n");
    set_build_options_dc(.{ do_output = false});
}
// Will error when ran, because we're not even setting do_output to false.

/*{
    set_build_options_dc(.{
        do_output = false,
        write_added_strings = false,
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
*/