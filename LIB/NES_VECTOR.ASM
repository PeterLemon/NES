//============
// NES VECTOR
//============
seek($FFFA)
// VECTOR (6502 Mode)
dw $0000 // NMI VECTOR     (V-Blank Interrupt)
dw $8000 // RESET VECTOR
dw $0000 // IRQ/BRK VECTOR (Interrupt/Break)