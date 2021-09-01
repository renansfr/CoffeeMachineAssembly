######## DATA ########
	.data
fout:
	.asciiz "C:/Users/rensf/Desktop/ufsc/oa1/at10/receipt.txt"
buffer:
	.asciiz "
turnOn:
	.asciiz "-- The Machine is on --\n"
instructions:
	.asciiz "Type 101 a Coffee\nType 102 for a Coffee With Milk\nType 103 for a Hot Chocolate\nType 0 to quit\n"
choosesize:
	.asciiz "\nType 201 for a tiny cup\nType 202 for a big cup\n"
coffee:
	.asciiz "\nYour coffee is ready\n"
coffeewithmilk:
	.asciiz "\nYour coffee with milk is ready\n"
hotchocolate:
	.asciiz "\nYour hot chocolate is ready\n"
defaultMissing:
	.asciiz "\nYou're missing "
coffeeMissing:
	.asciiz " coffee powders and need to buy more\n"
milkMissing:
	.asciiz " milk powders and need to buy more\n"
chocolateMissing:
	.asciiz " chocolate powders and need to buy more\n"
powdersInfo:
	.asciiz "\n\nPowders Info:\n "
currentCoffeePowder:
	.asciiz "Coffee Powder: "
currentMilkPowder:
	.asciiz "Milk Powder: "
currentChocolatePowder:
	.asciiz "Chocolate Powder: "
jumpLine:
	.asciiz "\n"
receipt:
	.asciiz "\n\nPurchase Information: "
receiptForTinyCoffee:
	.asciiz "\nDrink type: Tiny Coffee\nPurchase Value: $0.99\n "
receiptForBigCoffee:
	.asciiz "\nDrink type: Big Coffee\nPurchase Value: $2.99\n "
receiptForTinyCoffeeWithMilk:
	.asciiz "\nDrink type: Tiny Coffee With Milk\nPurchase Value: $1.99\n "
receiptForBigCoffeeWithMilk:
	.asciiz "\nDrink type: Big Coffee With Milk\nPurchase Value: $3.99\n "
receiptForTinyHotChocolate:
	.asciiz "\nDrink type: Tiny Hot Chocolate\nPurchase Value: $2.99\n "
receiptForBigHotChocolate:
	.asciiz "\nDrink type: Big Hot Chocolate\nPurchase Value: $4.99\n "
waitingNextBuy:
	.asciiz "\nWaiting for next buy...\n "
exitMsg:
	.asciiz "-- Shutting down the Machine --\n"
flag:
	.word 0

######## TEXT SEGMENT ########
	.text
	.globl main
main:
	# Powders #
	li $t2, 20 					#Coffee powders
	li $t3, 20					#Milk powders
	li $t4, 20					#Chocolate powders
	# Beverages that will be sold #
	li $t5, 101					#Choose coffee
	li $t6, 102					#Choose coffee with milk
	li $t7, 103					#Choose hot chocolate
	#Sizes
	li $t8, 201					#Choose tiny cup		
	li $t9, 202					#Choose big cup
	# End #
	li $v0, 4					# syscall code to print a string
	la $a0, turnOn					# string to print
	syscall						# print it!
	la $a0, instructions				# string to print
	syscall						# print it!
do:
	li $v0, 5					# syscall code to read an integer value
	syscall						# wait the user input, it's going to be saved in $v0
	bne $v0, $0, checkCoffee			# if the input is not 'zero', jump the code that sets 'flag' to 1 	
	lw $t0, flag
	li $t0, 1
	sw $t0, flag					# flag is now set to 1
