//============= (Key: R=Read, W=Write, D=Double Read/Write) 
// NES Include
//=============
// Memory Map
constant WRAM($0000)          // WRAM        ($0000..$0800)                         2KB/RW
// $0800..$1FFF - WRAM Mirrored To $0800..$1FFF

// PPU Picture Processing Unit Ports
constant REG_PPUCTRL($2000)   // PPU Control Register 1                              1B/W
constant REG_PPUMASK($2001)   // PPU Control Register 2                              1B/W
constant REG_PPUSTATUS($2002) // PPU Status Register                                 1B/R
constant REG_OAMADDR($2003)   // OAM Address Register                                1B/W
constant REG_OAMDATA($2004)   // OAM Data Register                                   1B/RW
constant REG_PPUSCROLL($2005) // PPU Background Scrolling Offset (2 Writes: X, Y)    1B/W D
constant REG_PPUADDR($2006)   // VRAM Address Register (2 Writes: MSB, LSB)          1B/W D
constant REG_PPUDATA($2007)   // VRAM Read/Write Data Register                       1B/RW
// $2008..$3FFF - PPU Ports Mirrored To $2008..$3FFF
constant REG_OAMDMA($4014)    // OAM DMA Hi Register                                 1B/W

// APU Audio Processing Unit Ports
constant REG_APUCTRL1($4000)  // APU Channel 1 (Rectangle) Volume/Decay              1B/W
constant REG_APUSWEEP1($4001) // APU Channel 1 (Rectangle) Sweep                     1B/W
constant REG_APUFREQL1($4002) // APU Channel 1 (Rectangle) Frequency Lo              1B/W
constant REG_APUFREQH1($4003) // APU Channel 1 (Rectangle) Frequency Hi, Length      1B/W

constant REG_APUCTRL2($4004)  // APU Channel 2 (Rectangle) Volume/Decay              1B/W
constant REG_APUSWEEP2($4005) // APU Channel 2 (Rectangle) Sweep                     1B/W
constant REG_APUFREQL2($4006) // APU Channel 2 (Rectangle) Frequency Lo              1B/W
constant REG_APUFREQH2($4007) // APU Channel 2 (Rectangle) Frequency Hi, Length      1B/W

constant REG_APUCTRL3($4008)  // APU Channel 3 (Triangle) Linear Counter             1B/W
constant REG_APUSWEEP3($4009) // APU Channel 3 (Triangle) N/A (-)                    1B/W
constant REG_APUFREQL3($400A) // APU Channel 3 (Triangle) Frequency Lo               1B/W
constant REG_APUFREQH3($400B) // APU Channel 3 (Triangle) Frequency Hi, Length       1B/W

constant REG_APUCTRL4($400C)  // APU Channel 4 (Noise) Volume/Decay                  1B/W
constant REG_APUSWEEP4($400D) // APU Channel 4 (Noise) N/A (-)                       1B/W
constant REG_APUFREQL4($400E) // APU Channel 4 (Noise) Frequency Lo                  1B/W
constant REG_APUFREQH4($400F) // APU Channel 4 (Noise) Frequency Hi, Length          1B/W

constant REG_APUCTRL5($4010)  // APU Channel 5 (DMC) Play Mode & DMA Frequency       1B/W
constant REG_APUDLOAD5($4011) // APU Channel 5 (DMC) Direct Load                     1B/W
constant REG_APUADDR5($4012)  // APU Channel 5 (DMC) Sample Address                  1B/W
constant REG_APULEN5($4013)   // APU Channel 5 (DMC) Sample Length                   1B/W

constant REG_APUCTRL($4015)   // DMC, Length Counter, Channel 1..4 Enable            1B/W
constant REG_APUSTATUS($4015) // DMC/Frame IRQ, Length Counter, Channel 1..4 Status  1B/R

constant REG_APUFRAME($4017)  // Frame Counter: 5-Frames Sequence, Disable Frame IRQ 1B/W

// Controller Ports
constant REG_JOYCTRL($4016)   // Write Data To Both Controllers/Expansion Port       1B/W
constant REG_JOY1($4016)      // Read Data From Controller Port #1 / Expansion Port  1B/R
constant REG_Joy2($4017)      // Read Data From Controller Port #2 / Expansion Port  1B/R

// Further Memory: External Hardware May Contain Further Ports
// $4020 - VS Unisystem Coin Acknowledge
// $4020..$40FF - Famicom Disk System (FDS)
// $4100..$FFFF - Various Addresses Used By Cartridge Mappers

macro NES_PPU_INIT() { // PPU Needs Delay From Boot To Work Fully
  bit REG_PPUSTATUS // Clear VBL Flag IF Set At Reset
  -
    bit REG_PPUSTATUS
    bpl - // ~27384 Cycles Have Passed
  -
    bit REG_PPUSTATUS
    bpl - // ~57165 Cycles Have Passed
}

macro NES_APU_INIT() { // APU Register Setup
  lda #%00001111  // APU Control: Enable Channel 1..4 (Bit 0..3)
  sta REG_APUCTRL // Store To APU Control ($4015)
  ldy #0 // Y Offset = 0
  - // Loop APU Register Copy
    lda +,y     // A = Next Byte To Copy
    sta $4000,y // Store A To APU Register Offset
    iny     // Y++ (Increment Offset)
    cpy #24 // Compare Y Offset To 24
    bne -  // IF (Y Offset != 24) Loop APU Register Copy
    jmp ++ // ELSE GOTO End

  + // 24 Byte APU Register Copy Data
    db $30,$08,$00,$00
    db $30,$08,$00,$00
    db $80,$00,$00,$00
    db $30,$00,$00,$00
    db $00,$00,$00,$00
    db $00,$0F,$00,$40
  + // End
}