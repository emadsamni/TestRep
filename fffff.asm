%include "io.inc"
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
; put your code here
    mov eax, 3
    mov ebx, 0
    mov ecx, array
    mov edx, 4*32768
    ;int 80h
    mov [fileLength], eax   
    mov eax,3
    mov [number], eax


    mov eax , 5
    mov [array+0],eax
    
    mov eax , 4
    mov [array+4],eax
    
    mov eax , 3
    mov [array+8],eax    
    
    mov ebx, 1 
    outerloop:
        mov ecx,[array + 4*ebx]
        mov [item],ecx 

        mov ecx,ebx 
        interloop:
        mov edx,ecx 
        dec edx
        mov esi, [array + 4*edx]
        cmp esi, [item]    
        jb koniec 
            mov eax,[array + 4*edx]
            mov [array + 4*ecx],eax 
        loop interloop
        koniec:

    mov edx,[item]
    mov [array + 4*ecx],edx 

    inc ebx
    cmp ebx,[number] 
    jne outerloop


    mov eax, 4
    mov ebx, 1
    mov ecx, array
    mov edx, [fileLength]
    int 80h



    ; exit to linux
    mov eax,1
    mov ebx,0
    int 80h

; initialized data section
; use directives DB (byte), DW (word), DD (doubleword), DQ (quadword)
section .data

; uninitialized data section
; use directives RESB (byte), RESW (word), RESD (doubleword), RESQ (quadword)
section .bss
    fileLength resd 1   
    number resd 1   

    array resd 32768
    item resd 1