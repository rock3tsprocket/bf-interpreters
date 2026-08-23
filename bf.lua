--[[Copyright 2026 rock3tsprocket

Redistribution and use in source and binary forms, with or without modification, are permitted
provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and
the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions
and the following disclaimer in the documentation and/or other materials provided with the
distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to
endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS”
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.]]

if arg[1] == nil then
	print("No file was specified")
	os.exit(1)
end
f = assert(io.open(arg[1], "r"))
code = f:read("*all")
assert(f:close())

codelen = string.len(code) -- Length of code
dp = 0 -- Data pointer
ip = 0 -- Instruction pointer

--Doing cell things
cells = {}
for i=0,29999 do
	cells[i] = 0
end

-- Jump table
stack = {}
stacksize = 0
jumptable = {}
for i=0, codelen do
	jumptable[i] = 0
end
for i=1, codelen do
	if string.sub(code, i, i) == "[" then
		table.insert(stack, i)
		stacksize = stacksize + 1
	elseif string.sub(code, i, i) == "]" then
		jumptable[i] = table.remove(stack, stacksize)
		stacksize = stacksize - 1
		jumptable[jumptable[i]] = i
	end
end

-- Main loop
while ip <= codelen do
	if string.sub(code, ip, ip) == "+" then
		cells[dp] = (cells[dp] + 1) % 256
	elseif string.sub(code, ip, ip) == "-" then
		cells[dp] = (cells[dp] - 1) % 256
		if cells[dp] <= -1 then
			cells[dp]=cells[dp]+256
		end
	elseif string.sub(code, ip, ip) == "." then
		io.stdout:write(string.char(cells[dp]))
        io.stdout:flush()
	elseif string.sub(code, ip, ip) == "," then
		io.stdout:write("Input: ")
		input = io.stdin:read()
		if input ~= "" then
			cells[dp] = string.byte(string.sub(input, 1, 1))
		else
			cells[dp] = 0
		end

	elseif string.sub(code, ip, ip) == ">" then
		dp = (dp + 1) % 30000
	elseif string.sub(code, ip, ip) == "<" then
		dp = (dp - 1) % 30000
	elseif string.sub(code, ip, ip) == "[" and cells[dp] == 0 then
		ip = jumptable[ip]
	elseif string.sub(code, ip, ip) == "]" and cells[dp] ~= 0 then
		ip = jumptable[ip]
	end

	ip = ip + 1
end
