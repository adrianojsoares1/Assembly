
;;;
;;; file: first.asm
;;; Written by Dr. Minimair, revised by Dr. Marlowe
;;; First assembly program. This program asks for two integers as
;;; input and prints out their sum plus a predetermined offset
;;; To just print the sum, initialize the offset to 0
;;; 
%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
;
; These labels refer to strings used for output
;
prompt1 db    	"Enter a number: ", 0       ; don't forget nul terminator
	;; The string is a sequence of binary numbers 
	;; (ascii code) terminated by a zero byte
	;; "prompt1" stands for the address of the first byte
	;; of the string.
	;; "db" stands for "define bytes"
prompt2 db    	"Enter another number: ", 0
outmsg1 db    	"You entered ", 0
outmsg2 db    	" and ", 0
outmsg3 db      " and ",0
outmsg4 db    	", the sum of these ", 0
outmsg5 db	"is ", 0
errmsg	db	"There has been an overflow. Exiting program.", 0
offset	dd	7

;
; uninitialized data is put in the .bss segment
;
segment .bss
;
; These labels refer to double words used to store the inputs
;
input1  resd 1
	;; "resd" stands for "reserve double words"
	;; "1" means that only one double word is reserved
	;; "input1" is a label that stands for the
	;; address where the double word begins
	;; (address of the first byte of the double word)
input2  resd 1
input3  resd 1


	;;
	;; code is put in the .text segment
	;; Initial Boilerplate
	
segment .text
        global  _asm_main
_asm_main:
        enter   0,0             ; setup routine
        pushad

	;; Input Section
	
        mov     eax, prompt1    ; print out prompt
	;; means eax = prompt1, mov copies data
        call    print_string
	;; print_string is an external function which
	;; expects that the address of the string to be printed
	;; is contained in eax

        call    read_int        ; read integer
	;; reads an integer from the keyboard and 
	;; puts it into eax
        mov     [input1], eax   ; store into input1
	;; means memory[input1] = eax

        mov     eax, prompt2    ; print out prompt
        call    print_string

        call    read_int        ; read integer
        mov     [input2], eax   ; store into input2
		
		mov eax, prompt2        
		call print_string
		
		call read_int
		mov [input3],eax  ;store into input3
		

	;; Computation Section
	
        mov     eax, [input1]   ; eax = dword at input1
	mov	ebx, [input2]	; ebx = dword at input
        add     eax, ebx
		mov ebx,[input3]
		add eax,ebx
	jo	oflow		; an overflow occurred
        mov     ebx, eax        ; ebx = eax

;	dump_regs 1		; show the registers after the sum
;	dump_mem 1, input1, 1	; show the variables after the sum
;       dump_mem 2, outmsg1, 1	; show part of initialized data region

	;; Output Section
	;; Next print out result message as series of steps

        mov     eax, outmsg1
        call    print_string    ; print out first message
        mov     eax, [input1]     
        call    print_int       ; print out input1
        mov     eax, outmsg2
        call    print_string    ; print out second messsage
        mov     eax, [input2]
        call    print_int       ; print out input2
        mov     eax, outmsg3
        call    print_string    ; print out third message
		mov     eax, [input3]
		call	print_int
		mov		eax, outmsg4
		call    print_string
		
	mov	eax, outmsg5
	call	print_string	; print out last output message
        mov     eax, ebx
        call    print_int       ; print out sum (ebx)
        call    print_nl        ; print new-line
	jmp	exit0

	;; Error Section
	
oflow:	mov	eax, errmsg	
	call	print_string	; print the overflow error message
	call	print_nl
	
	;; Terminal boilerplate
	
exit0:	popad
        mov     eax, 0          ; return back to C
        leave                     
        ret
