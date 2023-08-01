# Emulator

This is a software emulator of the SBC written in C# using the .NET framework. Before use, the bootloader first needs to be built, and its binary `boot.bin` copied to this directory.

Afterwards, the emulator can be used via the command line: `dotnet run [path to SPI ROM image]`
