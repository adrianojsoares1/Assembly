;;; 
;;; Template for assembler programs
;;; 

%include "asm_io.inc"
%define MAXLEN 20
	
;;; Can also declare constants to be used in declaring variables
	;; Use "length EQU 20" or "%define length 20"
	
	segment .data

lengthPrompt	db	"Enter the length of your array: ", 0
arrayPrompt	db	"Enter an array entry: ", 0
outmsg1		db	"The sum of the entries ", 0
spacer		db	", ", 0
outmsg2		db	" is ", 0
outmax		db	". The Maximum Integer is: " , 0
	; MODIFIED: print MAXLEN as an integer
lengthError	db	"Length must be between 1 and ", 0
overError	db	"Overflow has occurred", 0	
	
	segment .bss

A	resd	MAXLEN

	segment .text
	;; this is the code segment
	
	;; initial boilerplate--do not change
	global _asm_main
_asm_main:
	enter	0, 0
	pushad
	pushf

	;; get the length of the array
	mov	eax, lengthPrompt
	call	print_string
	call	read_int
	
	cmp	eax, 0 ;checks if int is less than or equal to 0 - if so no good
	jle	throwerror
	
	cmp	eax, MAXLEN ;checks if int is greater than the max int - if so no good
	jg	throwerror	
	jmp	noError ;If integer is within the bounds, then proceed with computations

throwerror:
	mov eax, lengthError
	call print_string
	jmp lenErr
	
noError:				
	mov	edx, eax	; length is accepted
	
	;; read in the values
	mov	ecx, 0		; input loop
	mov	ebx, ecx	; reset to 0
	
getEntries:
	cmp ecx,edx
	jge clear1 ;Stop when edx(length of array) is reached
	
	mov	eax, arrayPrompt ;Move the prompt to eax then print it
	call	print_string
	call	read_int ;Take in the int for array
	mov	[A + ebx], eax ;Store the entry into a memory location
	
	inc ecx
	
	add	ebx, 5
	
	jmp	getEntries ; Loop until entries are complete

clear1:	 ;clear values
	mov	ecx, 0
	mov	ebx, ecx
	
	mov	edi, 0		; contains the sum of the entries
	
addNums:
	cmp	ecx, edx
	jge	clear2 ;escape sequence
	
	mov	eax, [A + ebx] ;add memory location 
	add	edi, eax ;add
	
	inc	ecx ;add 1 to ecx
	add	ebx, 5
	jmp	addNums ;return to loop

clear2: ;clear ecx and ebx for further testing
	mov ecx, 0
	mov ebx, 0
	mov esi, 0 ;contains the maximum of the entries
	
findMax:
	cmp ecx,edx ;escape sequence
	jge clearAndOutput
	
	cmp [A + ebx], esi
	jg largerThan ;Larger than? If so, then jmp to largerThan
	
	inc ecx
	add ebx, 5
	jmp findMax ;update variables and re-loop

largerThan:	
	mov esi, [A + ebx] ;Set the larger variable to esi
	jmp findMax
	
clearAndOutput: ;clear, and output the first statement.
	mov	eax, outmsg1
	call	print_string
	
	mov	ecx, 0
	mov	ebx, 0
	
printOutNums:
	cmp	ecx, edx ;escape sequence
	jge	printSum
	mov	eax, [A + ebx]
	call	print_int ;print the variable at ml [A+ebx]

	inc	ecx
	add	ebx, 5	;update variables
	
	cmp	ecx, edx	;is this the last number?
	jge	noSpacer	;if yes, dont add a space
	mov	eax, spacer ;if no, add a space
	call	print_string ;print

noSpacer:
	jmp	printOutNums ;dont print a space

printSum:
	mov	eax, outmsg2
	call	print_string
	mov	eax, edi	; EDI contains the sum
	call	print_int
	mov eax, outmax
	call	print_string
	mov eax,esi ;ESI contains the maximum value
	call	print_int
	
	
	jmp		endit
	
lenErr:
	;; Throws error if the array is too long and informs user on maximum length of array
	mov	eax, lengthError
	call	print_string
	mov	eax, MAXLEN
	call	print_int
	jmp	endit

overErr: ;Overflow? Jump here and print error.
	mov	eax, overError
	call	print_string
	
endit: ;finis
	call	print_nl

	;; terminal boilerplate--do not change this

	popf
	popad
	mov	eax, 0
	leave
	ret
	
