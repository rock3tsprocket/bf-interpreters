#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sysexits.h>
#include <stdint.h>

int main(int argc, char *argv[]) {
	char *code;
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
	else {
		FILE *fileptr = fopen(argv[1], "r");
		if (!fileptr) {
			fprintf(stderr, "File does not exist\n");
			return EX_UNAVAILABLE;
		}

		fseek(fileptr, 0, SEEK_END);
		filesize = ftell(fileptr);
		fseek(fileptr, 0, SEEK_SET);

		code = malloc(filesize);
		fread(code, filesize, 1, fileptr);
		fclose(fileptr);
	}
	
	uint32_t sp = 0;
	uint32_t stack[filesize];
	uint32_t jump[filesize];

	for (i = 0; i < filesize; i++) {
		/*printf("%d", sp);*/
		if (code[i] == '[') {
			stack[++sp] = i;
			/*printf("%c\n", code[i]);*/
		}
		else if (code[i] == ']') {
			jump[i] = stack[sp--];
			jump[jump[i]] = i;
			/*printf("%d|%c\n", jump[i], code[i]);*/
		}
	}

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
					/*printf("|%d|%d|\n", jump[ip], sizeof(jump)/8);*/
					ip = jump[ip];
				}
				break;
		}

		ip++;
	}
	puts("");
	
	free(code);
	return EX_OK;
}

