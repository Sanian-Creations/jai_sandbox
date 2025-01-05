main :: () {
	Basic.print("Hello Sailor!");
}

// neither of these work as of beta-1-081

Basic_as_string :: "Basic";
Basic :: #import Basic_as_string;

sandbox_as_string :: "sandbox.jai";
#load sandbox_as_string;