;;; CSAS 2125 Fall 2014 T. Marlowe
	
;;;
;;; file: arraymax.asm
;;;	computes the maximum element in an array of up to 20 elements
;;;	

	;; NEW definition of a compile-time constant
%define maxlen 20
	;; alternative form for the definition
; maxlen	EQU		20

%include "asm_io.inc"

; initialized data is put in the .data segment

segment .data

prompt1 	db		"Enter the length of your array: ", 0       
	;; don't forget nul terminator
prompt2 	db		"Enter next entry of your array: ", 0
outmsga		db		"Your array was A = ", 0
spaces		db		"  ", 0
outmsg1 	db		"	The maximum is ", 0
errmsg		db		"Length must be between 1 and ", 0

;; uninitialized data is put in the .bss segment

segment .bss

length		resd 	1		; note length is determined implicitly
A		resd	maxlen		; now need to check length for value

;; code is put in the .text segment

segment .text				;; don't change this 
					;; initial boilerplate
	global  _asm_main		;;
_asm_main:				;;
    	enter	0,0			;; setup routine	
	pushad
	pushf				;; end of boilerplate

	;; read the length--note have to check it's legal
	mov	eax, prompt1      	; print out prompt
	call	print_string

	call 	read_int          	; read integer

	;; NEW handle long jumps
	;;	jump around an unconditional jump to a _continue_ label
	cmp	eax, 0			; make sure _length_ > 0
	jg	cont2
	jmp	error1		
cont2: 	cmp	eax, maxlen		; make sure _length_ <= maxlen
	jle	cont1
	jmp	error1

cont1: 	mov	[length], eax     	; store into length
	mov	edi, eax		; and into edi
		
	;; NEW read in an array
	;; NEW may need both index and offset
	;;	store offset in ebx, esi, or edi
	;; Can get around storing both by using SHL/SHR or other tricks
	
	mov	ecx, 0			; index
	mov	ebx, 0			; offset = 4 * index

backread:				; NEW read array elements
	cmp	ecx, edi		; no more to read
	jge	readdone

	mov 	eax, prompt2		; print out prompt
	call	print_string

	call 	read_int	        ; read integer
	mov	[A + ebx], eax	  	; store into A[index]

	add	ecx, 1			; get ready for next iteration
	add	ebx, 4			; 	could use copy and shift
	jmp	backread

readdone:

	;; computation

	mov	ebx, 0			; EBX holds the offset--start over
	mov	ecx, 0			; ECX holds the count
	mov	edx, [A + ebx]		; EDX holds the current element
	mov	esi, edx		; ESI holds the current max

nextel: add	ecx, 1
	cmp	[length], ecx		; have we seen them all?
					; could have used MOV EAX, [length]
					; and then used EAX in place of [length]
	jle	outmax

	add	ebx, 4			; four more bytes onward
	mov	edx, [A + ebx]		; get the current element
	cmp	edx, esi		; is current > max?
	jle	nodelta			; if no, don't chance max
	mov	esi, edx		; yes--move current to max

nodelta:				; works just like jump transformation
	jmp	nextel

outmax:
	mov 	eax, outmsga		; print out prompt
	call	print_string

	;; NEW write out an array
	mov	ecx, 0			; index
	mov	ebx, 0			; offset = 4 * index

backwrt:				; NEW write array elements
	cmp	ecx, [length]		; no more to write
	jge	wrtdone

	mov	eax, [A + ebx]		; array element to be written 
	call 	print_int	        ; write integer

	mov	eax, spaces
	call	print_string
	mov	[A + ebx], eax	  	; store into A[index]

	add	ecx, 1			; get ready for next iteration
	add	ebx, 4			; could use copy and shift
	jmp	backwrt

wrtdone:

	call	print_nl		; now print the MAX
    	
	mov	eax, outmsg1
	call	print_string

	mov 	eax, esi
	call	print_int
	call	print_nl

	;; NEW jump around error handler
	jmp	go_out

	;; NEW error handler
error1: mov	eax, errmsg
	call	print_string
	mov	eax, maxlen
	call	print_int
	call	print_nl

go_out:

	popf			; terminal boilerplate
 	popad				
	mov	eax, 0 		; return back to C	
				; always use this
	leave			;
	ret			; end of terminal boilerplate

