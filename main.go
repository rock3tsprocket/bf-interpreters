package main;
import (
	"fmt"
	"os"
);

func main() {
	var input = "";
	// Check args
	if len(os.Args) < 2 {
		fmt.Fprintf(os.Stderr, "No file specified\n");
		os.Exit(1);
	} else if len(os.Args) > 2 {
		input = os.Args[2];
	}
	input += string(0);
	var inputptr = 0;

	// Prepare variables
	var cells[30000] int;
	var dp = 0;
	var ip = 0;
	
	// Read code
	var code, err = os.ReadFile(os.Args[1]);
	if err != nil {
		panic(err);
	}

	// Prepare jump table
	var sp = 0;
	var stack = make([]int, len(code));
	var jump = make([]int, len(code));
	for i := 0; i < len(code); i++ {
		if code[i] == '[' {
			sp++;
			stack[sp] = i;
		} else if code[i] == ']' {
			jump[i] = stack[sp];
			sp--;
			jump[jump[i]] = i;
		}
	}

	// Main loop
	for ip := ip; ip < len(code); ip++ {
		switch code[ip] {
		case '+':
			cells[dp]++;
			if cells[dp] > 255 {
				cells[dp] -= 255;
			}
			break;
		case '-':
			cells[dp]--;
			if cells[dp] < 0 {
				cells[dp] += 255;
			}
			break;
		case '>':
			dp++;
			if dp > 29999 {
				dp -= 30000;
			}
			break;
		case '<':
			dp--;
			if dp < 0 {
				dp += 30000;
			}
		case '.':
			fmt.Printf("%c", cells[dp]);
			break;
		case ',':
			cells[dp] = int(input[inputptr]);
			inputptr++;
			break;
		case '[':
			if cells[dp] == 0 {
				ip = jump[ip];
			}
			break;
		case ']':
			if cells[dp] != 0 {
				ip = jump[ip];
			}
		}
	}
	fmt.Println("");
}