checkCoffee:
	bne $v0, $t5, checkCoffeeWithMilk		# if v0 == 101 it means the user wants coffee, otherwise jump to check if the user wrote the code to get a big coffee (102)
	# Coffee has been chosen
	li $v0, 4					# syscall code to print a string
	la $a0, choosesize				# string to print
	syscall						# print it!
	li $v0, 5					# syscall code to read an integer value
	syscall						# wait the user input, it's going to be saved in $v0
	bne $v0, $t8, chooseBigCoffeeCup			#if v0 == 201 it means the user wants tiny cup, otherwise jump to check if the user wrote the code to get a big cup (202)
	#Tiny cup has been chosen
	sltiu $t0, $t2, 1				# set $t0 to 1 if powder is not enough
	bgtz $t0, noSuficientTinyCoffeePowder
	addi $t2, $t2, -1				# coffee powder update
	li $v0, 4					# syscall code to print a string
	la $a0, coffee					# string to print
	syscall
	li $v0, 4					# syscall code to print a string
	la $a0, receipt					# string to print
	syscall
	li $v0, 4					# syscall code to print a string
	la $a0, receiptForTinyCoffee		# string to print
	syscall
	#Open file
	li $v0, 13
	la $a0, fout
	li $a1, 1
	li $a2, 0
	syscall
	move $s6, $v0
	#Write at file
	li $v0, 15
	move $a0, $s6
	la $a1, receiptForTinyCoffee
	li $a2, 50
	syscall
	#Close file
	li $v0, 16
	move $a0, $s6
	syscall
	j doEnd
	noSuficientTinyCoffeePowder:
		# powder is not enough!
		li $v0, 4				# syscall code to print a string
		la $a0, defaultMissing			# string to print
		syscall
		li $t0, 1
		sub $t0, $t0, $t1			# how much does the user need to get a tiny coffee?
		li $v0, 1				# syscall code to print an integer value
		li $a0, 0
		add $a0, $a0, $t0			# set $a0 to $t0 and print how much coffee powder the user will need to complete the transaction
		syscall
		li $v0, 4				# syscall code to print a string
		la $a0, coffeeMissing			# string to print
		syscall
		j doEnd
	chooseBigCoffeeCup:
		bne $v0, $t9, doEnd				# if v0 == 202 it means the user wants big cup, otherwise jump to the end of the loop
		sltiu $t0, $t2, 2				# set $t0 to 1 if powder is not enough
		bgtz $t0, noSuficientBigCoffeePowder
		addi $t2, $t2, -2				# powder update
		li $v0, 4					# syscall code to print a string
		la $a0, coffee					# string to print
		syscall
		li $v0, 4					# syscall code to print a string
		la $a0, receipt					# string to print
		syscall
		li $v0, 4					# syscall code to print a string
		la $a0, receiptForBigCoffee			# string to print
		syscall
		#Open file
		li $v0, 13
		la $a0, fout
		li $a1, 1
		li $a2, 0
		syscall
		move $s6, $v0
		#Write at file
		li $v0, 15
		move $a0, $s6
		la $a1, receiptForBigCoffee
		li $a2, 50
		syscall
		#Close file
		li $v0, 16
		move $a0, $s6
		syscall
		j doEnd
		noSuficientBigCoffeePowder:
			# powder is not enough!
			li $v0, 4				# syscall code to print a string
			la $a0, defaultMissing			# string to print
			syscall
			li $t0, 2
			sub $t0, $t0, $t2			# how much does the user need to get a big coffee?
			li $v0, 1				# syscall code to print an integer value
			li $a0, 0
			add $a0, $a0, $t0			# set $a0 to $t0 and print how much coffee powder the user will need to complete the transaction
			syscall
			li $v0, 4				# syscall code to print a string
			la $a0, coffeeMissing			# string to print
			syscall
			j doEnd
	
	
