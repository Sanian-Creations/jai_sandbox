tuples :: () {

    // Lets try to use varargs on a struct to make a basic Tuple.

    // This is the naive approach where we print the types as string.
    Naive_Tuple :: struct(types: ..Type) {
        #insert -> string {
            sb: String_Builder;
            for types  print_to_builder(*sb, "_%: %;\n", it_index, it);
            return builder_to_string(*sb);
        }

        /*
            Naive_Tuple(int, string):
            {
                _0: int;
                _1: string;
            }
        */
    }

    Tuple :: struct(types: ..Type)
    #modify { return types.count > 0; }
    {
        #insert -> string {
            sb: String_Builder;
            for types  print_to_builder(*sb, "_%1: types[%1];\n", it_index);
            return builder_to_string(*sb);
        }

        /*
            Since all args to a struct are constant, varargs on a struct are
            not converted to an array view [], but to an actual array [N],
            so you can simply express the types of fields like this:

            Tuple(Foo, Bar):
            {
                _0: types[0]; // just works!
                _1: types[1];
            }
        */

        // #if 1 #run { // enable to see that types is an array [N]
        //     print_expr(types);
        //     print_expr(type_of(types));
        // }
    }

    { // For simple types, the Naive_Tuple and Tuple work the same
        tuple_a: Naive_Tuple(string, int, float, u8);
        print_expr(tuple_a);

        tuple_b: Tuple(string, int, float, u8);
        print_expr(tuple_b);
    }

    { // But when introducing new types, Naive_Tuple falls flat on its face!
        Foo :: struct {f: string;}
        Bar :: struct {b: string;}

        /* uncomment to see an error */
        // naive_foobar_tuple: Naive_Tuple(Foo, Bar);
        // print_expr(naive_foobar_tuple);

        /* this one can handle it, though */
        foobar_tuple: Tuple(Foo, Bar);
        print_expr(foobar_tuple);
    }

    {
        /* The Tuple also has a #modify to verify that you're not making an empty tuple, which is pointless. */
        // nothing_burger: Tuple();
        // print_expr(nothing_burger);
    }
}

tagged_union :: () {
    // Lets try to make a tagged union!
    Tagged_Union_Member :: struct {
        name: string;
        type: Type;
    }

    Tagged_Union :: struct(members: ..Tagged_Union_Member) {
        #insert -> string {
            sb: String_Builder;
            append(*sb, "variant: enum {\n\tNONE :: 0;\n");
            for members print_to_builder(*sb, "\t%;\n", it.name);
            append(*sb, "}\n");
            // Not completely certain why members[n].type is not constant...
            // The fact that we can #run it means that all the info there is known at comptime.
            for members {
                print_to_builder(*sb, "%: #run members[%].type;\n#place %;\n", it.name, it_index, members[0].name);
            }
            return builder_to_string(*sb);
        }

        /*
        Tagged_Union(.{"thinga", int}, .{"majig", string}):
        {
            variant: enum {
                NONE :: 0;
                thinga;
                majig;
            }
            thinga: #run members[0].type;
            #place thinga;
            majig: #run members[1].type;
            #place thinga;
        }
        */
    }

    taggy: Tagged_Union(.{"thinga", int}, .{"majig", string});
    print_expr(taggy);
}


main :: () {
    set_print_style_verbose();
    tuples();
    tagged_union();
}

#load "sandbox.jai";
