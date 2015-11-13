//=========
// NES APU
//=========
// Frequency WORD Offsets For NTSC/PAL Period Table
constant C0($00)
constant C0#($02)
constant D0($04)
constant D0#($06)
constant E0($08)
constant F0($0A)
constant F0#($0C)
constant G0($0E)
constant G0#($10)
constant A0($12)
constant A0#($14)
constant B0($16)

constant C1($18)
constant C1#($1A)
constant D1($1C)
constant D1#($1E)
constant E1($20)
constant F1($22)
constant F1#($24)
constant G1($26)
constant G1#($28)
constant A1($2A)
constant A1#($2C)
constant B1($2E)

constant C2($30)
constant C2#($32)
constant D2($34)
constant D2#($36)
constant E2($38)
constant F2($3A)
constant F2#($3C)
constant G2($3E)
constant G2#($40)
constant A2($42)
constant A2#($44)
constant B2($46)

constant C3($48)
constant C3#($4A)
constant D3($4C)
constant D3#($4E)
constant E3($50)
constant F3($52)
constant F3#($54)
constant G3($56)
constant G3#($58)
constant A3($5A)
constant A3#($5C)
constant B3($5E)

constant C4($60)
constant C4#($62)
constant D4($64)
constant D4#($66)
constant E4($68)
constant F4($6A)
constant F4#($6C)
constant G4($6E)
constant G4#($70)
constant A4($72)
constant A4#($74)
constant B4($76)

constant C5($78)
constant C5#($7A)
constant D5($7C)
constant D5#($7E)
constant E5($80)
constant F5($82)
constant F5#($84)
constant G5($86)
constant G5#($88)
constant A5($8A)
constant A5#($8C)
constant B5($8E)

constant C6($90)
constant C6#($92)
constant D6($94)
constant D6#($96)
constant E6($98)
constant F6($9A)
constant F6#($9C)
constant G6($9E)
constant G6#($A0)
constant A6($A2)
constant A6#($A4)
constant B6($A6)

constant C7($A8)
constant C7#($AA)
constant D7($AC)
constant D7#($AE)
constant E7($B0)
constant F7($B2)
constant F7#($B4)
constant G7($B6)
constant G7#($B8)
constant A7($BA)
constant A7#($BC)
constant B7($BE)

constant C8($C0)
constant C8#($C2)
constant D8($C4)
constant D8#($C6)
constant E8($C8)
constant F8($CA)
constant F8#($CC)
constant G8($CE)
constant G8#($D0)
constant A8($D2)
constant A8#($D4)
constant B8($D6)

constant C9($D8)
constant C9#($DA)
constant D9($DC)
constant D9#($DE)
constant E9($E0)
constant F9($E2)
constant F9#($E4)
constant G9($E6)
constant G9#($E8)
constant A9($EA)
constant A9#($EC)
constant B9($EE)

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

macro NTSCPeriodTable() { // NTSC Timing, 10 Octaves: C0..B9 (120 Words)
  dw $1AB9,$1939,$17CE,$1678,$1535,$1404,$12E5,$11D5,$10D5,$0FE3,$0EFF,$0E27 // C0..B0
  dw $0D5C,$0C9C,$0BE7,$0B3C,$0A9A,$0A02,$0972,$08EA,$086A,$07F1,$077F,$0713 // C1..B1
  dw $06AD,$064D,$05F3,$059D,$054D,$0500,$04B8,$0475,$0434,$03F8,$03BF,$0389 // C2..B2
  dw $0356,$0326,$02F9,$02CE,$02A6,$0280,$025C,$023A,$021A,$01FC,$01DF,$01C4 // C3..B3
  dw $01AB,$0193,$017C,$0167,$0152,$013F,$012D,$011C,$010C,$00FD,$00EF,$00E2 // C4..B4
  dw $00D5,$00C9,$00BD,$00B3,$00A9,$009F,$0096,$008E,$0086,$007E,$0077,$0070 // C5..B5
  dw $006A,$0064,$005E,$0059,$0054,$004F,$004B,$0046,$0042,$003F,$003B,$0038 // C6..B6
  dw $0034,$0031,$002F,$002C,$0029,$0027,$0025,$0023,$0021,$001F,$001D,$001B // C7..B7
  dw $001A,$0018,$0017,$0015,$0014,$0013,$0012,$0011,$0010,$000F,$000E,$000D // C8..B8
  dw $000C,$000C,$000B,$000A,$000A,$0009,$0008,$0008,$0007,$0007,$0006,$0006 // C9..B9
}

macro PALPeriodTable() { // PAL Timing, 10 Octaves: C0..B9 (120 Words)
  dw $18D3,$176E,$161D,$14DF,$13B3,$1298,$118D,$1091,$0FA3,$0EC2,$0DEE,$0D26 // C0..B0
  dw $0C69,$0BB6,$0B0E,$0A6F,$09D9,$094C,$08C6,$0848,$07D1,$0761,$06F6,$0692 // C1..B1
  dw $0634,$05DB,$0587,$0537,$04EC,$04A5,$0463,$0423,$03E8,$03B0,$037B,$0349 // C2..B2
  dw $0319,$02ED,$02C3,$029B,$0276,$0252,$0231,$0211,$01F3,$01D7,$01BD,$01A4 // C3..B3
  dw $018C,$0176,$0161,$014D,$013A,$0129,$0118,$0108,$00F9,$00EB,$00DE,$00D1 // C4..B4
  dw $00C6,$00BA,$00B0,$00A6,$009D,$0094,$008B,$0084,$007C,$0075,$006E,$0068 // C5..B5
  dw $0062,$005D,$0057,$0053,$004E,$0049,$0045,$0041,$003E,$003A,$0037,$0034 // C6..B6
  dw $0031,$002E,$002B,$0029,$0026,$0024,$0022,$0020,$001E,$001D,$001B,$0019 // C7..B7
  dw $0018,$0016,$0015,$0014,$0013,$0012,$0011,$0010,$000F,$000E,$000D,$000C // C8..B8
  dw $000B,$000B,$000A,$0009,$0009,$0008,$0008,$0007,$0007,$0006,$0006,$0006 // C9..B9
}