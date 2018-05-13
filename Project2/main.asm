
.data 
	base: .asciiz "Enter with the value of base: "
	exp: .asciiz "Enter with the value of exp: "
	mod: .asciiz "Ente with the value of mod: "
	error_null: .asciiz "error: exp is Null"
	
	a: .word 0
	e: .word 0
	m: .word 0
	z: .word 0
	
	result1: .asciiz "A exponencial modular "
	result2: .asciiz "elevado a " 
	result3: .asciiz "(mod " 
	result4: .asciiz ") eh "
	result5: .asciiz ". \n"
	
	error: .asciiz "O modulo nao eh primo."
.text
	# base ^ exp (mod) = result
main: 
	li $v0, 4
	la $a0, base
	syscall
	
	jal le_inteiro
	sw $v0, a
	
	li $v0, 4
	la $a0, exp
	syscall
	
	jal le_inteiro
	jal eh_nulo
	sw $v0, e
	
	li $v0, 4
	la $a0, mod
	syscall
	
	jal le_inteiro
	jal eh_primo
	bnez $v0, check_prime
	sw $v0, m
	
	jal imprime_erro
	j end
	
	check_prime:
		jal cal_exp
		sw $v0, z
		
		jal imprime_saida
		j end
	
le_inteiro:
	li $v0, 5
	syscall
	
	jr $ra
	 	
eh_primo:
	# check if mod is prime -> (a ^ b) / m
	li $t0, 0
	
	beqz $a0, not_prime
	beq $a0, 1, true_prime
	beq $a0, 2, true_prime
	
	move $t1, $a0
	sub $t1, $t1, 1
	
	li $t2, 2	
	
	loop: # for (int i= a - 1; i >= 2; i--)
		div $t3, $a0, $t1 # prime / i
		mfhi $t3
		
		beqz $t3, not_prime
				
		sub $t1, $t1, 1
		bge $t1, $t2, loop
		
	true_prime:
		li $t0, 1
		
	not_prime:
		move $v0, $t0
		jr $ra
cal_exp:
	# a ^ b => a * a 
	li $t0, 1
	lw $v0, a
	lw $t1, a
	lw $t7, e
	
	cal_exponencial: # for (int i = 0; i < b; i++)
		mul $v0, $v0, $t1
		add $t0, $t0, 1
		bne $t0, $t7, cal_exponencial
			
	# (a ^ b)% m 	
	lw $t6, m
	div $t4, $v0, $t6
	mfhi $v0
	jr $ra
eh_nulo:
	# check exp >= 0
	beq $t0, $v0, n_eh_positivo
	jr $ra
	
	n_eh_positivo:
		li $v0, 4
		la $a0, error_null
		syscall
		j end
		
imprime_erro:
	la $a0, error
	li $v0, 4
	syscall
	
	jr $ra
imprime_saida:
	
	la, $a0, result1
	li $v0, 4
	syscall
	
	lw $a0, a
	
	li $v0, 1
	syscall
	
	la, $a0, result2
	li $v0, 4
	syscall
	
	lw $a0, e
	
	la, $a0, result3
	li $v0, 1
	syscall
	
	lw $a0, m
	
	la, $a0, result4
	li $v0, 4
	syscall
	
	lw $a0, z
	
	la, $a0, result5
	li $v0, 1
	syscall
	
	la $a0, result5
	
	li $v0, 4
	syscall
	
	jr $ra
	
end:

	li $v0, 10
	syscall
