.data
	a: .word 0
	b: .word 0
	p: .word 0
	z: .word 0
	
	resp1: .asciiz "A exponencial modular "
	resp2: .asciiz " elevado a "
	resp3: .asciiz " (mod "
	resp4: .asciiz ") eh "
	resp5: .asciiz ".\n"
	
	error: .asciiz "O modulo nao eh primo.\n"

.text

main:
	# AA = S0, BB = S1, PP = S2, ZZ = S3
	# AA ^ BB (mod PP) = ZZ
	
	jal le_inteiro
	sw $v0, a # save return in a
	
	jal le_inteiro
	sw $v0, b # save return in b
	
	jal le_inteiro
	sw $v0, p # save return in p
	
	lw $a0, p # pass p as arg to eh_primo func
	jal eh_primo # call func
	
	bnez $v0, primo # if return of fun is not 0, jump
		jal imprime_erro # if return is 0, call imprime_erro
	
	j exit_prog
	
	primo:
	
	jal calc_exp
	sw $v0, z
	
	jal imprime_saida
	
	j exit_prog
	
le_inteiro:
	
	li $v0, 5 # send syscal to read integer
	syscall

	jr $ra # v0 is already the integer

eh_primo:
	
	# a number is prime when it is only divisible by itself and 1
	
	li $t0, 0 # load false in t0 (result = false)
	
	blez $a0, return_eh_primo # if a0 == 0, return false
	
	beq $a0, 1, return_true_eh_primo
	beq $a0, 2, return_true_eh_primo
	
	move $t1, $a0 # i = a0 - 1
	sub $t1, $t1, 1
	
	li $t2, 2 # end = 2
	
	loop_eh_primo: # for i = a0-1; i >= 2; i--
		# i == t1
		# end == t2
		# test_num == a0		
		
		div $t3, $a0, $t1 # t3 = test_num / i
		mfhi $t4 # t4 = test_num % i
		
		beqz $t4, return_eh_primo # if t4 == 0, return false
		
		sub $t1, $t1, 1		
		bge $t1, $t2, loop_eh_primo  # if i >= end, loop
		
	# outside loop
	# if we arrived here, the number is prime
	return_true_eh_primo:
	li $t0, 1 # load false in t0 (result = true)
	
	return_eh_primo:
	move $v0, $t0 # load the result to return var 
	
	jr $ra # return result

calc_exp:

	li $t0, 1 # i = 0
	lw $v0, a # return var = a
	lw $t5, a
	lw $t7, b
	
	loop_calc_exp: # for i = 0; i < b; i++
		
		mul $v0, $v0, $t5 # return var = return var * a
	
		add $t0, $t0, 1 # i++
		bne $t0, $t7, loop_calc_exp # i < b ? loop
		
	# v0 = a pow b
	
	lw $t6, p
	div $t4, $v0, $t6  # t4 = v0 / b
	mfhi $v0 # v0 = v0 % b
	
	jr $ra # return result (v0)

imprime_erro:
	la $a0, error
	
	li $v0, 4 # send syscal to print string
	syscall

	jr $ra	

imprime_saida:
	
	la $a0, resp1
	
	li $v0, 4 # send syscal to print string
	syscall
	
	lw $a0, a
	
	li $v0, 1 # send syscal to print int
	syscall

	la $a0, resp2
	
	li $v0, 4 # send syscal to print string
	syscall
	
	lw $a0, b
	
	li $v0, 1 # send syscal to print int
	syscall
	
	la $a0, resp3
	
	li $v0, 4 # send syscal to print string
	syscall
	
	lw $a0, p
	
	li $v0, 1 # send syscal to print int
	syscall
	
	la $a0, resp4
	
	li $v0, 4 # send syscal to print string
	syscall
	
	lw $a0, z
	
	li $v0, 1 # send syscal to print int
	syscall
	
	la $a0, resp5
	
	li $v0, 4 # send syscal to print string
	syscall
	
	jr $ra
	
exit_prog:
	li $v0, 10 # exit
	syscall 
