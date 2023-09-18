main :: () {
    wrap1: Wrapper(int);
    // wrap2: Wrapper(string, float);
}

// clearly you can have function overloads, but can you have struct overloads?

Wrapper :: struct(T1: Type) {
    value1: T1;
}

// not possible, rip.
/*
Wrapper :: struct(T1: Type, T2: Type) {
    value1: T1;
    value2: T2;
}
*/
