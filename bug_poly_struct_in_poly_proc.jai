proc :: (a: $T) {
    Foo :: struct(N: int) {
        arr: [N]u8;  // undeclared identifier N???
    }
}

main :: () {
    proc(1);
}
