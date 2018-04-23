var:
	.data
num:	.word 0x55555555 #define in 'num'

	.text

__start:
	lw $s1, num #Load the information in 'num' and save in 's1
	sll $s2, $s1, 1 #shift to left 1 bit and save in 's2'
	or $s3, $s1, $s2 #Do the operation OR with 's2' and 's1' to add and produce a value and save in 's3' 
	and $s4, $s1, $s2 #Do the operation AND making the product between 's2' and 's1' and save the value in 's4'
	xor $s5, $s1, $s2 #Do the operation XOR to compare 's2' and 's1' and save the value in 's5'
