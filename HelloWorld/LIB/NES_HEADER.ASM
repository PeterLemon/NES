//=============
// iNES Header
//=============
// iNES Header String (3 Byte ASCII String, "NES")
db "NES"

// iNES Header Byte (Should Contain The Value $1A)
db $1A

// PRG-ROM SIZE (Number Of 16KB PRG-ROM Banks)
db $02
// $01 = 1 Bank  =  16KB, $09 =  9 Banks = 144KB
// $02 = 2 Banks =  32KB, $0A = 10 Banks = 160KB
// $03 = 3 Banks =  48KB, $0B = 11 Banks = 176KB
// $04 = 4 Banks =  64KB, $0C = 12 Banks = 192KB
// $05 = 5 Banks =  80KB, $0D = 13 Banks = 208KB
// $06 = 6 Banks =  96KB, $0E = 14 Banks = 224KB
// $07 = 7 Banks = 112KB, $0F = 15 Banks = 240KB
// $08 = 8 Banks = 128KB, $10 = 16 Banks = 256KB

// CHR-ROM SIZE (Number Of 8KB CHR-ROM Banks)
db $01
// $01 = 1 Bank  =  8KB, $09 =  9 Banks =  72KB
// $02 = 2 Banks = 16KB, $0A = 10 Banks =  80KB
// $03 = 3 Banks = 24KB, $0B = 11 Banks =  88KB
// $04 = 4 Banks = 32KB, $0C = 12 Banks =  96KB
// $05 = 5 Banks = 40KB, $0D = 13 Banks = 104KB
// $06 = 6 Banks = 48KB, $0E = 14 Banks = 112KB
// $07 = 7 Banks = 56KB, $0F = 15 Banks = 120KB
// $08 = 8 Banks = 64KB, $10 = 16 Banks = 128KB

// ROM Control Byte 1
db $00
// Bit 0 - Type Of Mirroring Used (0 = Horizontal, 1 = Vertical)
// Bit 1 - Battery-Backed RAM At Memory Locations $6000..$7FFF
// Bit 2 - 512-Byte Trainer At Memory Locations $7000..$71FF
// Bit 3 - Overrides Bit 0 With Four-Screen Mirroring
// Bit 4..7 - Mapper Number Low 4-Bits

// ROM Control Byte 2
db $00
// Bits 0..3 - Reserved For Future Use (Should Be 0)
// Bits 4..7 - Mapper Number High 4-Bits

// RAM SIZE (Number Of 8KB RAM Banks)
db $00
// $00 =  8KB, $04 = 40Kb
// $01 = 16Kb, $05 = 48Kb
// $02 = 24Kb, $06 = 56Kb
// $03 = 32Kb, $07 = 64Kb

// Reserved For Future Use (Should All Be 0)
fill 7 // Fill 7 Zero Bytes