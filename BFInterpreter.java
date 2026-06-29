/* Copyright 2026 rock3tsprocket
*
* Redistribution and use in source and binary forms, with or without modification, are permitted
* provided that the following conditions are met:
*
* 1. Redistributions of source code must retain the above copyright notice, this list of conditions and
* the following disclaimer.
*
* 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions
* and the following disclaimer in the documentation and/or other materials provided with the
* distribution.
*
* 3. Neither the name of the copyright holder nor the names of its contributors may be used to
* endorse or promote products derived from this software without specific prior written permission.
* 
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS “AS IS”
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
* WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
* TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
* THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.InputStreamReader;
import java.io.IOException;

public class BFInterpreter {
    public static void main(String[] args) {
        if (args.length == 0) {
            System.err.println("Error: No file specified");
            System.exit(1);
        }

        // Prepare variables
        String code = "";
        short[] memory = new short[30000];
        for (int i=0; i < 30000; i++) memory[i] = 0;
        int dp = 0; // Data pointer
        int ip = 0; // Instruction pointer
        
        // Read code from file
        File fobj = new File(args[0]);
        
        try (Scanner fobj_scanner = new Scanner(fobj)) {
            while (fobj_scanner.hasNextLine()) {
                code += fobj_scanner.nextLine();
            }
        } catch (FileNotFoundException e) {
            System.err.println("Error: File not found");
            e.printStackTrace();
            System.exit(1);
        }
        
        // Initialize jump table
        int sp = 0; // Stack pointer
        int stack[] = new int[code.length()];
        int jump[] = new int[code.length()];
        for (int i=0; i < code.length(); i++) {
            if (code.charAt(i) == '[') {
                stack[++sp] = i;
            }
            else if (code.charAt(i) == ']')  {
                jump[i] = stack[sp--];
                jump[jump[i]] = i;
            }
        }
        

        // Initialize input stream reader for user input
        InputStreamReader input = new InputStreamReader(System.in);

        // Main loop
        while (ip < code.length()) {
            if (code.charAt(ip) == '+') {
                memory[dp]++;
                if (memory[dp] > 255) memory[dp] -= 256;
            }
            else if (code.charAt(ip) == '-') {
                memory[dp]--;
                if (memory[dp] < 0) memory[dp] += 256;
            }
            else if (code.charAt(ip) == '>') {
                dp++;
                if (dp > 29999) dp -= 30000;
            }
            else if (code.charAt(ip) == '<') {
                dp--;
                if (dp < 0) dp += 30000;
            }
            else if (code.charAt(ip) == ',') {
                System.err.print("Input: ");
                short input_char = 0;

                try {
                    input_char = (short)input.read();
                } catch (IOException e) {
                    e.printStackTrace();
                    System.exit(1);
                }

                if (input_char == -1) input_char = 0;
                memory[dp] = input_char;
            }
            else if (code.charAt(ip) == '.') {
                System.out.print((char)memory[dp]);
            }
            else if (code.charAt(ip) == '[') {
                if (memory[dp] == 0) ip = jump[ip];
            }
            else if (code.charAt(ip) == ']') {
                if (memory[dp] != 0) ip = jump[ip];
            }
        ip++;
        }
        System.out.println("");

        // why do i have to handle every single exception
        try {
            input.close();
        } catch (IOException e) {
            e.printStackTrace();
            System.exit(1);
        }
    }
}
