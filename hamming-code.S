#***************************************
#
# Author's Name: Amitesh Sharma
# Author's Email: amiteshs@buffalo.edu
# Course: CSE341
# Assignment: Project 1
# Summary of Assignment Purpose: Your momma
#
#***************************************

.data 0x10000000
menu_prompt: .asciiz "\nChoose an operation of choice: Encoder(E/e), Decoder(D/d), Terminate(T/t):\n"

.data 0x10000100
invalid_prompt: .asciiz "\nInvalid Input, Please try again!\n"

.data 0x10000200
terminate_prompt: .asciiz "\nThanks, please don't come again!\n"

.data 0x10000300
encoder_prompt: .asciiz "\nProvide the 11-bit binary sequence to encode:\n"

.data 0x10000400
decoder_prompt: .asciiz "\nProvide the 16-bit binary sequence to decode:\n"

.data 0x10000500	
user_menu_input: 
.space 1

.data 0x10000600	
user_encode_input:
.space 11

.data 0x10000700	
user_decode_input:
.space 16

.data 0x10000800	
final_encode_input:
.space 16

.data 0x10000900
final_encoder: .asciiz "\nThe encoded result is:\n"

.text
main:

		#print option msg
	lui $t0, 0x1000				#point $t0 to hi(msg)
	ori $v0, $zero, 4				#syscall 4 (print_str)
	addi $a0, $t0, 0x0000			# point $ao to lo(msg)
	syscall					# print the string

		#take user input
	ori $v0, $zero, 12			#syscall 12 (user input)
	addi $a0, $t0, 0x0500			#point $a0 to user_menu_input
	syscall					#user input

	add $t1, $zero, $v0			#load the input into $t1

		#option choices
	addi $t2, $zero, 'E'
	beq $t1, $t2, encoder			#if $t1 == 'E' (Encoder)
	or $zero, $zero, $zero			#nop
	addi $t2, $zero, 'e'
	beq $t1, $t2, encoder			#if $t1 == 'e' (Encoder)
	or $zero, $zero, $zero			#nop
	addi $t2, $zero, 'D'
	beq $t1, $t2, decoder			#if $t1 == 'D' (Decoder)
	or $zero, $zero, $zero			#nop
	addi $t2, $zero, 'd'
	beq $t1, $t2, decoder			#if $t1 == 'd' (Decoder)
	or $zero, $zero, $zero			#nop
	addi $t2, $zero, 'T'
	beq $t1, $t2, terminator		#if $t1 == 'T' (Terminate)
	or $zero, $zero, $zero			#nop
	addi $t2, $zero, 't'
	beq $t1, $t2, terminator		#if $t1 == 't' (Terminate)
	
	jr invalidator				#otherwise invalid
	
		#exit
	ori $v0, $zero, 10			#syscall 10 (exit)
	syscall					#terminate

invalidator:
		
		#print invalid msg
	lui $t0, 0x1000				#point $t0 to hi(msg)
	ori $v0, $zero, 4			#syscall 4(print_str)
	addi $a0, $t0, 0x0100			#point $a0 to lo(msg)
	syscall					#print the string

	jr main					#jump back to main
	

terminator:
	
		#print try again msg
	lui $t0, 0x1000				#point $t0 to hi(msg)
	ori $v0, $zero, 4				#syscall 4(print_str)
	addi $a0, $t0, 0x0200			#point $a0 to lo(msg)
	syscall					#print the string

		#exit
	ori $v0, $zero, 10			#syscall 10 (exit)
	syscall					#terminate


encoder:

		#print 11-bit input msg
	lui $t0, 0x1000				#point $t0 to hi(msg)
	ori $v0, $zero, 4				#syscall 4(print_str)
	addi $a0, $t0, 0x0300			#point $a0 to lo(msg)
	syscall					#print the string

		#take user input
	ori $v0, $zero, 8				#syscall 8 (user input)
	addi $a0, $t0, 0x0600			#point $a0 to user_encoder_input
	syscall					#user input

	addi $t1, $t0, 0x0600			#load the binary into $t1

#PARITY BIT 1!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	add $t2, $zero, $zero			#parity bit 1

