# Brainf\*\*k interpreter in VBS
Yes.

## How to use
1. Open a command prompt window where `bf.vbs` is located.
2. Run `cscript bf.vbs [PATH TO FILE]` where [PATH TO FILE] is the path
to a file that contains Brainf\*\*k code.

## Notes
* `cscript` is required for this interpreter due to its reliance on
WScript.StdOut and WScript.StdIn
* Data pointer over/underflows are handled by wrapping the pointer around.
