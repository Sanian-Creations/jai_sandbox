/*
tested:  beta-1-085
bug:     unexpected_behaviour
status:  still_present
description:
	Performing pointer arithmetic in the middle of an array-view literal doesn't properly work.
	`string.{count, data + offset}` does the same as `string.{count, data}`, the offset doesn't properly get added.
	This isn't exclusive to string literals, it happens with array view literals like []u8.{ ... } too.
*/

str :: "Hello, Sailor!";

#assert     str.data == str.data + 7;  // succeeds (but shouldn't)
#assert 7 + str.data == str.data + 7;  // succeeds
#assert str.data + 7 ==     str.data;  // succeeds (but shouldn't)
#assert str.data + 7 == 7 + str.data;  // succeeds

// #assert str.data == 7 + str.data;  // fails as it should
// #assert 7 + str.data == str.data;  // fails as it should

main :: () { }

// main :: () {
//     str   :: "Hello, Sailor!";
//     bytes :: cast([14]u8) str;

//     str\ _data_plus_seven := str  .data + 7;
//     bytes_data_plus_seven := bytes.data + 7;
//     seven_plus_str\ _data := 7 + str  .data;
//     seven_plus_bytes_data := 7 + bytes.data;

//    view_1 := string.{7, str  .data + 7};  // wrong
//    view_2 := string.{7, bytes.data + 7};  // wrong
//    view_3 := string.{7, 7 + str  .data};  // ok
//    view_4 := string.{7, 7 + bytes.data};  // ok
//    view_5 := string.{7, str\ _data_plus_seven}; // ok     (Making a variable made a difference here.)
//    view_6 := string.{7, bytes_data_plus_seven}; // wrong  (Still fails. Then why is the one above correct? Does type matter?)
//    view_7 := string.{7, seven_plus_str\ _data}; // ok
//    view_8 := string.{7, seven_plus_bytes_data}; // ok

//     print("string.{7, str  .data + 7}        = \"%\" %\n",  view_1, ifx view_1 != "Sailor!" "(wrong)");
//     print("string.{7, bytes.data + 7}        = \"%\" %\n",  view_2, ifx view_2 != "Sailor!" "(wrong)");
//     print("string.{7, 7 + str  .data}        = \"%\" %\n",  view_3, ifx view_3 != "Sailor!" "(wrong)");
//     print("string.{7, 7 + bytes.data}        = \"%\" %\n",  view_4, ifx view_4 != "Sailor!" "(wrong)");
//     print("string.{7, str\\ _data_plus_seven} = \"%\" %\n", view_5, ifx view_5 != "Sailor!" "(wrong)");
//     print("string.{7, bytes_data_plus_seven} = \"%\" %\n",  view_6, ifx view_6 != "Sailor!" "(wrong)");
//     print("string.{7, seven_plus_str\\ _data} = \"%\" %\n", view_7, ifx view_7 != "Sailor!" "(wrong)");
//     print("string.{7, seven_plus_bytes_data} = \"%\" %\n",  view_8, ifx view_8 != "Sailor!" "(wrong)");
// }

#import "Basic";
