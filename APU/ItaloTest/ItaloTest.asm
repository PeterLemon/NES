// NES Italo Disco Test 4 Channel Song Demo by krom (Peter Lemon):
arch nes.cpu
output "ItaloTest.nes", create

include "LIB/NES_HEADER.ASM" // Include Header

macro seek(variable offset) {
  origin (((offset & $7F0000) >> 1) | (offset & $7FFF)) + 16
  base offset
}

// PRG BANK 0..1 (32KB)
seek($8000); fill $8000 // Fill PRG Bank 0..1 With Zero Bytes
include "LIB/NES.INC"        // Include NES Definitions
include "LIB/NES_VECTOR.ASM" // Include Vector Table
include "LIB/NES_APU.INC"    // Include APU Definitions & Macros

// Variable Data
seek(WRAM) // 2Kb WRAM Mirror ($0000..$07FF)
SONGCHAN1POS:
  dw 0 // Song Channel 1 Position Word
SONGCHAN2POS:
  dw 0 // Song Channel 2 Position Word
SONGCHAN3POS:
  dw 0 // Song Channel 3 Position Word
SONGCHAN4POS:
  dw 0 // Song Channel 4 Position Word

seek($8000); Start:
  NES_APU_INIT() // Run NES APU Initialisation Routine

LoopSong:
  // Fill WRAM Song Channel Position Word Values
  lda #SONGCHAN1   // A = Song Channel 1 Start Position Lo Byte
  sta SONGCHAN1POS // Store Byte To WRAM
  lda #SONGCHAN1>>8  // A = Song Channel 1 Start Position Hi Byte
  sta SONGCHAN1POS+1 // Store Byte To WRAM

  lda #SONGCHAN2   // A = Song Channel 2 Start Position Lo Byte
  sta SONGCHAN2POS // Store Byte To WRAM
  lda #SONGCHAN2>>8  // A = Song Channel 2 Start Position Hi Byte
  sta SONGCHAN2POS+1 // Store Byte To WRAM

  lda #SONGCHAN3   // A = Song Channel 3 Start Position Lo Byte
  sta SONGCHAN3POS // Store Byte To WRAM
  lda #SONGCHAN3>>8  // A = Song Channel 3 Start Position Hi Byte
  sta SONGCHAN3POS+1 // Store Byte To WRAM

  lda #SONGCHAN4   // A = Song Channel 4 Start Position Lo Byte
  sta SONGCHAN4POS // Store Byte To WRAM
  lda #SONGCHAN4>>8  // A = Song Channel 4 Start Position Hi Byte
  sta SONGCHAN4POS+1 // Store Byte To WRAM

  ldy #0 // Y = Song Offset

  APUCHAN1: // APU Channel 1
    lda (SONGCHAN1POS),y // A = Channel 1: Period Table Offset
    cmp #REST   // Compare A To REST Character ($FF)
    beq KEYOFF1 // IF (A == REST) Channel 1: Key OFF
    cmp #SUST       // Compare A To SUST Character ($FE)
    beq APUCHAN1End // IF (A == SUST) Channel 1: APU Channel 1 End

    // ELSE Channel 1: Key ON
    tax // X = A
    lda PeriodTable,x // A = Channel 1: Frequency Lo
    sta REG_APUFREQL1 // Store Channel 1: Frequency Lo ($4002)

    inx // X++ (Increment Period Table Offset)
    lda PeriodTable,x // A = Channel 1: Frequency Hi (Bits 0..3)
    sta REG_APUFREQH1 // Store Channel 1: Frequency Hi ($4003)

    lda #%10110111  // Channel 1: Volume = $7 (Bits 0..3), Fixed Volume (Bit 4), Enable Looping (Bit 5), Duty Cycle 50% (Bits 6..7)
    jmp APUCHAN1Ctrl // GOTO APU Channel 1 Control

    KEYOFF1: // Channel 1: Key OFF
      lda #%10010111 // Channel 1: Volume = $7 (Bits 0..3), Fixed Volume (Bit 4), Disable Looping (Bit 5), Duty Cycle 50% (Bits 6..7)
    APUCHAN1Ctrl:
      sta REG_APUCTRL1 // Store Channel 1: Control ($4000)
    APUCHAN1End:

  APUCHAN2: // APU Channel 2
    lda (SONGCHAN2POS),y // A = Channel 2: Period Table Offset
    cmp #REST   // Compare A To REST Character ($FF)
    beq KEYOFF2 // IF (A == REST) Channel 2: Key OFF
    cmp #SUST       // Compare A To SUST Character ($FE)
    beq APUCHAN2End // IF (A == SUST) Channel 2: APU Channel 2 End

    // ELSE Channel 2: Key ON
    tax // X = A
    lda PeriodTable,x // A = Channel 2: Frequency Lo
    sta REG_APUFREQL2 // Store Channel 2: Frequency Lo ($4006)

    inx // Y++ (Increment Period Table Offset)
    lda PeriodTable,x // A = Channel 2: Frequency Hi (Bits 0..3)
    sta REG_APUFREQH2 // Store Channel 2: Frequency Hi ($4007)

    lda #%00110111   // Channel 2: Volume = $7 (Bits 0..3), Fixed Volume (Bit 4), Enable Looping (Bit 5), Duty Cycle 12.5% (Bits 6..7)
    jmp APUCHAN2Ctrl // GOTO APU Channel 2 Control

    KEYOFF2: // Channel 2: Key OFF
      lda #%00010111 // Channel 2: Volume = $7 (Bits 0..3), Fixed Volume (Bit 4), Disable Looping (Bit 5), Duty Cycle 12.5% (Bits 6..7)
    APUCHAN2Ctrl:
      sta REG_APUCTRL2 // Store Channel 2: Control ($4004)
    APUCHAN2End:

  APUCHAN3: // APU Channel 3
    lda (SONGCHAN3POS),y // A = Channel 3: Period Table Offset
    cmp #REST   // Compare A To REST Character ($FF)
    beq KEYOFF3 // IF (A == REST) Channel 3: Key OFF
    cmp #SUST       // Compare A To SUST Character ($FE)
    beq APUCHAN3End // IF (A == SUST) Channel 3: APU Channel 3 End

    // ELSE Channel 3: Key ON
    tax // X = A
    lda PeriodTable,x // A = Channel 3: Frequency Lo
    sta REG_APUFREQL3 // Store Channel 3: Frequency Lo ($400A)

    inx // X++ (Increment Period Table Offset)
    lda PeriodTable,x // A = Channel 3: Frequency Hi (Bits 0..3)
    sta REG_APUFREQH3 // Store Channel 3: Frequency Hi ($400B)

    lda #%00010000   // Channel 3: Length Count (Bit 0..6), Length Counter Disable (Bit 7)
    jmp APUCHAN3Ctrl // GOTO APU Channel 3 Control

    KEYOFF3: // Channel 3: Key OFF
      lda #%10000000 // Channel 3: Length Count (Bit 0..6), Length Counter Disable (Bit 7)
    APUCHAN3Ctrl:
      sta REG_APUCTRL3 // Store Channel 3: Control ($4008)
    APUCHAN3End:

  APUCHAN4: // APU Channel 4
    lda (SONGCHAN4POS),y // A = Channel 4: Noise Rate
    cmp #REST   // Compare A To REST Character ($FF)
    beq KEYOFF4 // IF (A == REST) Channel 4: Key OFF
    cmp #SUST       // Compare A To SUST Character ($FE)
    beq APUCHAN4End // IF (A == SUST) Channel 3: APU Channel 4 End

    // ELSE Channel 4: Key ON
    sta REG_APUFREQL4 // Store Channel 4: Frequency Lo (Noise Rate) ($400E)
    sta REG_APUFREQH4 // Store Channel 4: Frequency Hi (Noise Rate) ($400F)

    lda #%00100010   // Channel 4: Length = $2 (Bits 0..3), Fixed Volume (Bit 4), Enable Looping (Bit 5)
    jmp APUCHAN4Ctrl // GOTO APU Channel 4 Control

    KEYOFF4: // Channel 4: Key OFF
      lda #%00000010 // Channel 4: Length = $2 (Bits 0..3), Fixed Volume (Bit 4), Disable Looping (Bit 5)
    APUCHAN4Ctrl:
      sta REG_APUCTRL4 // Store Channel 4: Control ($400C)
    APUCHAN4End:

  // 132 MS Delay (8 NTSC VSYNCS)
  ldx #8 // X = 8 (VSYNC Count)
  - // Wait For VBLANK
    bit REG_PPUSTATUS // Read PPUSTATUS To Reset Address Latch ($2002)
    bpl - // Wait For VBLANK
    dex   // X-- (Decrement VSYNC Count)
    bne - // IF (VSYNC Count != 0) Wait For VBLANK
    
  iny // Y++ (Increment Song Offset)
  beq IncrementSong // IF (Y == 0) GOTO Increment Song
  jmp APUCHAN1      // ELSE GOTO APU Channel 1

  IncrementSong:
    // Increment Song Position Hi Bytes (+256)
    inc SONGCHAN1POS+1 // Song Channel 1 Position Hi Byte++
    inc SONGCHAN2POS+1 // Song Channel 2 Position Hi Byte++
    inc SONGCHAN3POS+1 // Song Channel 3 Position Hi Byte++
    inc SONGCHAN4POS+1 // Song Channel 4 Position Hi Byte++

  lda SONGCHAN4POS+1 // A = Song Channel 4 Position Hi Byte
  cmp #SongEnd>>8    // Compare Song Channel 4 Position Hi Byte To Song End Hi Byte
  beq SongReachedEnd // IF (Song Channel 4 Position Hi Byte == Song End Hi Byte) GOTO Song Reached End

  jmp APUCHAN1 // GOTO APU Channel 1

  SongReachedEnd:
    jmp LoopSong // GOTO Loop Song

