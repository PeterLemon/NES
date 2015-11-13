// NES Twinkle 4 Channel Song Demo by krom (Peter Lemon):
arch nes.cpu
output "Twinkle4Channel.nes", create

include "LIB\NES_HEADER.ASM" // Include Header

macro seek(variable offset) {
  origin (((offset & $7F0000) >> 1) | (offset & $7FFF)) + 16
  base offset
}

// PRG BANK 0..1 (32KB)
seek($8000); fill $8000 // Fill PRG Bank 0..1 With Zero Bytes
include "LIB\NES.INC"        // Include NES Definitions
include "LIB\NES_VECTOR.ASM" // Include Vector Table
include "LIB\NES_APU.INC"    // Include APU Definitions & Macros

seek($8000); Start:
  NES_APU_INIT() // Run NES APU Initialisation Routine

LoopSong:
  ldx #0 // X = Song Offset

  APUCHAN1: // APU Channel 1
    ldy SONGCHAN1,x // Y = Channel 1: Period Table Offset
    cpy #REST   // Compare Y T0 REST Character ($FF)
    beq KEYOFF1 // IF (Y == REST) Channel 1: Key OFF

    // ELSE Channel 1: Key ON
    lda PeriodTable,y // A = Channel 1: Frequency Lo
    sta REG_APUFREQL1 // Store Channel 1: Frequency Lo ($4002)

    iny // Y++ (Increment Period Table Offset)
    lda PeriodTable,y // A = Channel 1: Frequency Hi (Bits 0..3)
    sta REG_APUFREQH1 // Store Channel 1: Frequency Hi ($4003)

    lda #%10111111  // Channel 1: Volume = $F (Bits 0..3), Fixed Volume (Bit 4), Enable Looping (Bit 5), Duty Cycle 50% (Bits 6..7)
    jmp APUCHAN1End // GOTO APU Channel 1 End

    KEYOFF1: // Channel 1: Key OFF
      lda #%10011111 // Channel 1: Volume = $F (Bits 0..3), Fixed Volume (Bit 4), Disable Looping (Bit 5), Duty Cycle 50% (Bits 6..7)

    APUCHAN1End:
      sta REG_APUCTRL1 // Store Channel 1: Control ($4000)

  APUCHAN2: // APU Channel 2
    ldy SONGCHAN2,x // Y = Channel 2: Period Table Offset
    cpy #REST   // Compare Y T0 REST Character ($FF)
    beq KEYOFF2 // IF (Y == REST) Channel 2: Key OFF

    // ELSE Channel 2: Key ON
    lda PeriodTable,y // A = Channel 2: Frequency Lo
    sta REG_APUFREQL2 // Store Channel 2: Frequency Lo ($4006)

    iny // Y++ (Increment Period Table Offset)
    lda PeriodTable,y // A = Channel 2: Frequency Hi (Bits 0..3)
    sta REG_APUFREQH2 // Store Channel 2: Frequency Hi ($4007)

    lda #%10111111  // Channel 2: Volume = $F (Bits 0..3), Fixed Volume (Bit 4), Enable Looping (Bit 5), Duty Cycle 50% (Bits 6..7)
    jmp APUCHAN2End // GOTO APU Channel 2 End

    KEYOFF2: // Channel 2: Key OFF
      lda #%10011111 // Channel 2: Volume = $F (Bits 0..3), Fixed Volume (Bit 4), Disable Looping (Bit 5), Duty Cycle 50% (Bits 6..7)

    APUCHAN2End:
      sta REG_APUCTRL2 // Store Channel 2: Control ($4004)

  APUCHAN3: // APU Channel 3
    ldy SONGCHAN3,x // Y = Channel 3: Period Table Offset
    cpy #REST   // Compare Y T0 REST Character ($FF)
    beq KEYOFF3 // IF (Y == REST) Channel 3: Key OFF

    // ELSE Channel 2: Key ON
    lda PeriodTable,y // A = Channel 3: Frequency Lo
    sta REG_APUFREQL3 // Store Channel 3: Frequency Lo ($400A)

    iny // Y++ (Increment Period Table Offset)
    lda PeriodTable,y // A = Channel 3: Frequency Hi (Bits 0..3)
    sta REG_APUFREQH3 // Store Channel 3: Frequency Hi ($400B)

    lda #%11000000  // Channel 3: Set Unmute (Bit 6), Linear Counter Start (Bit 7)
    jmp APUCHAN3End // GOTO APU Channel 3 End

    KEYOFF3: // Channel 3: Key OFF
      lda #%10000000 // Channel 3: Clear Unmute (Bit 6), Linear Counter Start (Bit 7)

    APUCHAN3End:
      sta REG_APUCTRL3 // Store Channel 3: Control ($4008)

  APUCHAN4: // APU Channel 4
    ldy SONGCHAN4,x // Y = Channel 4: Noise Rate
    cpy #REST   // Compare Y T0 REST Character ($FF)
    beq KEYOFF4 // IF (Y == REST) Channel 4: Key OFF

    sty REG_APUFREQL4 // Store Channel 4: Frequency Lo (Noise Rate) ($400E)
    sty REG_APUFREQH4 // Store Channel 4: Frequency Hi (Noise Rate) ($400F)

    lda #%10111111  // Channel 4: Volume = $F (Bits 0..3), Fixed Volume (Bit 4), Enable Looping (Bit 5), Duty Cycle 50% (Bits 6..7)
    jmp APUCHAN4End // GOTO APU Channel 4 End

    KEYOFF4: // Channel 4: Key OFF
      lda #%10011111 // Channel 4: Volume = $F (Bits 0..3), Fixed Volume (Bit 4), Disable Looping (Bit 5), Duty Cycle 50% (Bits 6..7)

    APUCHAN4End:
      sta REG_APUCTRL4 // Store Channel 4: Control ($400C)

  VSYNCDelay: // 250 MS Delay (15 NTSC VSYNCS)
    ldy #15 // Y = 15 (VSYNC Count)
    - // Wait For VBLANK
      bit REG_PPUSTATUS // Read PPUSTATUS To Reset Address Latch ($2002)
      bpl - // Wait For VBLANK
      dey   // Y-- (Decrement VSYNC Count)
      bne - // IF (VSYNC Count != 0) Wait For VBLANK
    
  inx // X++ (Increment Song Offset)
  cpx #(SongEnd - SongStart) / 4 // Compare Song Offset To Song Size
  bne APUCHAN1 // IF (Song Offset != Song Size) GOTO APU Channel 1

  jmp LoopSong // GOTO Loop Song

