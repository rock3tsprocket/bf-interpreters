# Brainf\*\*k interpreter in C

## Building

### Dependencies
- A standard C library
- C99 compiler or later
- POSIX-compliant environment i think

### Build configuration
You can configure your libcrazy build to use a different compiler or ar, or a cross-compiler:
- AR: Defaults to `${CROSS_COMPILE}ar`, specifies which ar the build should use.
- CC: Defaults to `${CROSS_COMPILE}cc`, specifies which compiler the build should use.
- CFLAGS: Defaults to `-g -O2`, specifies C compiler arguments.
- CROSS\_COMPILE: Defaults to nothing, specifies cross-compiler prefix.
- LDFLAGS: Defaults to nothing, specifies linker flags.
- PREFIX: Defaults to `/usr/local`, specifies installation prefix for libcrazy.

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
