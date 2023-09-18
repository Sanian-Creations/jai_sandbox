main :: () {

    // 044_using_advanced mentions that with using,map you can return strings which
    // contain characters that are not normally allowed in identifiers. What if I
    // use + or - or other operators, since that is how operators are named when
    // you inspect the procedures.

    Foo :: struct {
        add :: (f1: Foo, f2: Foo) -> Foo {
            return .{};
        }
    }

    a, b: Foo;

    {
        operator + :: Foo.add;
        print("with normal operator + it's %\n", a + b);
    }

    {
        using Foo;
        print("with using Foo, then add() it's %\n", add(a, b));
    }

    {
        my_map :: (names: [] string) {
            for * names {
                if it.* == "add"  it.* = "+";
            }
        }
        using,map(my_map) Foo;
        // print("with using,map it's %\n", a + b));

        // this doesn't work. And that's probably for the better.
    }


}

#import "Basic";