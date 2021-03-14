%include "io.inc"
;;%include linapi.htm,cpuext32.htm
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    lea	esi, [cvt_input]
    lea	edi, [cvt_output]
    .big_loop:
    
	xor	eax, eax		; accu
	xor	ebx, ebx		; number
	xor	ecx, ecx		; minus flag: 0 = positive, -1 = minus
	
	.next_chr:
	cmp	al, 0
	je	.exit
	cmp	al, '$'
	je	.dollar
	cmp	al, '-'
	je	.minus
	sub	al, '0'			; normalize ASCII to number
	jc	.exit
	cmp	al, 9
	jg	.exit
	lea	ebx, [ebx+ebx*4]	; ebx = ebx * 5
	lea	ebx, [eax+ebx*2]	; ebx = (ebx * 2) + digit
	jmp	.next_chr
.minus:
	not	ecx			; toggle 'minus' bit in ecx
	jecxz	.exit			; jump if we have more than 1 '-' sign
	jmp	.next_chr
.dollar:	
	mov eax, ebx			; move number to eax
	xor eax, ecx			; if minus then ecx = -1, so effectively eax = not eax
	neg ecx				; if positive then ecx = 0, so nothing happens to eax
	add eax, ecx			; Effectively, we do a conditional NEG on eax, depending on ecx's value
	stosd				; store value and increment pointer
	jmp	.big_loop
	.exit:
	mov	edx, len    ;message length
	mov	ecx, [cvt_output]    ;message to write
	mov	ebx, 1	    ;file descriptor (stdout)
	mov	eax, 4	    ;system call number (sys_write)
	int	0x80        ;call kernel
	mov	eax, 1	    ;system call number (sys_exit)
	int	0x80        ;call kernel

; initialized data section
; use directives DB (byte), DW (word), DD (doubleword), DQ (quadword)
section .data

; uninitialized data section
; use directives RESB (byte), RESW (word), RESD (doubleword), RESQ (quadword)
section .data
		;length of our dear string
section .bss
    cvt_input db '12345$-12345$99999$-99999$',0
align 4
cvt_output	dd 0,0,0,0
msg	db	'Hello, world!',0xa	;our dear string
len	equ	$ - msg	