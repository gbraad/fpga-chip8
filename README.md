# FPGA SuperChip #

This is a Verilog implementation of the SuperChip virtual machine. The implementation can execute Chip-8 and SuperChip programs. Hybrids, the Chip-8X and MegaChip extensions are not supported.

The core currently runs on the Digilent Nexys 3 board and the MiST. The MiST is the preferred platform, as it provides an excellent OSD and USB stack, which is much easier to use.

For an introduction to Chip-8 and SuperChip, please see [https://en.wikipedia.org/wiki/CHIP-8](the Chip-8 article on Wikipedia). Another great resource is http://chip8.com/, particularly the [http://chip8.com/downloads/Chip-8%20Pack.zip](pack of all known ROMs) for Chip-8 is handy.

SuperChip has traditionally been implemented as a virtual machine, but this is a pure Verilog implementation of the CPU, display and blitter. The CPU runs at a user selectable speed of a whopping 5 kHz or 12.5 kHz. An instruction usually takes 5 cycles, some a bit longer. The blitter runs at a much faster clock rate than the CPU, 50 MHz on the MiST, so sprite and scroll instructions only add a couple of cycles, if any.

This project was a learning project for me, the purpose was to learn more about FPGA's, digital design and Verilog. I learned a lot from it, but I would suggest you don't use the source for learning :) The source don't always use the established best practices, but I'm probably not going to spend too much time on polishing it from now on. I have accomplished what I set out to do with this project and bigger and better things await.

# Instructions for MiST #

Press F12 to bring up the OSD. From here you can select a .CH8-file to load.

The Chip-8 screen aspect is 2:1 which doesn't really fit on either a 4:3 or 16:9, you can select the type of screen you're using to view the output and the core will scale the output accordingly.

The menu also allows the CPU speed to be selected. Some games are better played on slow, some on fast.

The Chip-8 machine has a hex keypad for input. This has been mapped to the PC keyboard as follows:

`
Chip-8:   PS/2:
1 2 3 C   1 2 3 4
4 5 6 D   Q W E R
7 8 9 E   A S D F
A 0 B F   Z X C V
`