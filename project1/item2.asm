var: 
	.data
num:	.word  0x0000FACE #define in 'num'
	.text
	
__start:
	lhu $s1, num #Load the information in 'num' and save in 's1
	and $s2, $s1, 0x000000F0 #Do the operation AND to select the information in the second byte and puts in 's2'
	sll $s2, $s2, 8 #Shift 2 bytes to left the information in 's2'
	
	and $s3, $s1, 0x0000F000 #Do the operation AND to select the information in the fourth byte and puts in 's3' 
	srl $s3, $s3, 8 #Shift 2 bytes to right the information in 's3'
	or $s2, $s2, $s3 #Do the operation OR with 's2' and 's3' to add the value and save in 's2'
	
	and $s4, $s1, 0x00000F0F #Do the operation AND to select the first and the third byte and save in 's4'
	or $s2, $s2, $s4 #Do the operation OR 's2' and 's4' to add the value and save in 's2'
	
	
