;;; Advent of Code 2015 Day 1 Part 1


section .data
	file   	db 'aoc_2015-1.dat', 0 ; data file name
	floor  	db 16 dup (0)	; what floor is Santa on?

section .bss
	instruc resb 8000 	; Santa's instructions
	                        ;  as a string	

section .text
	global _start

_start:	mov 	rax, 2          ; The system call for SYS_OPEN
	lea 	rdi, file       ; File name
	mov 	rsi, 0          ; O_RDONLY
	mov	rdx, 0
	syscall              	; Call the kernel

	push 	rax	
	mov 	rdi, rax        ; The system call for 
	mov 	rax, 0	     	; SYS_READ
	mov 	rsi, instruc
	mov 	rdx, 7999
	syscall              	; Call the kernel

	mov 	rax, 3	     	; SYS_CLOSE			
	pop 	rdi
	syscall


	xor 	rax, rax
	lea 	rdi, instruc
	
read:	cmp 	byte [rdi], '('
	jz 	up

	cmp 	byte [rdi], ')'
	jz 	down

	jmp 	finish 		; everything else (eg 0 or EOF) falls through
	
up:	inc 	rax		; one floor higher
	inc	rdi
	jmp 	read
	
down:	dec 	rax		; one floor lower
	inc 	rdi
	jmp 	read
	

finish:	mov 	rcx, 10	       	; convert the binary answer in rax to its
	xor 	rbx, rbx	;  ascii representation as a string of 
get_dg: xor 	rdx, rdx	;  digits
	div 	rcx
	push 	dx
	inc	bx
	test 	rax, rax
	jnz 	get_dg		; get_next_digit

	mov 	cx, bx
	lea 	rsi, floor

next_dg:pop 	ax	   	; next digit	
	or 	al, '0'		; set the 6th bit (the actual conversion to
	mov 	[rsi], al	;   an ascii char)
	inc 	rsi
	loop 	next_dg
	mov 	byte [rsi], 10 	; add a line feed, \n to the end of the
	inc 	bx		;   string and account for it
 
	mov     rax, 1      	; SYS_WRITE
	mov     rdi, 1      	; STDOUT
	lea	rsi, floor   	; 
	mov 	rdx, rbx
	syscall             	; call the kernel

	mov 	rax, 60	     	; SYS_EXIT
	mov 	rdi, 0	     	; Exit with return code of 0 (no error)
	syscall		     	; bye bye!

