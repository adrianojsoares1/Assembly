%include "asm_io.inc"

segment .data

prompt1 db "Enter first number: " ,0

prompt2 db "Enter second number: ",0

prompt3 db "The quotient is: ",0

errorMessage db "Error: No negative numbers!" ,0

prompt4 db " and the remainder is: ",0
segment .bss
input1 resd 1
input2 resd 1
input3 resd 1
	
segment .text
        global  _asm_main
_asm_main:
        enter   0,0             ; setup routine
        pushad
		
mov eax, prompt1 
call print_string

call read_int
mov [input1], eax
 
mov eax, prompt2
call print_string

call read_int
mov [input2], eax


mov ecx, 0
mov eax, [input1]
mov ebx, [input2]
cmp eax,0
jl errorBox
cmp ebx,0
jl errorBox
cmp ebx,eax
jg setLarger

jmp divLoop

divLoop:
cmp eax , ebx
jl divJump

sub eax,ebx
mov ebx,[input2]
inc ecx

jmp divLoop

errorBox:
mov eax, errorMessage
call print_string
jmp bye

setLarger:
mov eax, ebx

divJump:
mov [input3],eax

mov eax, prompt3
call print_string

mov eax, ecx
call print_int

mov eax, prompt4
call print_string

mov eax, [input3]
call print_int

bye:
;end
exit0:	popad
        mov     eax, 0          ; return back to C
        leave                     
        ret