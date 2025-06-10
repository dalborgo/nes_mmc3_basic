.include "constants.inc"
.include "header.inc"

.segment "CODE"
.proc irq_handler
    RTI
.endproc

.proc nmi_handler
    LDA #$00
    STA PPUSCROLL
    LDA #$00
    STA PPUSCROLL
    RTI
.endproc

.import reset_handler
.import draw_background

.export main
.proc main
; write a palette
    LDX PPUSTATUS
    LDX #$3f
    STX PPUADDR
    LDX #$00
    STX PPUADDR
load_palettes:
    LDA palettes,X
    STA PPUDATA
    INX
    CPX #16
    BNE load_palettes
; write nametables
    JSR draw_background

vblankwait:                         ; wait for another vblank before continuing
    BIT PPUSTATUS
    BPL vblankwait
    LDA #%10000000                  ; turn on NMIs, sprites use first pattern table
    STA PPUCTRL
    LDA #%00011110                  ; turn on screen
    STA PPUMASK

forever:
    JMP forever
.endproc

.segment "VECTORS"
.addr nmi_handler, reset_handler, irq_handler

.segment "RODATA"
palettes:
.byte $0f,$12,$24,$30
.byte $0f,$0c,$21,$32
.byte $0f,$05,$16,$27
.byte $0f,$0b,$1a,$29



.segment "CHR"
.incbin "graphic.chr"
