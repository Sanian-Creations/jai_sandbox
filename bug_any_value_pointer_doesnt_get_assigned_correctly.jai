
// This bug was found by U0
// .u0 on Discord.

main :: () {
    i : int = 27;

    // These should all have the same address for value pointer, but they don't. Not unless you manually get a pointer to i.
    any_1 : Any = i;
    any_2 : Any = i;
    any_3 : Any = i;

    // { p := *i; } // completely arbitrary use of the pointer, comment/uncomment this line to change the outcome of the code below.

    print("any_1 address: %\n", any_1.value_pointer);
    print("any_2 address: %\n", any_2.value_pointer);
    print("any_3 address: %\n", any_3.value_pointer);

    print("\naddresses are the same: %\n\n", any_1.value_pointer == any_2.value_pointer && any_2.value_pointer == any_3.value_pointer);

    print("before...\n");
    print("%\n", any_1);
    print("%\n", any_2);
    print("%\n", any_3);

    // assigning through the value pointer will not work properly if the line dereferencing i is commented out.
    (cast(*int) any_1.value_pointer).* = 5;

    print("after...\n");
    print("%\n", any_1);
    print("%\n", any_2);
    print("%\n", any_3);
}

#import "Basic";