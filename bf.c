#include <stdio.h>
#include <string.h>
#include <stdint.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
	// Prepare variables
	uint8_t  cells[30000];
	uint16_t dp = 0;
	uint32_t ip = 0;
	uint32_t filesize = 0;
	
	if (!argv[1]) {
		fprintf(stderr, "No file specified.\nTry passing '--help' for help.\n");
		return 1;
	}
	else if (!strcmp("--help", argv[1])) {
		printf("Usage: %s [--help] FILE\n", argv[0]);
		return 0;
	}

	// Load file
	FILE *fileptr = fopen(argv[1], "r");
	if (!fileptr) {
		fprintf(stderr, "File does not exist\n");
		return 1;
	}

	fseek(fileptr, 0, SEEK_END);
	filesize = ftell(fileptr);
	fseek(fileptr, 0, SEEK_SET);
	char code[filesize];
	fread(code, filesize, 1, fileptr);
	fclose(fileptr);
	
	// Prepare jump table
	uint32_t sp = 0;
	uint32_t stack[filesize];
	uint32_t jump[filesize];
	for (int i = 0; i < filesize; i++) {
		if (code[i] == '[') {
			stack[++sp] = i;
		}
		else if (code[i] == ']') {
			jump[i] = stack[sp--];
			jump[jump[i]] = i;
		}
	}
	
	// Main loop
	while (ip < filesize) {
		switch (code[ip]) {
			case '+':
				cells[dp]++;
				break;
			case '-':
				cells[dp]--;
				break;
			case '>':
				dp++;
				break;
			case '<':
				dp--;
				break;
			case '.':
				printf("%c", cells[dp]);
				break;
			case ',':
				printf("Input (Ctrl + D for EOF): ");
				cells[dp] = fgetc(stdin);
				puts("");
				break;
			case '[':
				if (!cells[dp]) {
					ip = jump[ip];
				}
				break;
			case ']':
				if (cells[dp]) {
					ip = jump[ip];
				}
				break;
			case '!':
				// Will not bother to get this working for syscalls
				// that take a const char* argument
				/*for (int i=dp+1; cells[i] != 0; i++) {
					printf("%c", cells[i]);
				}*/
				printf("Result of syscall %d: %d\n", cells[dp], syscall(cells[dp], cells[dp+1], cells[dp+2],
					cells[dp+3], cells[dp+4], cells[dp+5]));
				break;
		}

		ip++;
	}

	puts("");
	return 0;
}

