#include <stdio.h>
#include <string.h>
#include <sysexits.h>
#include <stdint.h>

int main(int argc, char *argv[]) {
	// Prepare variables
	uint8_t cells[30000];
	uint16_t dp = 0;
	uint32_t ip = 0;
	uint32_t filesize = 0;
	uint32_t i = 0;
	
	if (!argv[1]) {
		fprintf(stderr, "No file specified.\nTry passing '--help' for help.\n");
		return EX_USAGE;
	}
	else if (!strcmp("--help", argv[1])) {
		printf("Usage: %s [--help] FILE\n", argv[0]);
		return EX_OK;
	}

	// Load file
	FILE *fileptr = fopen(argv[1], "r");
	if (!fileptr) {
		fprintf(stderr, "File does not exist\n");
		return EX_UNAVAILABLE;
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
	for (i = 0; i < filesize; i++) {
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
				printf("Input: ");
				cells[dp] = fgetc(stdin);
				
				/* check if LF */
				if (cells[dp] == 10){
					cells[dp] = 0;
				}
				printf("%d\n", cells[dp]);
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
		}

		ip++;
	}

	puts("");
	return EX_OK;
}

