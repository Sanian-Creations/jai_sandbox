
// Clearly you can have procedure overloads, but can you have struct overloads?

main :: () {
    wrap1: Wrapper(int);
    // wrap2: Wrapper(string, float);

    write_string("It's not possible to have struct overloads :/\n");
}

Wrapper :: struct(T1: Type) {
    value1: T1;
}
// Wrapper :: struct(T1: Type, T2: Type) {
//     value1: T1;
//     value2: T2;
// }
