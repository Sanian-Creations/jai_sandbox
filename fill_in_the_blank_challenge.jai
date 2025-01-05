
// -- Challenge --
// Can you find 2 inputs to fill_in_the_blank() that allow this program to compile and run successfully?

main :: () {
	fill_in_the_blank("", "");
	print("Challenge complete!\n");
}
fill_in_the_blank :: ($inputA: string, $inputB: string) {
	A1 :: #insert inputA;
	A2 :: #insert inputA;

	B1 := #insert inputB;
	B2 := #insert inputB;

	#assert type_of(A1) != type_of(B1);

	#assert A1 != A2;
	assert(B1 != B2);
}
#import "Basic";

answer :: "\x66\x69\x6c\x6c\x5f\x69\x6e\x5f\x74\x68\x65\x5f\x62\x6c\x61\x6e\x6b\x28\x22\x23\x74\x79\x70\x65\x2c\x64\x69\x73\x74\x69\x6e\x63\x74\x20\x69\x6e\x74\x3b\x22\x2c\x20\x22\x2a\x63\x61\x73\x74\x28\x5b\x31\x5d\x69\x6e\x74\x29\x2e\x5b\x31\x5d\x3b\x22\x29\x3b\x0a";
