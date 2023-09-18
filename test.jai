foo :: () -> [$B]u8
#modify {
    // B = 5;    // Error: Type wanted: Type; type given: s64

    // B should by all means be an integer, but okay, let's give it a Type, see what happens!
    B = string;  // Error: The dimension in this array declaration is not an integer. (Its type is Type.)

    return true;
} {
    ret: [B]u8;
    return ret;
}

main :: () {
    c: foo();
}

// #load "sandbox.jai";
