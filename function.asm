
;
; file: first.asm
; First assembly program. This program asks for two integers as
; input and prints out their sum.
;
%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
;
; These labels refer to strings used for output
;
prompt1 db    "Enter a number: ", 0       ; don't forget nul terminator
	;; The string is a sequence of binary numbers 
	;; (ascii code) terminated by a zero byte
	;; "prompt1" stands for the address of the first byte
	;; of the string.
	;; "db" stands for "define bytes"
prompt2 db    "Enter another number: ", 0
outmsg1 db    "You entered ", 0
outmsg2 db    " and ", 0
outmsg3 db    ", the function of these (4x - 3y) is ", 0


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



;
; code is put in the .text segment
;
segment .text
        global  _asm_main
_asm_main:
        enter   0,0               ; setup routine
        pushad

        mov     eax, prompt1      ; print out prompt
	;; means eax = prompt1, mov copies data
        call    print_string
	;; print_string is an external function which
	;; expects that the address of the string to be printed
	;; is contained in eax

        call    read_int          ; read integer
	;; reads an integer from the keyboard and 
	;; puts it into eax
        mov     [input1], eax     ; store into input1
	;; means memory[input1] = eax
	
        mov     eax, prompt2      ; print out prompt
        call    print_string

        call    read_int          ; read integer
        mov     [input2], eax     ; store into input2

        mov     eax, [input1]     ; eax = dword at input1
		mov	ebx, [input2]	  ; ebx = dword at input2
       
		
        mov     ebx, eax          ; ebx = eax

;
; next print out result message as series of steps
;
        mov     eax, outmsg1
        call    print_string      ; print out first message
        mov     eax, [input1]     
        call    print_int         ; print out input1
        mov     eax, outmsg2
        call    print_string      ; print out second message
        mov     eax, [input2]
        call    print_int         ; print out input2
        mov     eax, outmsg3
		call print_string
		
		mov eax, [input1]
		sal eax, 2
		mov ebx, [input2]
		sal ebx, 1
		add ebx, [input2]
		sub eax,ebx
		
       
        call    print_int         ; print out sum (ebx)
        call    print_nl          ; print new-line

        popad
        mov     eax, 0            ; return back to C
        leave                     
        ret


