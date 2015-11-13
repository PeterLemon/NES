// NES Twinkle Song Demo by krom (Peter Lemon):
arch nes.cpu
output "Twinkle.nes", create

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
    cpy #REST   // Compare Y To REST Character ($FF)
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

  VSYNCDelay: // 250 MS Delay (15 NTSC VSYNCS)
    ldy #15 // Y = 15 (VSYNC Count)
    - // Wait For VBLANK
      bit REG_PPUSTATUS // Read PPUSTATUS To Reset Address Latch ($2002)
      bpl - // Wait For VBLANK
      dey   // Y-- (Decrement VSYNC Count)
      bne - // IF (VSYNC Count != 0) Wait For VBLANK
  
  inx // X++ (Increment Song Offset)
  cpx #SongEnd - SongStart // Compare Song Offset To Song Size
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
SongEnd:

// CHR BANK 0 (8KB)
seek($18000); fill $2000 // Fill CHR Bank 0 With Zero Bytes
seek($18000)