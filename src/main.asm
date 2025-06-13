.include "constants.inc"
.include "header.inc"

.segment "ZEROPAGE"
frame_index: .res 1
frame_counter: .res 1

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

.proc set_chr_banks
    LDA frame_index
    BEQ frame0

; Frame 1
    LDA #$00
    STA BANK_SELECT
    LDA #$08
    STA BANK_DATA

    LDA #$01
    STA BANK_SELECT
    LDA #$0A
    STA BANK_DATA

    LDA #$02
    STA BANK_SELECT
    LDA #$0C
    STA BANK_DATA

    LDA #$03
    STA BANK_SELECT
    LDA #$0D
    STA BANK_DATA

    LDA #$04
    STA BANK_SELECT
    LDA #$0E
    STA BANK_DATA

    LDA #$05
    STA BANK_SELECT
    LDA #$0F
    STA BANK_DATA

    RTS

frame0:
    LDA #$00
    STA BANK_SELECT
    LDA #$00
    STA BANK_DATA

    LDA #$01
    STA BANK_SELECT
    LDA #$02
    STA BANK_DATA

    LDA #$02
    STA BANK_SELECT
    LDA #$04
    STA BANK_DATA

    LDA #$03
    STA BANK_SELECT
    LDA #$05
    STA BANK_DATA

    LDA #$04
    STA BANK_SELECT
    LDA #$06
    STA BANK_DATA

    LDA #$05
    STA BANK_SELECT
    LDA #$07
    STA BANK_DATA

    RTS
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

    LDA #$00
    STA frame_index
    STA frame_counter
    JSR set_chr_banks

forever:
    BIT PPUSTATUS
    BPL forever
    INC frame_counter
    LDA frame_counter
    CMP #20
    BCC no_change
    LDA #$00
    STA frame_counter
    LDA frame_index
    EOR #$01
    STA frame_index
    JSR set_chr_banks
no_change:
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
.incbin "graphic_frame2.chr"