#BIT 1
		#read the bit at position 1
	lb $s1, 10($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t2, 1				#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t2, $t4, 0				#save result in the parity bit
	
	
#BIT 2
		#read the bit at position 2
	lb $s1, 9($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t2, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t2, $t4, 0				#save result in the parity bit

#BIT 4
		#read the bit at position 4
	lb $s1, 7($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t2, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t2, $t4, 0				#save result in the parity bit

#BIT 5
		#read the bit at position 5
	lb $s1, 6($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t2, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t2, $t4, 0				#save result in the parity bit

#BIT 7
		#read the bit at position 7
	lb $s1, 4($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t2, 1			#if(read bit = 1) then
	and $t4, $s2, $t3			#flip parity bit
	ori $t2, $t4, 0				#save result in the parity bit

#BIT 9
		#read the bit at position 9
	lb $s1, 2($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t2, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t2, $t4, 0				#save result in the parity bit

#BIT 11
		#read the bit at position 11
	lb $s1, 0($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t2, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t2, $t4, 0				#save result in the parity bit

	nor $t2, $t2, $zero

#PARITY BIT 2!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	add $t9, $zero, $zero			#parity bit 1

#BIT 1
		#read the bit at position 1
	lb $s1, 10($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t9, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t9, $t4, 0				#save result in the parity bit
	
	
#BIT 2
		#read the bit at position 2
	lb $s1, 8($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t9, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t9, $t4, 0				#save result in the parity bit

#BIT 4
		#read the bit at position 4
	lb $s1, 7($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t9, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t9, $t4, 0				#save result in the parity bit

#BIT 5
		#read the bit at position 5
	lb $s1, 5($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t9, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t9, $t4, 0				#save result in the parity bit

#BIT 7
		#read the bit at position 7
	lb $s1, 4($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t9, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t9, $t4, 0				#save result in the parity bit

#BIT 9
		#read the bit at position 9
	lb $s1, 1($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t9, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t9, $t4, 0				#save result in the parity bit

#BIT 11
		#read the bit at position 11
	lb $s1, 0($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t9, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t9, $t4, 0				#save result in the parity bit

	nor $t9, $t9, $zero

#PARITY BIT 3!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	add $t8, $zero, 1			#parity bit 1

#BIT 2
		#read the bit at position 2
	lb $s1, 9($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t8, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t8, $t4, 0				#save result in the parity bit
	
	
#BIT 3
		#read the bit at position 3
	lb $s1, 8($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t8, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t8, $t4, 0				#save result in the parity bit

#BIT 4
		#read the bit at position 4
	lb $s1, 7($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t8, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t8, $t4, 0				#save result in the parity bit

#BIT 8
		#read the bit at position 8
	lb $s1, 3($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t8, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t8, $t4, 0				#save result in the parity bit

#BIT 9
		#read the bit at position 9
	lb $s1, 2($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t8, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t8, $t4, 0				#save result in the parity bit

#BIT 10
		#read the bit at position 10
	lb $s1, 1($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t8, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t8, $t4, 0				#save result in the parity bit

#BIT 11
		#read the bit at position 11
	lb $s1, 0($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t8, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t8, $t4, 0				#save result in the parity bit

	nor $t8, $t8, $zero

#PARITY BIT 4!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	add $t7, $zero, $zero			#parity bit 1

#BIT 5
		#read the bit at position 5
	lb $s1, 6($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t7, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t7, $t4, 0				#save result in the parity bit
	
	
#BIT 6
		#read the bit at position 2
	lb $s1, 5($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t7, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t7, $t4, 0				#save result in the parity bit

#BIT 7
		#read the bit at position 7
	lb $s1, 4($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t7, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t7, $t4, 0				#save result in the parity bit

#BIT 8
		#read the bit at position 8
	lb $s1, 3($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t7, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t7, $t4, 0				#save result in the parity bit

#BIT 9
		#read the bit at position 9
	lb $s1, 2($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t7, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t7, $t4, 0				#save result in the parity bit

#BIT 10
		#read the bit at position 10
	lb $s1, 1($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t7, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t7, $t4, 0				#save result in the parity bit

#BIT 11
		#read the bit at position 11
	lb $s1, 0($t1)				#load rightmost bit on $s1
	addi $s1, $s1, -48			#convert the ascii val to 1 or 0
	and $s2, $s1, 1				#to see if it's 0 or 1

	xori $t3, $t7, 1			#if(read bit = 1) then
	and $t4, $s2, $t3				#flip parity bit
	ori $t7, $t4, 0				#save result in the parity bit

	nor $t7, $t7, $zero

	
#SETTING EVERYTHING TOGETHER
	add $t6, $t0, 0x0800
	lb $s1, 0($t1)
	sb $s1, 0($t6)
	lb $s1, 1($t1)
	sb $s1, 1($t6)
	lb $s1, 2($t1)
	sb $s1, 2($t6)
	lb $s1, 3($t1)
	sb $s1, 3($t6)
	lb $s1, 4($t1)
	sb $s1, 4($t1)
	lb $s1, 5($t6)
	sb $s1, 5($t1)
	lb $s1, 6($t6)
	sb $s1, 6($t1)
	sb $t7, 7($t6)
	lb $s1, 7($t1)
	sb $s1, 8($t6)	
	lb $s1, 8($t1)
	sb $s1, 9($t6)	
	lb $s1, 9($t1)
	sb $s1, 10($t6)
	sb $t8, 11($t6)
	lb $s1, 10($t1)
	sb $s1, 12($t6)
	sb $t9, 13($t6)
	sb $t2, 14($t6)
	sb $zero, 15($t6)
	
	


#PRINT TEST!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

	ori $v0, $zero, 4			#syscall 4(print_str)
	addi $a0, $t0, 0x0900			#point $a0 to lo(msg)
	syscall					#print the string

	ori $v0, $zero, 4				#syscall 4(print_str)
	addi $a0, $t0, 0x0800			#tryna make $a0 point to the read bit
	syscall
	
	j main
	

decoder:

		#print 16-bit input msg
	lui $t0, 0x1000			#point $t0 to hi(msg)
	ori $v0, $zero, 4			#syscall 4(print_str)
	addi $a0, $t0, 0x0400		#point $a0 to lo(msg)
	syscall					#print the string

		#take user input
	ori $v0, $zero, 8			#syscall 8 (user input)
	addi $a0, $t0, 0x0700			#point $a0 to user_encoder_input
	syscall					#user input


		#exit
	ori $v0, $zero, 10		#syscall 10 (exit)
	syscall				#terminate
