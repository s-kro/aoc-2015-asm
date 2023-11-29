;;; Advent of Code 2015 Day 1 Part 2


section .data
	file   	db 'aoc_2015-1.dat', 0 ; data file name
	bsmnt_i db 16 dup (0)	; the instruction that took Santa 
				;   into the basement
section .bss
	instruc resb 8000 	; Santa's instructions
	                        ;  as a string	

section .text
	global _start

_start:	mov 	rax, 2          ; SYS_OPEN
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
	xor 	rdi, rdi
	lea 	rbx, instruc
	
read:	cmp 	byte [rbx + rdi], '('
	jz 	up

	cmp 	byte [rbx + rdi], ')'
	jz 	down

	jmp 	error 		; EOF or 0, never entered the basement???
	
up:	inc 	rax		; one floor higher
	inc	rdi
	jmp 	read
	
down:	dec 	rax		; one floor lower
	inc 	rdi
	cmp	rax, 0
	jge 	read		; still not in the basement
	

finish: mov     rax, rdi
	mov 	rcx, 10	       	; convert the binary answer in rax to its
	xor 	rbx, rbx	;  ascii representation as a string of 
get_dg: xor 	rdx, rdx	;  digits
	div 	rcx
	push 	dx
	inc	bx
	test 	rax, rax
	jnz 	get_dg		; get_next_digit

	mov 	cx, bx
	lea 	rsi, bsmnt_i

next_dg:pop 	ax	   	; next digit	
	or 	al, '0'		; set the 6th bit (the actual conversion to
	mov 	[rsi], al	;   an ascii char)
	inc 	rsi
	loop 	next_dg
	mov 	byte [rsi], 10 	; add a line feed, \n to the end of the 
	inc 	bx	        ;   string and account for it

	mov     rax, 1      	; SYS_WRITE
	mov     rdi, 1      	; STDOUT
	lea	rsi, bsmnt_i   	; 
	mov 	rdx, rbx
	syscall             	; call the kernel

	mov 	rax, 60	     	; SYS_EXIT
	mov 	rdi, 0	     	; Exit with return code of 0 (no error)
	syscall		     	; see ya!

error:	mov 	rax, 60	     	; SYS_EXIT
	mov 	rdi, 1	     	; Exit with return code of 1 (error)
	syscall
