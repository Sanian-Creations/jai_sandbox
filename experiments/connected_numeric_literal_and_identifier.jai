
main :: () {

	// The general consensus on Discord is that this is a bug.
	// But I sent Jon an email and his opinion is that it's not so yea

	foo, oo, yz, xyz, abc, x_yz: int;

	if  0 == 0foo   = 1;  assert(1 == foo);  // literal 0    identifier foo
	if  0 == 0_foo  = 2;  assert(2 == foo);  // literal 0_   identifier foo
	if  0 == 0_0foo = 3;  assert(3 == foo);  // literal 0_0  identifier foo
	if 15 == 0xfoo  = 4;  assert(4 == oo);   // literal 0xf  identifier oo
	if  0 == 0xyz   = 5;  assert(5 == yz);   // literal 0x   identifier yz
	if  0 == 0abc   = 6;  assert(6 == abc);  // literal 0    identifier abc
	if  1 == 1xyz   = 7;  assert(7 == xyz);  // literal 1    identifier xyz
	if  0 == 0x_yz  = 8;  assert(8 == yz);   // literal 0x_  identifier yz
	if  1 == 1x_yz  = 9;  assert(9 == x_yz); // literal 1    identifier x_yz

	print("Program end\n");
}

#load "sandbox.jai";