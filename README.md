# Brainf\*\*k interpreter in C

## Extensions to vanilla Brainf\*\*k
This interpreter adds a new command to the language: '!'. With it, you can call
any syscall that your system provides (as long as it has a syscall() function
and it doesn't take any (const) char* arguments).

To use it, one must increment the value pointed to by the data pointer to the
syscall number, then for each argument increment the data pointer and the
values pointed to by it, then run the '!' command.

## Building

### Dependencies
- A standard C library
- C99 compiler or later
- POSIX-compliant environment i think

### Build configuration
You can configure the build to use a different compiler or ar, or a cross-compiler:
- CC: Defaults to `${CROSS_COMPILE}cc`, specifies which compiler the build should use.
- CFLAGS: Defaults to `-g -O2`, specifies C compiler arguments.
- CROSS\_COMPILE: Defaults to nothing, specifies cross-compiler prefix.
- LDFLAGS: Defaults to nothing, specifies linker flags.
- PREFIX: Defaults to `/usr/local`, specifies installation prefix for the interpreter.

Examples:

- Regular build:
```
$ make
```
- Cross-compiling for GNU/Linux on ARMv7-A with -O3 optimizations:
```
$ make CROSS_COMPILE=arm-linux-gnueabihf- CC=arm-linux-gnueabihf-gcc CFLAGS="-O3"
```

### Installation
Examples:

- Regular installation (to /usr/local):
```
# make install
```

- Installation to /usr:
```
# make PREFIX=/usr install
```
