# OS Playground

Stuff I wrote while following the ["Writing a simple Operating System"](http://www.cs.bham.ac.uk/~exr/lectures/opsys/10_11/lectures/os-dev.pdf) lecture by Nick Blundell.

## Running

Run `build.sh` (nasm required). To actually run the "OS" I used bochs with the included configuration (`bochsrc.txt`). Building and running looks something like this for me:

    ./build.sh && bochs -q

And then press `c` for bochs to start execution.
