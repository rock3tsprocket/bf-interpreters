#!/usr/bin/env python3

from sys import argv, stdin, stderr
cells = bytearray(30000) # Memory (30kb)
dp = 0 # Data pointer
    
try:
    with open(argv[1], "r") as f:
        code = f.read()
except IndexError:
    print("Enter code here:")
    code = stdin.read()
    print("")

stack = [] # Bracket nest stack
jump = [None]*len(code)
ip = 0 # Instruction pointer

if code.count("[") != code.count("]"):
    stderr.write("Error: Brackets are unbalanced\n")
    exit(1)

# totally not taken from https://stackoverflow.com/a/3041005
for i,o in enumerate(code):
    if o=='[':
        stack.append(i)
    elif o==']':
        try:
            jump[i] = stack.pop()
        except IndexError:
            stderr.write("Error: Brackets are unbalanced\n")
            exit(1)
        jump[jump[i]] = i

while ip < len(code):
    match code[ip]:
        case "+":
            cells[dp] = (cells[dp] + 1) % 256
        case "-":
            cells[dp] = (cells[dp] - 1) % 256
        case ">":
            dp+=1
            if dp < -1 or dp > 29999:
                dp -= 30000
        case "<":
            dp-=1
            if dp < -1 or dp > 29999:
                dp += 30000
        case ".":
            print(chr(cells[dp]), end="")
        case ",":
            theinput = input("\nInput: ")
            if theinput != "":
                 cells[dp] = ord(theinput[0])
            else:
                cells[dp] = 0
        case "[":
            if not cells[dp]:
                ip = jump[ip]
        case "]":
            if cells[dp]:
                ip = jump[ip]
                continue
     ip+=1

print("")
