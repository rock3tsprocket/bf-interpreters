' Copyright 2026 rock3tsprocket
' 
' Redistribution and use in source and binary forms, with or without modification, are permitted
' provided that the following conditions are met:
' 
' 1. Redistributions of source code must retain the above copyright notice, this list of conditions and
' the following disclaimer.
' 
' 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions
' and the following disclaimer in the documentation and/or other materials provided with the
' distribution.
' 
' 3. Neither the name of the copyright holder nor the names of its contributors may be used to
' endorse or promote products derived from this software without specific prior written permission.
' 
' THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS”
' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
' WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
' DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
' FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
' DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
' SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
' CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
' TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
' THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

option explicit

' The Declaration of Variables:tm:
dim   code ' Code
dim   cells(29999) ' Memory (30k)
dim   dp ' Data pointer
dim   ip ' Instruction pointer
dim   i ' Counter for for loops
dim   fs_obj ' Filesystem object
dim   f ' File object


if WScript.Arguments.Count < 1 then
	WScript.StdErr.Write("No file specified.")
	stop
else
	set fs_obj = CreateObject("Scripting.FileSystemObject")
	if fs_obj.FileExists(WScript.Arguments.Item(0)) then
		set f = fs_obj.OpenTextFile(WScript.Arguments.Item(0))
		code = f.ReadAll()
		set f = Nothing
		set fs_obj = Nothing
	else
		WScript.StdErr.Write("File does not exist.")
		stop
	end if
end if
dp = 0
ip = 1
for i=0 to 29999
	cells(i) = 0
next

redim stack(-1) ' Stack for storing nested brackets
dim   jump() ' Jump table
redim jump(Len(code)+1)

for i=1 to Len(code)+1
	if Mid(code, i, 1) = "[" then
		redim preserve stack(UBound(stack)+1)
		stack(UBound(stack)) = i
	elseif Mid(code, i, 1) = "]" then
		jump(i) = stack(UBound(stack))
		redim preserve stack(UBound(stack)-1)
		jump(jump(i)) = i
	end if
next

while ip < Len(code)+1
	select case Mid(code, ip, 1)
			case "+"
				cells(dp) = cells(dp) + 1
				if cells(dp) > 255 then
					cells(dp) = cells(dp) - 256
				end if
			case "-"
				cells(dp) = cells(dp) - 1
				if cells(dp) < 0 then
					cells(dp) = cells(dp) + 256
				end if
			case ">"
				dp = dp + 1
				if dp > 29999 then
					dp = dp - 30000
				end if
			case "<"
				dp = dp - 1
				if dp < 0 then
					dp = dp + 30000
				end if
			case "."
				WScript.StdOut.Write(Chr(cells(dp)))
			case ","
				WScript.StdOut.WriteBlankLines(1)
				WScript.StdOut.Write("Input: ")
				cells(dp) = Asc(WScript.StdIn.Read(1))
				WScript.StdOut.WriteBlankLines(1)
			case "["
				if cells(dp) = 0 then
					ip = jump(ip)
				end if
			case "]"
				if cells(dp) <> 0 then
					ip = jump(ip)-1
				end if
	end select
	
	ip = ip+1
wend
