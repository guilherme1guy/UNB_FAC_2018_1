#A raiz cubica ? ZZ. O erro estimado eh de YY
#the numb is (0 < x < 1) 

.data
	error: .asciiz "Out of Range"

	numb: .double 0.0  #the value
	result_numb: .double 0.0 # the cubic root of 'numb'
	
	step: .double 0.001f

	lower_limit: .double 0.0
	lower_limit_cubed: .double 0.0f
    
   	upper_limit: .double 0.001
	upper_limit_cubed: .double 0.000000001f
    

	root_aprox: .double 0.0
   	root_aprox_cubed: .double 0.0

	cubic_pow: .double 0.0 # numb ^ 3
   	estimate: .double 0.0  #estimate error

   	constant0: .double 0.0
	constant1: .double 1.0
	constant2: .double 2.0

	result1: .asciiz "A raiz cubica eh "
	result2: .asciiz ". O erro estimado eh de "
	result3: .asciiz "\n"
.text
	
main:
	
	jal le_double 
	s.d $f0, numb # save return in 'numb'
	
	l.d $f0, numb # pass n as arg check_double
	jal check_double
	jal calc_raiz
	jal calc_erro
	jal imprime_saida
	jal exit_prog
	
	
check_double:
	# if (x > 0) return double
	# if (x <= 1) return double
	
	#f1 f2 = const0
	#f2 f4 const1

	l.d $f2, constant0 # 0
	l.d $f4, constant1 # 1
	
	greater_than_zero:
		c.lt.d $f2, $f0 # check if 0 < numb 
		bc1t less_than_one # if true jump next test
		bc1f not_in_range #if false jump not_in_range
	
	less_than_one:
		c.le.d $f0, $f4 # check if x <= 1
		bc1t in_range # if true jump in_range
		bc1f not_in_range # if false jump not_in_range
	
		not_in_range:
			la $a0, error
			li $v0, 4
			syscall
		
			j exit_prog
	
		in_range:
			jr $ra #return var
					
	
le_double:
	li $v0, 7 # syscall to read double
	syscall
	
	jr $ra

calc_raiz:

	# the reverse of power function is the root
	# we need to do cubic root

	# f0 = input number

	# f2 = constant2 = 2.0

	# f4 = step
	
	# f6 = lower_limit
	# f8 = lower_limit_cubed

	# f10 = upper_limit
	# f12 = upper_limit_cubed

	# f14 = root_aprox
	# f16 = root_aprox_cubed   


	l.d $f0, numb

	l.d $f2, constant2
	
	l.d $f4, step # step = 0.001f

	l.d $f6, lower_limit 
	l.d $f8, lower_limit_cubed

	l.d $f10, upper_limit 
	l.d $f12, upper_limit_cubed

	l.d $f14,  root_aprox 
	l.d $f16, root_aprox_cubed

  	# we want to find when lower_limit_cubed < numb < upper_limit_cubed

	# lower_limit_cubed < numb && numb < upper_limit_cubed
	c.lt.d $f8, $f0 # lower_limit_cubed < numb
	bc1f loop_find_limits
	c.lt.d $f0, $f12 # numb < upper_limit_cubed
	bc1t end_loop_find_limits

	loop_find_limits:

		mov.d $f6, $f10 # lower_limit = upper_limit
		add.d $f10, $f10, $f4 # upper_limit += step

		# lower_limit_cubed = lower_limit * lower_limit * lower_limit = lower_limit^3
		mul.d $f8, $f6, $f6 
		mul.d $f8, $f8, $f6

		# upper_limit_cubed = upper_limit * upper_limit * upper_limit= upper_limit^3
		mul.d $f12, $f10, $f10 
		mul.d $f12, $f12, $f10

		c.lt.d $f8, $f0 # lower_limit_cubed < numb
		bc1f loop_find_limits
		c.lt.d $f0, $f12 # numb < upper_limit_cubed
		bc1f loop_find_limits

	end_loop_find_limits:
		# exit loop_find_limits

		li $t1, 0 # t1 = i = 0
		li $t2, 10 # t2 = iterations = 10

	loop_find_root:
		# for (int i = 0; i < iterations; i++)
	
		add.d $f14, $f6, $f10 # root_aprox = lower_limit + upper_limit
		div.d $f14, $f14, $f2 # root_aprox = root_aprox / 2

		# root_aprox_cubed = root_aprox * root_aprox * root_aprox = root_aprox^3
		mul.d $f16, $f14, $f14
		mul.d $f16, $f16, $f14

		# if root_aprox_cubed < numb
		c.lt.d $f16, $f0
		bc1f elseif_find_root
		mov.d $f6, $f14 # lower_limit = root_aprox
		j end_elseif_find_root
		
		elseif_find_root:
		# else if numb < root_aprox_cubed
			c.lt.d $f0, $f16
			bc1f end_elseif_find_root
			mov.d $f10, $f14 # upper_limit = root_aprox

		end_elseif_find_root:

		addi $t1, $t1, 1 # i++
		beq $t1, $t2, end_loop_find_root # if i == iterations then finish loop
		
	end_loop_find_root:

	s.d $f14, result_numb

	jr $ra
    
calc_erro:

	#f0 f20 = numb
	#f1 f22 = result_numb
	#f2 f24 = estimate

	l.d $f20, numb
	l.d $f22, result_numb
	l.d $f24, estimate

	#f3 f26 = result_numb ^ 3
	mul.d $f26, $f22, $f22
	mul.d $f26, $f26, $f22 # cubic_numb = numb * numb *numb

	# error = numb - (result_num ^ 3)
	sub.d $f24, $f20, $f26
	abs.d $f24, $f24

	s.d $f24, estimate

	jr $ra

imprime_saida:
	
	la $a0, result1
	
	li $v0, 4 # syscall to print string 
	syscall
	
	l.d $f12, result_numb
	
	li $v0, 3 # syscall to print float
	syscall
	
	la $a0, result2
	
	li $v0, 4 # syscall to print string
	syscall
	
	l.d $f12, estimate
	
	li $v0, 3 # syscall to print float
	syscall
	
	la $a0, result3
	
	li $v0, 4 # syscall to print string
	syscall
	
	jr $ra
	

exit_prog:
	li $v0, 10
	syscall # exit program
