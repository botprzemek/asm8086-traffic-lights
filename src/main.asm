.model small
.stack 100h
.data
    portM equ 0C1h    ; Port for main road
    portS equ 06Bh    ; Port for side road
    detector equ 06Dh ; Detector port (PortD) on side road

    ; light colors
    green equ 00h
    amber equ 10h
    red equ 01h
    red_amber equ 11h

.code
start:
    ; Set green light on the main road
    mov al, green
    out portM, al

wait:
    ; Check the state of the detector on the side road
    in al, detector ; 00h or 01h depending on whether there is a vehicle or not
    test al, 01h    ; AND operation between register AL and 01h
    jz wait         ; If no vehicle, continue waiting

    ; Light change sequence

    ; Amber on the main road, 3 seconds delay
    mov al, amber ; 10h -> AL
    out portM, al ; AL -> 0C1h
    call delay_3_seconds

    ; Red on the main road, 3 seconds delay
    mov al, red   ; 01h -> AL
    out portM, al ; AL -> 0C1h
    call delay_3_seconds

    ; Red with amber on the side road, 3 seconds delay
    mov al, red_amber ; 11h -> AL
    out portS, al     ; AL -> 06Bh
    call delay_3_seconds

    ; Green on the side road, 13 seconds delay
    mov al, green
    out portS, al
    call delay_13_seconds

    ; Return to initial state

    ; Amber on the side road
    mov al, amber
    out portS, al
    call delay_3_seconds

    ; Red on the side road
    mov al, red
    out portS, al
    call delay_3_seconds

    ; Red with amber on the main road, 3 seconds delay
    mov al, red_amber
    out portM, al
    call delay_3_seconds

    ; Green on the main road, 13 seconds delay
    mov al, green
    out portM, al
    call delay_13_seconds
    jmp wait ; Return to checking the detector

; Procedure for 3 seconds delay
delay_3_seconds proc
    push cx
    push dx
    mov cx, 3 ; Execute 3 times (3 seconds)
    call delay_1_second
    pop dx
    pop cx
    ret
delay_3_seconds endp

; Procedure for 13 seconds delay
delay_13_seconds proc
    push cx
    push dx
    mov cx, 13 ; Execute 13 times (13 seconds)
    call delay_1_second
    pop dx
    pop cx
    ret
delay_13_seconds endp

; Procedure for 1 second delay
delay_1_second proc
    pusha
    mov cx, 18 ; Approximately 1 second at standard clock frequency
delay_loop:
    mov ah, 2Ch
    int 21h
    mov bl, dh
loop2:
    mov ah, 2Ch
    int 21h
    cmp dh, bl
    je loop2
    loop delay_loop
    popa
    ret
delay_1_second endp

end start
