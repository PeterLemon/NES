// NES "Hello, World!" Text Printing demo by krom (Peter Lemon):
// 1. Loads Palette Data To VRAM
// 2. Clears BG Map VRAM To A Space " " Character
// 3. Prints Text Characters To BG Map VRAM
arch nes.cpu
output "HelloWorld.nes", create

include "LIB\NES_HEADER.ASM" // Include Header

macro seek(variable offset) {
  origin (((offset & $7F0000) >> 1) | (offset & $7FFF)) + 16
  base offset
}

// PRG BANK 0..1 (32KB)
seek($8000); fill $8000 // Fill PRG Bank 0..1 With Zero Bytes
include "LIB\NES.INC"        // Include NES Definitions
include "LIB\NES_VECTOR.ASM" // Include Vector Table

seek($8000); Start:
  NES_PPU_INIT() // Run NES PPU Initialisation Routine

  // Write BG Palette 0 (Palette = VRAM $3F00)
  bit REG_PPUSTATUS // Read PPUSTATUS To Reset Address Latch ($2002)
  lda #$3F        // A = $3F
  sta REG_PPUADDR // VRAM Address MSB = $3F ($2006)
  lda #$00        // A = $00
  sta REG_PPUADDR // VRAM Address LSB = $00 ($2006)

  lda #$0F        // A = $0F (Black)
  sta REG_PPUDATA // VRAM Write Data = $0F ($2007)
  lda #$20        // A = $20 (White)
  sta REG_PPUDATA // VRAM Write Data = $20 ($2007)

  // BG MAP = VRAM $2000..$23BF (Attribute Table = VRAM $23C0..23FF)
  bit REG_PPUSTATUS // Read PPUSTATUS To Reset Address Latch ($2002)
  lda #$20        // A = $20
  sta REG_PPUADDR // VRAM Address MSB = $20 ($2006)
  lda #$00        // A = $00
  sta REG_PPUADDR // VRAM Address LSB = $00 ($2006)

  // Clear VRAM To Space " " Character ($20)
  lda #$20 // A = Space " " Character
  ldy #$04 // Loop Y 4 Times
  -        // Loop Y
    ldx #$F0 // Loop X 240 Times
    -        // Loop X
      sta REG_PPUDATA // VRAM Write Data = $20 ($2007)
      dex    // X--
      bne -  // IF (X != 0) Loop X
    dey    // Y--
    bne -- // IF (Y != 0) Loop Y

  // Print Text
  ldx #0  // X = Text Offset
  ldy #13 // Y = Text Count

  // Set Text Position On Screen
  bit REG_PPUSTATUS // Read PPUSTATUS To Reset Address Latch ($2002)
  lda #$21        // A = $21
  sta REG_PPUADDR // VRAM Address MSB = $21 ($2006)
  lda #$08        // A = $08
  sta REG_PPUADDR // VRAM Address LSB = $08 ($2006)

  - // Loop Text
    lda HELLOWORLD,x // A = Text Character
    inx   // X++ (Increment Text Offset)
    sta REG_PPUDATA // VRAM Write Data = Text Character ($2007)
    dey   // Y-- (Decrement Text Count)
    bne - // IF (Text Count !=0) Loop Text

  // Reset BG X/Y Scroll
  bit REG_PPUSTATUS // Read PPUSTATUS To Reset Address Latch ($2002)
  lda #0
  sta REG_PPUSCROLL // PPU Background Scrolling Offset X = 0 ($2005)
  sta REG_PPUSCROLL // PPU Background Scrolling Offset Y = 0 ($2005)

  // Turn On BG
  lda #%00000000  // Reset PPU Flags (Bits 0..7)
  sta REG_PPUCTRL // PPU Control Register 1 = Flags ($2000)
  lda #%00001010  // Enable BG Left 8 Screen Pixels (Bit 1), & Show BG (Bit 3)
  sta REG_PPUMASK // PPU Control Register 2 = Flags ($2001)

Loop:
  jmp Loop

HELLOWORLD:
  db "Hello, World!" // Hello World Text

// CHR BANK 0..3 (32KB)
seek($18000); fill $8000 // Fill CHR Bank 0..3 With Zero Bytes
seek($18000)
include "Font8x8.asm" // Include BG 2BPP 8x8 Tile Font Character Data (2032 Bytes)