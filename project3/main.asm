#A raiz cubica ? ZZ. O erro estimado eh de YY
#the numb is (0 < x < 1) 

.data
	error: .asciiz "Out of Range"

	numb: .float 0.0  #the value
	result_numb: .float 0.0 # the cubic root of 'numb'
	
	step: .float 0.001f

	lower_limit: .float 0.0
    	lower_limit_cubed: .float 0.0f
    
   	upper_limit: .float 0.001
	upper_limit_cubed: .float 0.000000001f
    

	root_aprox: .float 0.0
   	root_aprox_cubed: .float 0.0

	cubic_pow: .float 0.0 # numb ^ 3
   	estimate: .float 0.0  #estimate error

   	constant0: .float 0.0
    	constant1: .float 1.0
	constant2: .float 2.0

	result1: .asciiz "A raiz cubica eh "
	result2: .asciiz ". O erro estimado eh de "
	result3: .asciiz "\n"
.text
	
main:
	
	jal le_float 
	s.s $f0, numb # save return in 'numb'
	
	lwc1 $f0, numb # pass n as arg check_float
	jal check_float
	jal calc_raiz
	jal calc_erro
	jal imprime_saida
	jal exit_prog
	
	
check_float:
	# if (x > 0) return float
	# if (x <= 1) return float
	
	l.s $f1, constant0 # 0
	l.s $f2, constant1 # 1
	
	greater_than_zero:
		c.lt.s $f1, $f0 # check if 0 < numb 
		bc1t less_than_one # if true jump next test
		bc1f not_in_range #if false jump not_in_range
	
	less_than_one:
		c.le.s $f0, $f2 # check if x <= 1
		bc1t in_range # if true jump in_range
		bc1f not_in_range # if false jump not_in_range
	
		not_in_range:
			la $a0, error
			li $v0, 4
			syscall
		
			j exit_prog
	
		in_range:
			jr $ra #return var
					
	
le_float:
	li $v0, 6 # syscall to read float
	syscall
	
	jr $ra

calc_raiz:

	# the reverse of power function is the root
	# we need to do cubic root

	# f0 = input number

	# f2 = constant2 = 2.0

	# f5 = lower_limit
	# f6 = lower_limit_cubed

	# f7 = upper_limit
	# f8 = upper_limit_cubed

	# f9 = root_aprox
	# f10 = root_aprox_cubed
    
	# f4 = step

	lwc1 $f0, numb

	lwc1 $f2, constant2
	
	lwc1 $f4, step # step = 0.001f

	lwc1 $f5, lower_limit 
	lwc1 $f6, lower_limit_cubed

	lwc1 $f7, upper_limit 
	lwc1 $f8, upper_limit_cubed

	lwc1 $f9,  root_aprox 
	lwc1 $f10, root_aprox_cubed

  	# we want to find when lower_limit_cubed < lower_limit < upper_limit_cubed

	# lower_limit_cubed < lower_limit && lower_limit < upper_limit_cubed
	c.lt.s $f6, $f0 # lower_limit_cubed < numb
	bc1f loop_find_limits
	c.lt.s $f0, $f8 # numb < upper_limit_cubed
	bc1t end_loop_find_limits

	loop_find_limits:

		mov.s $f5, $f7 # lower_limit = upper_limit
		add.s $f7, $f7, $f4 # upper_limit += upper_limit

		# lower_limit_cubed = lower_limit * lower_limit * lower_limit = lower_limit^3
		mul.s $f6, $f5, $f5 
		mul.s $f6, $f6, $f5

		# upper_limit_cubed = upper_limit * upper_limit * upper_limit= upper_limit^3
		mul.s $f8, $f7, $f7 
		mul.s $f8, $f8, $f7

		c.lt.s $f6, $f0 # lower_limit_cubed < numb
		bc1f loop_find_limits
		c.lt.s $f0, $f8 # numb < upper_limit_cubed
		bc1f loop_find_limits

	end_loop_find_limits:
		# exit loop_find_limits

		li $t1, 0 # t1 = i = 0
		li $t2, 10 # t2 = iterations = 10

	loop_find_root:
		# for (int i = 0; i < iterations; i++)
	
		add.s $f9, $f5, $f7 # root_aprox = lower_limit + upper_limit
		div.s $f9, $f9, $f2 # root_aprox = root_aprox / 2

		# root_aprox_cubed = root_aprox * root_aprox * root_aprox = root_aprox^3
		mul.s $f10, $f9, $f9
		mul.s $f10, $f10, $f9

		# if root_aprox_cubed < numb
		c.lt.s $f10, $f0
		bc1f elseif_find_root
		mov.s $f5, $f9 # lower_limit = root_aprox
		j end_elseif_find_root
		
		elseif_find_root:
		# else if numb < root_aprox_cubed
			c.lt.s $f0, $f10
			bc1f end_elseif_find_root
			mov.s $f7, $f9 # upper_limit = root_aprox

		end_elseif_find_root:

		addi $t1, $t1, 1 # i++
		beq $t1, $t2, end_loop_find_root # if i == iterations then finish loop
		
	end_loop_find_root:

	s.s $f9, result_numb

	jr $ra
    
    
cubic_power:
	lwc1 $f2, numb

	mul.s $f1, $f2, $f2
	mul.s $f1, $f0, $f1 # cubic_numb = numb * numb *numb

	jr $ra
    
calc_erro:
	lwc1 $f0, numb
	lwc1 $f1, result_numb
	lwc1 $f2, estimate

	# f3 = result_numb ^ 3
	mul.s $f3, $f1, $f1
	mul.s $f3, $f3, $f1 # cubic_numb = numb * numb *numb

	# error = numb - (result_num ^ 3)
	sub.s $f2, $f0, $f3
	abs.s $f2, $f2

	s.s $f2, estimate

	jr $ra

imprime_saida:
	
	la $a0, result1
	
	li $v0, 4 # syscall to print string 
	syscall
	
	lwc1 $f12, result_numb
	
	li $v0, 2 # syscall to print float
	syscall
	
	la $a0, result2
	
	li $v0, 4 # syscall to print string
	syscall
	
	lwc1 $f12, estimate
	
	li $v0, 2 # syscall to print float
	syscall
	
	la $a0, result3
	
	li $v0, 4 # syscall to print string
	syscall
	
	jr $ra
	

exit_prog:
	li $v0, 10
	syscall # exit program
