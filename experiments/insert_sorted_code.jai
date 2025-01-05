main :: () {
    do_thing();
}

// #run {
//     secret :: "Secret Information Wooo";
//     for cast([]u8) secret print("0x%, ", FormatInt.{value = it, base = 16, minimum_digits = 2});
// }

do_thing :: () {
    the_string :: "..1..2..3..4..5..6..";


    Item :: struct {
        code: Code;
        index: int;
        length: int;
    }

    // secret :: u8.[0x53, 0x65, 0x63, 0x72, 0x65, 0x74, 0x20, 0x49, 0x6e, 0x66, 0x6f, 0x72, 0x6d, 0x61, 0x74, 0x69, 0x6f, 0x6e, 0x20, 0x57, 0x6f, 0x6f, 0x6f];
    // notso_secret :: "Less Secret Information Aww";

    sorted_code :: #run -> []Item {
        // #run write_string(cast(string)secret);
        list: [..]Item;

        register :: (key: string, code: Code) #expand {
            insert_index := String.find_index_from_left(the_string, key);
            assert(insert_index != -1, "The key must be in the template string");

            maybe_grow(*list);
            list.count += 1;
            i := list.count-1;

            while i > 0 && list.data[i-1].index > insert_index {
                list.data[i] = list.data[i-1]; // move item over
                i -= 1;
            }

            assert(list.data[i-1].index != insert_index, "This key was registered twice: %\n", key);
            list.data[i] = .{code = code, index = insert_index, length = key.count};
        }

        register("6", #code { write_string("~F~"); });
        register("4", #code { write_string("~D~"); });
        register("1", #code { write_string("~A~"); });
        register("2", #code { write_string("~B~"); });
        register("5", #code { write_string("~E~"); });
        register("3", #code { write_string("~C~"); });

        return list;
    }

    #insert -> string {
        sb: String_Builder;
        for sorted_code print_to_builder(*sb, "#insert #run sorted_code[%].code;\n", it_index);
        return builder_to_string(*sb);
    }
}

#load "sandbox.jai";

#import "Basic";
String :: #import "String";