PeriodTable: // NTSC Period Table Used For APU Note Freqencies
  NTSCPeriodTable() // NTSC Timing, 10 Octaves: C0..B9 (120 Words)

SongStart:
  SONGCHAN1: // APU Channel 1 Song Data At 132ms (8 NTSC VSYNCS)
    db REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 1.
    db REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 2.
    db REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 3.
    db REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 4.

    db A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST // 5.
    db A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST // 6.
    db A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST // 7.
    db A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST // 8.

    db A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST // 9.
    db C2, REST, C3, REST, C2, REST, C3, REST, C2, REST, C3, REST, C2, REST, C3, REST // 10.
    db E2, REST, E3, REST, E2, REST, E3, REST, E2, REST, E3, REST, E2, REST, E3, REST // 11.
    db G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST // 12.

    db A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST // 13.
    db C2, REST, C3, REST, C2, REST, C3, REST, C2, REST, C3, REST, C2, REST, C3, REST // 14.
    db E2, REST, E3, REST, E2, REST, E3, REST, E2, REST, E3, REST, E2, REST, E3, REST // 15.
    db G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST // 16.

    db A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST // 17.
    db C2, REST, C3, REST, C2, REST, C3, REST, C2, REST, C3, REST, C2, REST, C3, REST // 18.
    db G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST // 19.
    db G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST // 20.

    db A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST, A1, REST, A2, REST // 21.
    db C2, REST, C3, REST, C2, REST, C3, REST, C2, REST, C3, REST, C2, REST, C3, REST // 22.
    db G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST // 23.
    db G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST // 24.

    db F2, REST, F3, REST, F2, REST, F3, REST, F2, REST, F3, REST, F2, REST, F3, REST // 25.
    db G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST // 26.
    db F2, REST, F3, REST, F2, REST, F3, REST, F2, REST, F3, REST, F2, REST, F3, REST // 27.
    db G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST // 28.

    db F2, REST, F3, REST, F2, REST, F3, REST, F2, REST, F3, REST, F2, REST, F3, REST // 29.
    db G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST // 30.
    db F2, REST, F3, REST, F2, REST, F3, REST, F2, REST, F3, REST, F2, REST, F3, REST // 31.
    db G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST, G2, REST, G3, REST // 32.

  SONGCHAN2: // APU Channel 2 Song Data At 132ms (8 NTSC VSYNCS)
    db REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 1.
    db REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 2.
    db REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 3.
    db REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 4.

    db REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 5.
    db REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 6.
    db REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 7.
    db REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 8.

    db A4, SUST, REST, REST, E5, SUST, C5, SUST, REST, REST, A4, SUST, E5, SUST, REST, REST // 9.
    db C5, SUST, REST, REST, G5, SUST, E5, SUST, REST, REST, C5, SUST, G5, SUST, REST, REST // 10.
    db E5, SUST, REST, REST, B5, SUST, G5, SUST, REST, REST, E5, SUST, B5, SUST, REST, REST // 11.
    db G5, SUST, REST, REST, D6, SUST, B5, SUST, REST, REST, G5, SUST, D6, SUST, REST, REST // 12.

    db A4, SUST, REST, REST, E5, SUST, C5, SUST, REST, REST, A4, SUST, E5, SUST, REST, REST // 13.
    db C5, SUST, REST, REST, G5, SUST, E5, SUST, REST, REST, C5, SUST, G5, SUST, REST, REST // 14.
    db E5, SUST, REST, REST, B5, SUST, G5, SUST, REST, REST, E5, SUST, B5, SUST, REST, REST // 15.
    db G5, SUST, REST, REST, D6, SUST, B5, SUST, REST, REST, G5, SUST, D6, SUST, REST, REST // 16.

    db G4, A4, C5, E5, C5, D5, G4, C5, REST, D5, A4, REST, C5, REST, D5, REST // 17.
    db G4, A4, C5, E5, C5, D5, G4, C5, REST, D5, A4, REST, C5, REST, D5, REST // 18.
    db B4, C5, D5, G4, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 19.
    db B4, C5, D5, G5, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 20.

    db G4, A4, C5, E5, C5, D5, G4, C5, REST, D5, A4, REST, C5, REST, D5, REST // 21.
    db G4, A4, C5, E5, C5, D5, G4, C5, REST, D5, A4, REST, C5, REST, D5, REST // 22.
    db B4, C5, D5, G4, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 23.
    db B4, C5, D5, G5, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST, REST // 24.

    db F4, B4, C5, E5, C5, D5, A4, REST, REST, REST, C5, REST, D5, C5, D5, REST // 25.
    db G4, A4, C5, E5, C5, D5, A4, E5, REST, REST, G5, REST, A5, REST, REST, REST // 26.
    db F4, B4, C5, E5, C5, D5, A4, REST, REST, REST, C5, REST, D5, C5, D5, REST // 27.
    db G4, A4, C5, E5, C5, D5, A4, E5, REST, REST, G5, REST, A5, REST, REST, REST // 28.

    db F4, B4, C5, E5, C5, D5, A4, REST, REST, REST, C5, REST, D5, C5, D5, REST // 29.
    db G4, A4, C5, E5, C5, D5, A4, E5, REST, REST, G5, REST, A5, REST, REST, REST // 30.
    db F4, B4, C5, E5, C5, D5, A4, REST, REST, REST, C5, REST, D5, C5, D5, REST // 31.
    db G4, A4, C5, E5, C5, D5, A4, E5, REST, REST, G5, REST, A5, REST, REST, REST // 32.

  SONGCHAN3: // APU Channel 3 Song Data At 132ms (8 NTSC VSYNCS)
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 1.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 2.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 3.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 4.

    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 5.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 6.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 7.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 8.

    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 9.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 10.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 11.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 12.

    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 13.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 14.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 15.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 16.

    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 17.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 18.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 19.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 20.

    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 21.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 22.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 23.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 24.

    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 25.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 26.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 27.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 28.

    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 29.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 30.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 31.
    db A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3, A3 // 32.

  SONGCHAN4: // APU Channel 4 Song Data At 132ms (8 NTSC VSYNCS)
    db NE, REST, REST, REST, N4, REST, REST, REST, NE, REST, REST, REST, N4, REST, REST, REST // 1.
    db NE, REST, REST, REST, N4, REST, REST, REST, NE, REST, REST, REST, N4, REST, REST, REST // 2.
    db NE, REST, REST, REST, N4, REST, REST, REST, NE, REST, REST, REST, N4, REST, REST, REST // 3.
    db NE, REST, REST, REST, N4, REST, REST, REST, NE, REST, REST, REST, N4, REST, REST, REST // 4.

    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 5.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 6.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 7.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 8.

    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 9.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 10.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 11.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 12.

    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 13.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 14.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 15.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 16.

    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 17.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 18.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 19.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 20.

    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 21.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 22.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 23.
    db NE, REST, REST, REST, N2, REST, REST, REST, NE, REST, REST, REST, N2, REST, REST, REST // 24.

    db NE, REST, REST, REST, N6, REST, N6, N6, NE, REST, REST, REST, N2, REST, REST, REST // 25.
    db NE, REST, REST, REST, N6, REST, N6, N6, NE, REST, REST, REST, N2, REST, REST, REST // 26.
    db NE, REST, REST, REST, N6, REST, N6, N6, NE, REST, REST, REST, N2, REST, REST, REST // 27.
    db NE, REST, REST, REST, N6, REST, N6, N6, NE, REST, REST, REST, N2, REST, REST, REST // 28.

    db NE, REST, REST, REST, N6, REST, N6, N6, NE, REST, REST, REST, N2, REST, REST, REST // 29.
    db NE, REST, REST, REST, N6, REST, N6, N6, NE, REST, REST, REST, N2, REST, REST, REST // 30.
    db NE, REST, REST, REST, N6, REST, N6, N6, NE, REST, REST, REST, N2, REST, REST, REST // 31.
    db NE, REST, REST, REST, N6, REST, N6, N6, NE, REST, REST, REST, N2, REST, REST, REST // 32.
SongEnd:

// CHR BANK 0 (8KB)
seek($18000); fill $2000 // Fill CHR Bank 0 With Zero Bytes
seek($18000)