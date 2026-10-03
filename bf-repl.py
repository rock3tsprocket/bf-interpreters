#!/usr/bin/env python3

from sys import argv, stdin, stderr, stdout
cells = bytearray(30000) # Memory (30kb)
dp = 0 # Data pointer

while True:
    try:
        code = input("> ")
    except EOFError:
        exit(0)
    except KeyboardInterrupt:
        code = ""

    stack = [] # Bracket nest stack
    jump = [None]*len(code)
    ip = 0 # Instruction pointer
    input_ptr = 0

    if code.count("[") != code.count("]"):
        stderr.write("Error: Brackets are unbalanced\n")
        continue

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

    try:
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
                    if input_ptr == 0 or input_ptr >= len(theinput):
                        try:
                            theinput = input("\nInput: ")
                        except EOFError:
                            theinput = "\0"
                        except KeyboardInterrupt:
                            break
                        input_ptr = 0
                    cells[dp] = ord(theinput[input_ptr])
                    input_ptr += 1
                case "[":
                    if not cells[dp]:
                        ip = jump[ip]
                case "]":
                    if cells[dp]:
                        ip = jump[ip]
                        continue
            ip+=1
    except KeyboardInterrupt:
        break

    print("")
