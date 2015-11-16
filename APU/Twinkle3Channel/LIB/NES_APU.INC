//=========
// NES APU
//=========
// Frequency WORD Offsets For NTSC/PAL Period Table
constant A1($00)
constant A1#($02)
constant B1($04)
constant C2($06)
constant C2#($08)
constant D2($0A)
constant D2#($0C)
constant E2($0E)
constant F2($10)
constant F2#($12)
constant G2($14)
constant G2#($16)

constant A2($18)
constant A2#($1A)
constant B2($1C)
constant C3($1E)
constant C3#($20)
constant D3($22)
constant D3#($24)
constant E3($26)
constant F3($28)
constant F3#($2A)
constant G3($2C)
constant G3#($2E)

constant A3($30)
constant A3#($32)
constant B3($34)
constant C4($36)
constant C4#($38)
constant D4($3A)
constant D4#($3C)
constant E4($3E)
constant F4($40)
constant F4#($42)
constant G4($44)
constant G4#($46)

constant A4($48)
constant A4#($4A)
constant B4($4C)
constant C5($4E)
constant C5#($50)
constant D5($52)
constant D5#($54)
constant E5($56)
constant F5($58)
constant F5#($5A)
constant G5($5C)
constant G5#($5E)

constant A5($60)
constant A5#($62)
constant B5($64)
constant C6($66)
constant C6#($68)
constant D6($6A)
constant D6#($6C)
constant E6($6E)
constant F6($70)
constant F6#($72)
constant G6($74)
constant G6#($76)

constant A6($78)
constant A6#($7A)
constant B6($7C)
constant C7($7E)
constant C7#($80)
constant D7($82)
constant D7#($84)
constant E7($86)
constant F7($88)
constant F7#($8A)
constant G7($8C)
constant G7#($8E)

constant A7($90)
constant A7#($92)
constant B7($94)
constant C8($96)
constant C8#($98)
constant D8($9A)
constant D8#($9C)
constant E8($9E)
constant F8($A0)
constant F8#($A2)
constant G8($A4)
constant G8#($A6)

constant A8($A8)
constant A8#($AA)
constant B8($AC)
constant C9($AE)
constant C9#($B0)
constant D9($B2)
constant D9#($B4)
constant E9($B6)
constant F9($B8)
constant F9#($BA)
constant G9($BC)
constant G9#($BE)

constant SUST($FE)
constant REST($FF)

constant N0($0) // Noise Rate  0: NTSC =    4Hz / PAL =    4Hz
constant N1($1) // Noise Rate  1: NTSC =    8Hz / PAL =    8Hz
constant N2($2) // Noise Rate  2: NTSC =   16Hz / PAL =   14Hz
constant N3($3) // Noise Rate  3: NTSC =   32Hz / PAL =   30Hz
constant N4($4) // Noise Rate  4: NTSC =   64Hz / PAL =   60Hz
constant N5($5) // Noise Rate  5: NTSC =   96Hz / PAL =   88Hz
constant N6($6) // Noise Rate  6: NTSC =  128Hz / PAL =  118Hz
constant N7($7) // Noise Rate  7: NTSC =  160Hz / PAL =  148Hz
constant N8($8) // Noise Rate  8: NTSC =  202Hz / PAL =  188Hz
constant N9($9) // Noise Rate  9: NTSC =  254Hz / PAL =  236Hz
constant NA($A) // Noise Rate 10: NTSC =  380Hz / PAL =  354Hz
constant NB($B) // Noise Rate 11: NTSC =  508Hz / PAL =  472Hz
constant NC($C) // Noise Rate 12: NTSC =  762Hz / PAL =  708Hz
constant ND($D) // Noise Rate 13: NTSC = 1016Hz / PAL =  944Hz
constant NE($E) // Noise Rate 14: NTSC = 2034Hz / PAL = 1890Hz
constant NF($F) // Noise Rate 15: NTSC = 4068Hz / PAL = 3778Hz

macro NTSCPeriodTable() { // NTSC Timing, 8 Octaves: A1..G9# (96 Words)
  dw $07F1,$077F,$0713,$06AD,$064D,$05F3,$059D,$054C,$0500,$04B8,$0474,$0434 // A1..G2#
  dw $03F8,$03BF,$0389,$0356,$0326,$02F9,$02CE,$02A6,$0280,$025C,$023A,$021A // A2..G3#
  dw $01FB,$01DF,$01C4,$01AB,$0193,$017C,$0167,$0152,$013F,$012D,$011C,$010C // A3..G4#
  dw $00FD,$00EF,$00E1,$00D5,$00C9,$00BD,$00B3,$00A9,$009F,$0096,$008E,$0086 // A4..G5#
  dw $007E,$0077,$0070,$006A,$0064,$005E,$0059,$0054,$004F,$004B,$0046,$0042 // A5..G6#
  dw $003F,$003B,$0038,$0034,$0031,$002F,$002C,$0029,$0027,$0025,$0023,$0021 // A6..G7#
  dw $001F,$001D,$001B,$001A,$0018,$0017,$0015,$0014,$0013,$0012,$0011,$0010 // A7..G8#
  dw $000F,$000E,$000D,$000C,$000C,$000B,$000A,$000A,$0009,$0008,$0008,$0007 // A8..G9#
}

macro PALPeriodTable() { // PAL Timing, 8 Octaves: A1..G9# (96 Words)
  dw $0760,$06F6,$0692,$0634,$05DB,$0586,$0537,$04EC,$04A5,$0462,$0423,$03E8 // A1..G2#
  dw $03B0,$037B,$0349,$0319,$02ED,$02C3,$029B,$0275,$0252,$0231,$0211,$01F3 // A2..G3#
  dw $01D7,$01BD,$01A4,$018C,$0176,$0161,$014D,$013A,$0129,$0118,$0108,$00F9 // A3..G4#
  dw $00EB,$00DE,$00D1,$00C6,$00BA,$00B0,$00A6,$009D,$0094,$008B,$0084,$007C // A4..G5#
  dw $0075,$006E,$0068,$0062,$005D,$0057,$0052,$004E,$0049,$0045,$0041,$003E // A5..G6#
  dw $003A,$0037,$0034,$0031,$002E,$002B,$0029,$0026,$0024,$0022,$0020,$001E // A6..G7#
  dw $001D,$001B,$0019,$0018,$0016,$0015,$0014,$0013,$0012,$0011,$0010,$000F // A7..G8#
  dw $000E,$000D,$000C,$000B,$000B,$000A,$0009,$0009,$0008,$0008,$0007,$0007 // A8..G9#
}