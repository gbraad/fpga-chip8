# FPGA SuperChip #

This is a Verilog implementation of the SuperChip virtual machine. The implementation can execute Chip-8 and SuperChip programs. Hybrids and the Chip-8X and MegaChip extensions are not supported.

The core currently runs on the Digilent Nexys 3 board and the MiST. The MiST is the preferred platform, as it provides an excellent OSD and USB stack, which is much easier to use.

For an introduction to Chip-8 and SuperChip, please see [https://en.wikipedia.org/wiki/CHIP-8](the Chip-8 article on Wikipedia). Another great resource is http://chip8.com/, particularly the [http://chip8.com/downloads/Chip-8%20Pack.zip](pack of all known ROMs) for Chip-8 is handy.