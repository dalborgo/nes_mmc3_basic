.segment "HEADER"
.byte $4e, $45, $53, $1a ; Magic string that always begins an iNES header
.byte $02        ; Number of 16KB PRG-ROM banks
.byte $02        ; Number of 8KB CHR-ROM banks
.byte %01000000  ; Mapper 4, horizontal mirroring
.byte %00000000  ; No special-case flags set
.byte $00        ; No PRG-RAM present
.byte $00        ; NTSC format