PeriodTable: // NTSC Period Table Used For APU Note Freqencies
  NTSCPeriodTable() // NTSC Timing, 10 Octaves: C0..B9 (120 Words)

SongStart:
  SONGCHAN1: // APU Channel 1 Song Data At 250ms (15 NTSC VSYNCS)
    db C4, REST, C4, REST, G4, REST, G4, REST, A4, REST, A4, REST, G4, REST, REST, REST // 1. Twinkle Twinkle Little Star...
    db F4, REST, F4, REST, E4, REST, E4, REST, D4, REST, D4, REST, C4, REST, REST, REST // 2.   How I Wonder What You Are...
    db G4, REST, G4, REST, F4, REST, F4, REST, E4, REST, E4, REST, D4, REST, REST, REST // 3.  Up Above The World So High...
    db G4, REST, G4, REST, F4, REST, F4, REST, E4, REST, E4, REST, D4, REST, REST, REST // 4.   Like A Diamond In The Sky...
    db C4, REST, C4, REST, G4, REST, G4, REST, A4, REST, A4, REST, G4, REST, REST, REST // 5. Twinkle Twinkle Little Star...
    db F4, REST, F4, REST, E4, REST, E4, REST, D4, REST, D4, REST, C4, REST, REST, REST // 6.   How I Wonder What You Are...

  SONGCHAN2: // APU Channel 2 Song Data At 250ms (15 NTSC VSYNCS)
    db C2, REST, C2, REST, G2, REST, G2, REST, A2, REST, A2, REST, G2, REST, REST, REST // 1.
    db F2, REST, F2, REST, E2, REST, E2, REST, D2, REST, D2, REST, C2, REST, REST, REST // 2.
    db G2, REST, G2, REST, F2, REST, F2, REST, E2, REST, E2, REST, D2, REST, REST, REST // 3.
    db G2, REST, G2, REST, F2, REST, F2, REST, E2, REST, E2, REST, D2, REST, REST, REST // 4.
    db C2, REST, C2, REST, G2, REST, G2, REST, A2, REST, A2, REST, G2, REST, REST, REST // 5.
    db F2, REST, F2, REST, E2, REST, E2, REST, D2, REST, D2, REST, C2, REST, REST, REST // 6.

  SONGCHAN3: // APU Channel 3 Song Data At 250ms (15 NTSC VSYNCS)
    db C6, REST, C6, REST, G6, REST, G6, REST, A6, REST, A6, REST, G6, REST, REST, REST // 1.
    db F6, REST, F6, REST, E6, REST, E6, REST, D6, REST, D6, REST, C6, REST, REST, REST // 2.
    db G6, REST, G6, REST, F6, REST, F6, REST, E6, REST, E6, REST, D6, REST, REST, REST // 3.
    db G6, REST, G6, REST, F6, REST, F6, REST, E6, REST, E6, REST, D6, REST, REST, REST // 4.
    db C6, REST, C6, REST, G6, REST, G6, REST, A6, REST, A6, REST, G6, REST, REST, REST // 5.
    db F6, REST, F6, REST, E6, REST, E6, REST, D6, REST, D6, REST, C6, REST, REST, REST // 6.

  SONGCHAN4: // APU Channel 4 Song Data At 250ms (15 NTSC VSYNCS)
    db NA, REST, N6, REST, N2, REST, N2, REST, NA, REST, N6, REST, N2, REST, N2, REST // 1.
    db NA, REST, N6, REST, N2, REST, N2, REST, NA, REST, N6, REST, N2, REST, N2, REST // 2.
    db NA, REST, N6, REST, N2, REST, N2, REST, NA, REST, N6, REST, N2, REST, N2, REST // 3.
    db NA, REST, N6, REST, N2, REST, N2, REST, NA, REST, N6, REST, N2, REST, N2, REST // 4.
    db NA, REST, N6, REST, N2, REST, N2, REST, NA, REST, N6, REST, N2, REST, N2, REST // 5.
    db NA, REST, N6, REST, N2, REST, N2, REST, NA, REST, N6, REST, N2, REST, N2, REST // 6.
SongEnd:

// CHR BANK 0 (8KB)
seek($18000); fill $2000 // Fill CHR Bank 0 With Zero Bytes
seek($18000)