checkCoffeeWithMilk:
	bne $v0, $t6, checkHotChocolate			# if v0 == 302 it means the user wants hot chocolate, otherwise jump to the end of the loop
	# Coffee with milk has been chosen
	li $v0, 4					# syscall code to print a string
	la $a0, choosesize				# string to print
	syscall						# print it!
	li $v0, 5					# syscall code to read an integer value
	syscall						# wait the user input, it's going to be saved in $v0
	bne $v0, $t8, chooseBigCoffeeWithMilkCup			#if v0 == 201 it means the user wants tiny cup, otherwise jump to check if the user wrote the code to get a big cup (202)
	#Tiny cup has been chosen
	sltiu $t0, $t2, 1				# set $t0 to 1 if coffee powder is not enough
	bgtz $t0, noSuficientTinyCoffeeWithMilkPowder
	sltiu $t0, $t3, 1				# set $t0 to 1 if milk powder is not enough
	bgtz $t0, noSuficientTinyMilkWithCoffeePowder
	addi $t2, $t2, -1				# coffee powder update
	addi $t3, $t3, -1				# milk powder update
	li $v0, 4					# syscall code to print a string
	la $a0, coffeewithmilk				# string to print
	syscall
	li $v0, 4					# syscall code to print a string
	la $a0, receipt					# string to print
	syscall
	li $v0, 4					# syscall code to print a string
	la $a0, receiptForTinyCoffeeWithMilk		# string to print
	syscall
	#Open file
	li $v0, 13
	la $a0, fout
	li $a1, 1
	li $a2, 0
	syscall
	move $s6, $v0
	#Write at file
	li $v0, 15
	move $a0, $s6
	la $a1, receiptForTinyCoffeeWithMilk
	li $a2, 50
	syscall
	#Close file
	li $v0, 16
	move $a0, $s6
	syscall
	j doEnd
	noSuficientTinyCoffeeWithMilkPowder:
		# powder is not enough!
		li $v0, 4				# syscall code to print a string
		la $a0, defaultMissing			# string to print
		syscall
		li $t0, 1
		sub $t0, $t0, $t2			# how much does the user need to get a tiny coffee with milk?
		li $v0, 1				# syscall code to print an integer value
		li $a0, 0
		add $a0, $a0, $t0			# set $a0 to $t0 and print how much powder the user will need to complete the transaction
		syscall
		li $v0, 4				# syscall code to print a string
		la $a0, coffeeMissing			# string to print
		syscall
		j doEnd
	noSuficientTinyMilkWithCoffeePowder:
		# powder is not enough!
		li $v0, 4				# syscall code to print a string
		la $a0, defaultMissing			# string to print
		syscall
		li $t0, 1
		sub $t0, $t0, $t3			# how much does the user need to get a tiny coffee?
		li $v0, 1				# syscall code to print an integer value
		li $a0, 0
		add $a0, $a0, $t0			# set $a0 to $t0 and print how much powder the user will need to complete the transaction
		syscall
		li $v0, 4				# syscall code to print a string
		la $a0, milkMissing			# string to print
		syscall
		j doEnd
	chooseBigCoffeeWithMilkCup:
		bne $v0, $t9, doEnd				# if v0 == 202 it means the user wants big cup, otherwise jump to the end of the loop
		sltiu $t0, $t2, 2				# set $t0 to 1 if powder is not enough
		bgtz $t0, noSuficientBigCoffeeWithMilkPowder
		sltiu $t0, $t3, 2				# set $t0 to 1 if powder is not enough
		bgtz $t0, noSuficientBigMilkWithCoffeePowder
		addi $t2, $t2, -2				# powder update
		addi $t3, $t3, -2				# powder update
		li $v0, 4					# syscall code to print a string
		la $a0, coffeewithmilk				# string to print
		syscall
		li $v0, 4					# syscall code to print a string
		la $a0, receipt					# string to print
		syscall
		li $v0, 4					# syscall code to print a string
		la $a0, receiptForBigCoffeeWithMilk		# string to print
		syscall
		#Open file
		li $v0, 13
		la $a0, fout
		li $a1, 1
		li $a2, 0
		syscall
		move $s6, $v0
		#Write at file
		li $v0, 15
		move $a0, $s6
		la $a1, receiptForBigCoffeeWithMilk
		li $a2, 50
		syscall
		#Close file
		li $v0, 16
		move $a0, $s6
		syscall
		j doEnd
		noSuficientBigCoffeeWithMilkPowder:
			# powder is not enough!
			li $v0, 4				# syscall code to print a string
			la $a0, defaultMissing			# string to print
			syscall
			li $t0, 2
			sub $t0, $t0, $t2			# how much does the user need to get a tiny coffee with milk?
			li $v0, 1				# syscall code to print an integer value
			li $a0, 0
			add $a0, $a0, $t0			# set $a0 to $t0 and print how much powder the user will need to complete the transaction
			syscall
			li $v0, 4				# syscall code to print a string
			la $a0, coffeeMissing			# string to print
			syscall
			j doEnd
		noSuficientBigMilkWithCoffeePowder:
			# powder is not enough!
			li $v0, 4				# syscall code to print a string
			la $a0, defaultMissing			# string to print
			syscall
			li $t0, 2
			sub $t0, $t0, $t3			# how much does the user need to get a tiny coffee?
			li $v0, 1				# syscall code to print an integer value
			li $a0, 0
			add $a0, $a0, $t0			# set $a0 to $t0 and print how much powder the user will need to complete the transaction
			syscall
			li $v0, 4				# syscall code to print a string
			la $a0, milkMissing			# string to print
			syscall
			j doEnd
			
