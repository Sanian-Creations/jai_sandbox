main :: () {
	arr := int.[0,1,2,3,4,5,6,7,8,9];

	v := iview(arr, 3, 7); // [3, 7) = [3, 4, 5, 6]
	print("%\n", v);

	t1 :: View(string);
	t2 :: View([5]u8);
	ti1 := type_info(t1);
	ti2 := type_info(t2);
	print("%\n", t1);
	print("%\n", t2);
	print("%\n", ti1);
	print("%\n", ti2);
	print("%\n", ti1.*);
	print("%\n", ti2.*);
}

#import "Basic";

iview :: inline (arr: $Arr, from := 0, to: int) -> View(Arr).type
#modify is_viewable(Arr)
{
	#if is_constant(0 <= from)       #assert(0 <= from);
	#if is_constant(from <= to)      #assert(from <= to);
	#if is_constant(to <= arr.count) #assert(to <= arr.count);

	assert( (0 <= from) && (from <= to) && (to <= arr.count) );
	v: View(Arr).type = ---;
	v.data  = arr.data + from;
	v.count = to - from;

	return v;
}


// Despite the #type_info_none it still adds new type info to the executable for every polymorph. they are all the same, so they probably shouldn't be separate.
// TODO: Send email about deduplicating for type_info_none.
View :: struct (T: Type) #type_info_none {
	type :: #run get_view_type(T);
}

is_viewable :: (T: Type) #expand {
	ti := cast(*Type_Info) ifx is_pointer_type(T) then get_pointed_at_type(T) else T;
    if ti.type == .ARRAY || ti.type == .STRING {
		`return true;
    } else {
		`return false, "Must pass a string or array type, or pointer to one.";
    }
}

get_view_type :: ($T_in: Type) -> Type {
	T :: #ifx #run is_pointer_type(T_in) then #run get_pointed_at_type(T_in); else T_in;
    #if T == string {
		return string;
	} else #if #run type_info(T).type == .ARRAY {
		Element :: #run get_element_type(T);
		return []Element;
	} else {
	   #assert false "Passed non-viewable type to get_view_type";
	}
}

nth :: #import,file "../jai_sanian/nicetohaves.jai";
using,except(iview) nth;