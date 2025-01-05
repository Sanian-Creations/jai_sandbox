
bugs to write down:
- Error messages do not keep in mind tab len when they underline the thing causing the error,
  it assumes a tab is a single charter long which it is not.
  Note about fixing: Thinking about it, this is actually a non-trivial problem to solve, because not all shells
  display tabs using the same length, in fact you can set the length manually and your program has
  no way to know what it is. So maybe you just want to replace all the tabs in the code snippet
  with spaces to ensure that all characters in it are in a predictable location.
