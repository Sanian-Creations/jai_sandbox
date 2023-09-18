Thing :: struct { value: int; }

main :: () {
    operator + :: (a: Thing, b: Thing) -> Thing {
        write_string("Correct operator\n");
        return .{ a.value + b.value };
    }

    a, b: Thing = .{9}, .{10};

    #insert  #code something := a + b;             // Correct operator  (#insert is in the same scope as operator +)
    insert1( #code { something := a + b; }      ); // Correct operator  (code is a block, not a statement)
    insert1( #code something := operator+(a, b) ); // Correct operator  (operator is called as a proc, and procs are resolved correctly)
    insert1( #code something := a + b           ); // Wrong operator    (code is a statement AND the #insert is in different scope)
    insert2( #code something := a + b           ); // Error: Attempt to use the binary operator '+', which is not defined in this scope
}

insert1 :: (c: Code) #expand {
    operator + :: (a: Thing, b: Thing) -> Thing {
        write_string("Wrong operator\n");
        return .{ a.value + b.value + 2 };
    }

    // This scope contains a different operator +
    #insert c;
}

insert2 :: (c: Code) #expand {
    // This scope contains no operator +
    #insert c;
}