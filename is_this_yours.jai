main :: () {

    is_this_yours :: (a: Allocator, ptr: *void) -> bool {
        // (mode: Allocator_Mode, size: s64, old_size: s64, old_memory: *void, allocator_data: *void) -> *void;
        return cast(bool) a.proc(.IS_THIS_YOURS, 0, 0, ptr, a.data);
    }

    dyn_arr1: [..] int;
    dyn_arr2: [..] int;
    dyn_arr2.allocator = temp;

    array_add(*dyn_arr1, 9);
    array_add(*dyn_arr2, 10);

    print("--- is in temp allocator ---\n");
    print("dyn_arr1: %\n", is_this_yours(temp, dyn_arr1.data));
    print("dyn_arr2: %\n", is_this_yours(temp, dyn_arr2.data));

    print("--- is in context.allocator ---\n");
    print("dyn_arr1: %\n", is_this_yours(context.allocator, dyn_arr1.data));
    print("dyn_arr2: %\n", is_this_yours(context.allocator, dyn_arr2.data)); // this used to be a crash because of a missing null-check in default allocator
}

#import "Basic";