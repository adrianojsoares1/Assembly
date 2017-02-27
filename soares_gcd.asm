;The Euclidian Algorithm: Finds the Greatest Common Divisor of 2 Numbers
;Adriano Soares
;Assembly Code
;Professor Marlowe
;12/14/2016

%include "asm_io.inc"

	segment .data
	;variables, text
	prompt1 db "Enter first number: ",0
	prompt2 db "Enter second number: ",0
	outputMsg db "The GCD of these two numbers is: ",0
	errorMsg db "Both numbers cannot be zero!",0
	
	segment .bss
	;variables, data
	
	input1 resd 1
	input2 resd 1
	tempVar resd 1
	
	segment .text
;main	
	global _asm_main
	
_asm_main:
	enter 0,0
	pushad
;Read Input to take in first number, second number	
	mov eax, prompt1
	call print_string
	
	call read_int
	mov [input1], eax
	
	mov eax, prompt2
	call print_string
	
	call read_int
	mov [input2], eax
;Move data into eax and ebx
;Compare and check for one zero or double zero's
	mov eax,[input1]
	mov ebx,[input2]
	cmp eax, 0
	je aZero
	cmp ebx, 0
	je bZero
;Check for negatives, if so, negate to positive
checkNegatives:	
	cmp eax,0
	jl invertA
	cmp ebx,0
	jl invertB
;When preconditions have been handled, find GCD
	jmp initDiv	
invertA:
	neg eax
	jmp checkNegatives
invertB:
	neg ebx
	jmp initDiv
;checks if ebx is 0 also. Moves eax into ebx because of the way the finding algorithm works
;If one of the numbers is 0, the GCD is 0!	
aZero: 
	cmp ebx, 0
	je throwNegError
	mov ebx,eax
	jmp setter
bZero:
	jmp return
	
initDiv:
	cmp eax,ebx
	jl swap
	jmp findGCD

swap:
	xchg eax,ebx
	jmp findGCD
	
findGCD:
	cmp ebx,0
	je setter
	push ebx
	jmp divider
GCDiv:
	mov ebx,eax
	pop eax
	jmp findGCD

divider:
	cmp	eax, ebx
	jl	GCDiv
	sub	eax, ebx
	jmp	divider	
	
;Error in case both are 0	
throwNegError:
	mov eax, errorMsg
	call print_string
	jmp exit0
	
setter:
mov [tempVar],eax
jmp return	
;Final outputMsg	
return:
	mov eax, outputMsg
	call print_string
	
	mov eax,[tempVar]
	call print_int
	
;Exit sequence
exit0:	popad
        mov eax, 0      
        leave                     
        ret