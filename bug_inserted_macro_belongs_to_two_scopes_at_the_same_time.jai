main :: () {
    foo :: () -> string #expand {
        return 5;                 // Error: Type mismatch. Type wanted: string; type given: s64.
        return "Hello, Sailor!";  // Error: Type mismatch. Type wanted: s64; type given: string.
    }

    insert_this :: ($c: Code) -> s64 {
        #insert c;
        return 0;
    }

    insert_this(foo());
}

#import "Basic";