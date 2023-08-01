# Software

This contains all the software demos I wrote for this system. "Menu" combined the ROM images of all three demos into one, and displays a program selection on boot.

## Build instructions

Two softwares need to be obtained first, and their executables placed into this, the `Software`, directory.

The first is [hex2bin](https://hex2bin.sourceforge.net/). You need to download the executable from this website, as the version of the program installed by package managers like apt is often incompatible with my build scripts.

The second is the assembler from [libasm](https://github.com/tgtakaoka/libasm). The `make cli` target builds an executable named `asm`, which also needs to be placed here.

There are scripts written in Java to help build the final ROM images, which may need to be compiled first using javac.
After this, the build.sh scripts can be run. `conv_[programname].bin` is the image file that can be put onto the serial ROMs, except with the `Menu` program, which generates a final image file called `menu_all.bin`.