checkHotChocolate:
	bne $v0, $t7, doEnd					# if v0 == 103 it means the user wants hot chocolate, otherwise jump to the end of the loop
	# Hot Chocolate has been chosen
	li $v0, 4						# syscall code to print a string
	la $a0, choosesize					# string to print
	syscall							# print it!
	li $v0, 5						# syscall code to read an integer value
	syscall							# wait the user input, it's going to be saved in $v0
	bne $v0, $t8, chooseBigHotChocolateCup			#if v0 == 201 it means the user wants tiny cup, otherwise jump to check if the user wrote the code to get a big cup (202)
	#Tiny cup has been chosen
	sltiu $t0, $t4, 1					# set $t0 to 1 if powder is not enough
	bgtz $t0, noSuficientTinyHotChocolatePowder
	addi $t4, $t4, -1					# hot chocolate powder update
	li $v0, 4						# syscall code to print a string
	la $a0, hotchocolate					# string to print
	syscall
	li $v0, 4					# syscall code to print a string
	la $a0, receipt					# string to print
	syscall
	li $v0, 4					# syscall code to print a string
	la $a0, receiptForTinyHotChocolate		# string to print
	syscall
	#Open file
	li $v0, 13
	la $a0, fout
	li $a1, 1
	li $a2, 0
	syscall
	move $s6, $v0
	#Write at file
	li $v0, 15
	move $a0, $s6
	la $a1, receiptForTinyHotChocolate
	li $a2, 50
	syscall
	#Close file
	li $v0, 16
	move $a0, $s6
	syscall
	j doEnd
	noSuficientTinyHotChocolatePowder:
		# powder is not enough!
		li $v0, 4					# syscall code to print a string
		la $a0, defaultMissing				# string to print
		syscall
		li $t0, 1
		sub $t0, $t0, $t4				# how much does the user need to get a tiny hot chocolate?
		li $v0, 1					# syscall code to print an integer value
		li $a0, 0
		add $a0, $a0, $t0				# set $a0 to $t0 and print how much chocolate powder the user will need to complete the transaction
		syscall
		li $v0, 4					# syscall code to print a string
		la $a0, chocolateMissing			# string to print
		syscall
		j doEnd
	chooseBigHotChocolateCup:
		bne $v0, $t9, doEnd				# if v0 == 202 it means the user wants big cup, otherwise jump to the end of the loop
		sltiu $t0, $t4, 2				# set $t0 to 1 if powder is not enough
		bgtz $t0, noSuficientBigHotChocolatePowder
		addi $t4, $t4, -2				# powder update
		li $v0, 4					# syscall code to print a string
		la $a0, hotchocolate				# string to print
		syscall
		li $v0, 4					# syscall code to print a string
		la $a0, receipt					# string to print
		syscall
		li $v0, 4					# syscall code to print a string
		la $a0, receiptForBigHotChocolate		# string to print
		syscall
		#Open file
		li $v0, 13
		la $a0, fout
		li $a1, 1
		li $a2, 0
		syscall
		move $s6, $v0
		#Write at file
		li $v0, 15
		move $a0, $s6
		la $a1, receiptForBigHotChocolate
		li $a2, 50
		syscall
		#Close file
		li $v0, 16
		move $a0, $s6
		syscall
		j doEnd
		noSuficientBigHotChocolatePowder:
			# powder is not enough!
			li $v0, 4				# syscall code to print a string
			la $a0, defaultMissing			# string to print
			syscall
			li $t0, 2
			sub $t0, $t0, $t4			# how much does the user need to get a big hot chocolate?
			li $v0, 1				# syscall code to print an integer value
			li $a0, 0
			add $a0, $a0, $t0			# set $a0 to $t0 and print how much chocolate powder the user will need to complete the transaction
			syscall
			li $v0, 4				# syscall code to print a string
			la $a0, chocolateMissing		# string to print
			syscall
			j doEnd
doEnd:
	li $v0, 4						# syscall code to print a string
	la $a0, powdersInfo					# string to print
	syscall
	li $v0, 4						# syscall code to print a string
	la $a0, currentCoffeePowder				# string to print
	syscall
	li $v0, 1						# syscall code to print an integer value
	li $a0, 0
	add $a0, $a0, $t2					# set $a0 to $t1 and print the current coffee powder
	syscall
	li $v0, 4						# syscall code to print a string
	la $a0, jumpLine					# string to print
	syscall
	li $v0, 4						# syscall code to print a string
	la $a0, currentMilkPowder				# string to print
	syscall
	li $v0, 1						# syscall code to print an integer value
	li $a0, 0
	add $a0, $a0, $t3					# set $a0 to $t1 and print the current coffee powder
	syscall
	li $v0, 4						# syscall code to print a string
	la $a0, jumpLine					# string to print
	syscall
	li $v0, 4						# syscall code to print a string
	la $a0, currentChocolatePowder				# string to print
	syscall
	li $v0, 1						# syscall code to print an integer value
	li $a0, 0
	add $a0, $a0, $t4					# set $a0 to $t1 and print the current coffee powder
	syscall
	li $v0, 4						# syscall code to print a string
	la $a0, waitingNextBuy					# string to print
	syscall
	li $v0, 4						# syscall code to print a string
	lw $t0, flag
	beq $t0, $0, do						# if t0 == 0 go back to the start of the loop, otherwise go to exit
exit:
	li $v0, 4						# syscall code to print a string
	la $a0, exitMsg						# string to print
	syscall
	li $v0, 10						# exit
	syscall
