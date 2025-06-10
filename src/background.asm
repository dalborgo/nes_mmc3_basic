.include "constants.inc"

.segment "CODE"
.export draw_background
.proc draw_background
; Nametable: 960 byte a partire da $2000
    LDA PPUSTATUS
    LDA #$20
    STA PPUADDR
    LDA #$00
    STA PPUADDR
; Blocchi da 256 byte
    LDY #$00
block0:
    LDA graphic,Y
    STA PPUDATA
    INY
    BNE block0

    LDY #$00
block1:
    LDA graphic + 256,Y
    STA PPUDATA
    INY
    BNE block1

    LDY #$00
block2:
    LDA graphic + 512,Y
    STA PPUDATA
    INY
    BNE block2
; Ultimi 192 byte: da 768 a 959
    LDY #$00
block3:
    LDA graphic + 768,Y
    STA PPUDATA
    INY
    CPY #192
    BNE block3


; finally, attribute table, NEXXT AtOff (offset
; https://www.nesdev.org/wiki/PPU_attribute_tables
; LDA #%00001000 ; AtOff .2 quadrante NORD EST, ma si definiscono tutti
; Attribute table: 64 byte da $23C0
    LDA PPUSTATUS
    LDA #$23
    STA PPUADDR
    LDA #$C0
    STA PPUADDR

    LDX #$00
load_attributes:
    LDA graphic + 960,X
    STA PPUDATA
    INX
    CPX #$40                        ; 64 byte
    BNE load_attributes

    RTS
.endproc

.segment "RODATA"
.include "graphic.asm"
