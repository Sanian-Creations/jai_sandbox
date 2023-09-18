
main :: () {
    print("huh!\n");
    // Basic is imported within not_used, but it still yoinked
    // everything into the aplication scope.

    str :: "whatever man";
    // found, a, b := Str.split_from_left(str, "er ");
    // print("%|%\n", a, b);
}

not_used :: () {
    #import "Basic"; // does not import into proc scope, but into application scope!
    Str :: #import "String"; // imports into this var, which is only in this scope
}
